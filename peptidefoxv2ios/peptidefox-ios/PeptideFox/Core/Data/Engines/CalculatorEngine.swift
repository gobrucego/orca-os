import Foundation

// MARK: - Types

/// Device types for injection delivery
public enum DeviceType: String, Codable, Sendable {
    case pen
    case syringe30
    case syringe50
    case syringe100
}

/// Injection device with specifications
public struct Device: Codable, Sendable, Hashable {
    public let type: DeviceType
    public let name: String
    public let maxVolume: Double
    public let precision: Double
    public let units: String
    public let maxUnits: Double
    public let image: String
    
    public init(
        type: DeviceType,
        name: String,
        maxVolume: Double,
        precision: Double,
        units: String,
        maxUnits: Double,
        image: String
    ) {
        self.type = type
        self.name = name
        self.maxVolume = maxVolume
        self.precision = precision
        self.units = units
        self.maxUnits = maxUnits
        self.image = image
    }
}

/// Frequency schedule for dosing
public struct FrequencySchedule: Codable, Sendable, Hashable {
    public let intervalDays: Int
    public let injectionsPerWeek: Int
    public let pattern: String
    public let specificDays: [String]?
    
    public init(
        intervalDays: Int,
        injectionsPerWeek: Int,
        pattern: String = "daily",
        specificDays: [String]? = nil
    ) {
        self.intervalDays = intervalDays
        self.injectionsPerWeek = injectionsPerWeek
        self.pattern = pattern
        self.specificDays = specificDays
    }
}

/// Input parameters for calculation
public struct CalculatorInput: Sendable {
    public let vialSize: Double
    public let reconstitutionVolume: Double
    public let targetDose: Double
    public let frequency: FrequencySchedule
    
    public init(
        vialSize: Double,
        reconstitutionVolume: Double,
        targetDose: Double,
        frequency: FrequencySchedule
    ) {
        self.vialSize = vialSize
        self.reconstitutionVolume = reconstitutionVolume
        self.targetDose = targetDose
        self.frequency = frequency
    }
}

/// Syringe visual guide
public struct SyringeVisual: Sendable {
    public let deviceType: String
    public let deviceImage: String
    public let fillLevel: Double
    public let maxLevel: Double
    public let markings: [Double]
    public let instructions: [String]
    
    public init(
        deviceType: String,
        deviceImage: String,
        fillLevel: Double,
        maxLevel: Double,
        markings: [Double],
        instructions: [String]
    ) {
        self.deviceType = deviceType
        self.deviceImage = deviceImage
        self.fillLevel = fillLevel
        self.maxLevel = maxLevel
        self.markings = markings
        self.instructions = instructions
    }
}

/// Optimization suggestion
public struct Suggestion: Sendable {
    public let type: SuggestionType
    public let title: String
    public let message: String
    public let actions: [Action]
    
    public enum SuggestionType: String, Sendable {
        case warning
        case info
        case optimization
    }
    
    public struct Action: Sendable {
        public let label: String
        public let impact: String
        
        public init(label: String, impact: String) {
            self.label = label
            self.impact = impact
        }
    }
    
    public init(
        type: SuggestionType,
        title: String,
        message: String,
        actions: [Action]
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.actions = actions
    }
}

/// Complete calculation output
public struct CalculatorOutput: Sendable {
    public let concentration: Double
    public let drawVolume: Double
    public let drawUnits: Double
    public let compatibleDevices: [Device]
    public let recommendedDevice: Device
    public let dosesPerVial: Int
    public let daysPerVial: Int
    public let vialsPerMonth: Int
    public let monthlyVials: Int
    public let syringeVisual: SyringeVisual
    public let suggestions: [Suggestion]
    public let warnings: [String]
    
    public init(
        concentration: Double,
        drawVolume: Double,
        drawUnits: Double,
        compatibleDevices: [Device],
        recommendedDevice: Device,
        dosesPerVial: Int,
        daysPerVial: Int,
        vialsPerMonth: Int,
        monthlyVials: Int,
        syringeVisual: SyringeVisual,
        suggestions: [Suggestion],
        warnings: [String]
    ) {
        self.concentration = concentration
        self.drawVolume = drawVolume
        self.drawUnits = drawUnits
        self.compatibleDevices = compatibleDevices
        self.recommendedDevice = recommendedDevice
        self.dosesPerVial = dosesPerVial
        self.daysPerVial = daysPerVial
        self.vialsPerMonth = vialsPerMonth
        self.monthlyVials = monthlyVials
        self.syringeVisual = syringeVisual
        self.suggestions = suggestions
        self.warnings = warnings
    }
}

/// Calculator errors with recovery suggestions
public enum CalculatorError: Error, LocalizedError {
    case volumeTooLarge(suggestions: [String])
    case invalidInput(String)
    
    public var errorDescription: String? {
        switch self {
        case .volumeTooLarge:
            return "Dose volume too large for any device"
        case .invalidInput(let message):
            return message
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .volumeTooLarge(let suggestions):
            return suggestions.joined(separator: "\n")
        case .invalidInput:
            return nil
        }
    }
}

// MARK: - CalculatorEngine Actor

/// Thread-safe calculator engine for dose calculations
/// Port of lib/protocol/calculator.ts
public actor CalculatorEngine {
    
    // MARK: - Device Database
    
    private let devices: [Device] = [
        Device(
            type: .pen,
            name: "Insulin Pen",
            maxVolume: 0.5,
            precision: 0.01,
            units: "clicks",
            maxUnits: 50,
            image: "/devices/pen.svg"
        ),
        Device(
            type: .syringe30,
            name: "30-Unit Syringe",
            maxVolume: 0.3,
            precision: 0.01,
            units: "units",
            maxUnits: 30,
            image: "/devices/syringe-30.svg"
        ),
        Device(
            type: .syringe50,
            name: "50-Unit Syringe",
            maxVolume: 0.5,
            precision: 0.01,
            units: "units",
            maxUnits: 50,
            image: "/devices/syringe-50.svg"
        ),
        Device(
            type: .syringe100,
            name: "100-Unit Syringe",
            maxVolume: 1.0,
            precision: 0.02,
            units: "units",
            maxUnits: 100,
            image: "/devices/syringe-100.svg"
        )
    ]
    
    // MARK: - Public Interface
    
    public init() {}
    
    /// Calculate dose parameters with device recommendations
    public func calculate(input: CalculatorInput) throws -> CalculatorOutput {
        // Validate input
        guard input.vialSize > 0 else {
            throw CalculatorError.invalidInput("Vial size must be greater than 0")
        }
        guard input.reconstitutionVolume > 0 else {
            throw CalculatorError.invalidInput("Reconstitution volume must be greater than 0")
        }
        guard input.targetDose > 0 else {
            throw CalculatorError.invalidInput("Target dose must be greater than 0")
        }
        
        // Core calculations
        let concentration = input.vialSize / input.reconstitutionVolume // mg/ml
        let drawVolume = input.targetDose / concentration // ml
        
        // Find compatible devices
        let compatibleDevices = getCompatibleDevices(volume: drawVolume)
        
        if compatibleDevices.isEmpty {
            let suggestions = [
                "Increase reconstitution to \(suggestVolume(targetDose: input.targetDose, maxDrawVolume: 0.5))ml",
                "Split dose into two injections",
                "Use multiple syringes"
            ]
            throw CalculatorError.volumeTooLarge(suggestions: suggestions)
        }
        
        // Supply calculations (frequency-aware)
        let dosesPerVial = Int(floor(input.vialSize / input.targetDose))
        let daysPerVial = dosesPerVial * input.frequency.intervalDays
        let vialsPerMonth = Int(ceil(30.0 / Double(daysPerVial)))
        
        // Generate visual guide
        let primaryDevice = compatibleDevices[0]
        let syringeVisual = generateSyringeVisual(drawVolume: drawVolume, device: primaryDevice)
        
        // Generate suggestions
        let suggestions = generateSuggestions(input: input, drawVolume: drawVolume)
        
        // Check warnings
        let warnings = checkWarnings(drawVolume: drawVolume)
        
        return CalculatorOutput(
            concentration: concentration,
            drawVolume: drawVolume,
            drawUnits: mlToUnits(ml: drawVolume, device: primaryDevice),
            compatibleDevices: compatibleDevices,
            recommendedDevice: primaryDevice,
            dosesPerVial: dosesPerVial,
            daysPerVial: daysPerVial,
            vialsPerMonth: vialsPerMonth,
            monthlyVials: vialsPerMonth,
            syringeVisual: syringeVisual,
            suggestions: suggestions,
            warnings: warnings
        )
    }
    
    // MARK: - Device Compatibility
    
    /// Get devices compatible with the given volume
    public func getCompatibleDevices(volume: Double) -> [Device] {
        return devices.filter { volume <= $0.maxVolume }
    }
    
    // MARK: - Unit Conversion
    
    /// Convert ml to device-specific units
    public func mlToUnits(ml: Double, device: Device) -> Double {
        switch device.type {
        case .syringe30:
            return ml * 100 // 30 units = 0.3ml
        case .syringe50:
            return ml * 100 // 50 units = 0.5ml
        case .syringe100:
            return ml * 100 // 100 units = 1ml
        case .pen:
            return round(ml / 0.01) // Clicks
        }
    }
    
    // MARK: - Syringe Visual
    
    /// Generate syringe visual guide
    public func generateSyringeVisual(drawVolume: Double, device: Device) -> SyringeVisual {
        let units = mlToUnits(ml: drawVolume, device: device)
        var instructions: [String] = [
            "Draw to \(String(format: "%.1f", units)) \(device.units)",
            "Using \(device.name)"
        ]
        
        if drawVolume < 0.05 {
            instructions.append("Go slow - small volume")
        }
        
        return SyringeVisual(
            deviceType: device.type.rawValue,
            deviceImage: device.image,
            fillLevel: units,
            maxLevel: device.maxUnits,
            markings: generateMarkings(device: device),
            instructions: instructions
        )
    }
    
    private func generateMarkings(device: Device) -> [Double] {
        var markings: [Double] = []
        let step: Double = device.type == .pen ? 5 : 10
        
        var i: Double = 0
        while i <= device.maxUnits {
            markings.append(i)
            i += step
        }
        
        return markings
    }
    
    // MARK: - Suggestions System
    
    /// Generate optimization suggestions
    public func generateSuggestions(input: CalculatorInput, drawVolume: Double) -> [Suggestion] {
        var suggestions: [Suggestion] = []
        
        // Volume too small
        if drawVolume < 0.05 {
            suggestions.append(Suggestion(
                type: .warning,
                title: "Very small volume",
                message: "May be hard to measure accurately",
                actions: [
                    Suggestion.Action(
                        label: "Use \(input.reconstitutionVolume * 2)ml water instead",
                        impact: "Doubles the draw volume for easier measurement"
                    )
                ]
            ))
        }
        
        // Close to device limit
        if drawVolume > 0.4 && drawVolume <= 0.5 {
            suggestions.append(Suggestion(
                type: .info,
                title: "Near pen limit",
                message: "Consider using syringe for flexibility",
                actions: [
                    Suggestion.Action(
                        label: "Switch to 100-unit syringe",
                        impact: "More room for dose adjustments"
                    )
                ]
            ))
        }
        
        // Optimal reconstitution
        let optimal = calculateOptimalReconstitution(
            vialSize: input.vialSize,
            targetDose: input.targetDose
        )
        if abs(optimal - input.reconstitutionVolume) > 0.5 {
            suggestions.append(Suggestion(
                type: .optimization,
                title: "Reconstitution suggestion",
                message: "\(optimal)ml might be easier to work with",
                actions: [
                    Suggestion.Action(
                        label: "Try \(optimal)ml",
                        impact: "Results in round numbers for drawing"
                    )
                ]
            ))
        }
        
        return suggestions
    }
    
    // MARK: - Warnings
    
    /// Check for warning conditions
    public func checkWarnings(drawVolume: Double) -> [String] {
        var warnings: [String] = []
        
        if drawVolume < 0.03 {
            warnings.append("Volume may be too small to measure accurately")
        }
        
        if drawVolume > 0.8 {
            warnings.append("Large injection volume - consider splitting")
        }
        
        return warnings
    }
    
    // MARK: - Optimal Reconstitution
    
    /// Calculate optimal reconstitution volume for round unit numbers
    public func calculateOptimalReconstitution(vialSize: Double, targetDose: Double) -> Double {
        // Try to get a nice round number of units
        let concentrations: [Double] = [1, 2, 2.5, 5, 10]
        
        for conc in concentrations {
            let volume = vialSize / conc
            let drawVol = targetDose / conc
            
            if drawVol >= 0.1 && drawVol <= 0.5 {
                let units = drawVol * 100
                if units.truncatingRemainder(dividingBy: 5) == 0 {
                    return volume
                }
            }
        }
        
        return vialSize / 2 // Default fallback
    }
    
    // MARK: - Private Helpers
    
    private func suggestVolume(targetDose: Double, maxDrawVolume: Double) -> Double {
        let minConcentration = targetDose / maxDrawVolume
        let vialSizeGuess: Double = 10 // Assume 10mg vial
        return ceil(vialSizeGuess / minConcentration)
    }
}
