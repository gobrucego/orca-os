//
//  Device.swift
//  PeptideFox
//
//  Device models for injection equipment and visual representations.
//  All types are Sendable for Swift 6.0 concurrency compliance.
//

import Foundation

// MARK: - Device

/// Represents an injection device with its specifications
public struct Device: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let type: CalculatorDeviceType
    public let name: String
    public let maxVolume: Double // in ml
    public let precision: Double // minimum measurable increment
    public let units: String // display units (e.g., "units", "ml")
    public let maxUnits: Int
    public let image: String // image asset name or URL
    
    public init(
        id: String = UUID().uuidString,
        type: CalculatorDeviceType,
        name: String,
        maxVolume: Double,
        precision: Double,
        units: String,
        maxUnits: Int,
        image: String
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.maxVolume = maxVolume
        self.precision = precision
        self.units = units
        self.maxUnits = maxUnits
        self.image = image
    }
    
    /// Check if a volume can be accurately measured with this device
    public func canMeasure(volume: Double) -> Bool {
        guard volume > 0 && volume <= maxVolume else { return false }
        // Check if volume is a multiple of precision
        let remainder = volume.truncatingRemainder(dividingBy: precision)
        return remainder < 0.0001 // Allow for floating point imprecision
    }
    
    /// Convert volume to device units
    public func volumeToUnits(_ volume: Double) -> Int {
        guard maxVolume > 0 else { return 0 }
        return Int((volume / maxVolume) * Double(maxUnits))
    }
    
    /// Convert units to volume
    public func unitsToVolume(_ deviceUnits: Int) -> Double {
        guard maxUnits > 0 else { return 0 }
        return (Double(deviceUnits) / Double(maxUnits)) * maxVolume
    }
    
    /// Get the nearest measurable volume
    public func nearestMeasurableVolume(_ targetVolume: Double) -> Double {
        let units = volumeToUnits(targetVolume)
        return unitsToVolume(units)
    }
    
    /// Check if this is a syringe device
    public var isSyringe: Bool {
        switch type {
        case .syringe30, .syringe50, .syringe100:
            return true
        case .pen:
            return false
        }
    }
    
    /// Check if this is a pen device
    public var isPen: Bool {
        type == .pen
    }
}

// MARK: - Common Devices

extension Device {
    /// 30-unit insulin syringe
    public static let insulinSyringe30 = Device(
        type: .syringe30,
        name: "30-Unit Insulin Syringe",
        maxVolume: 0.3,
        precision: 0.01,
        units: "units",
        maxUnits: 30,
        image: "syringe-30"
    )
    
    /// 50-unit insulin syringe
    public static let insulinSyringe50 = Device(
        type: .syringe50,
        name: "50-Unit Insulin Syringe",
        maxVolume: 0.5,
        precision: 0.01,
        units: "units",
        maxUnits: 50,
        image: "syringe-50"
    )
    
    /// 100-unit insulin syringe (1ml)
    public static let insulinSyringe100 = Device(
        type: .syringe100,
        name: "100-Unit Insulin Syringe",
        maxVolume: 1.0,
        precision: 0.01,
        units: "units",
        maxUnits: 100,
        image: "syringe-100"
    )
    
    /// Injection pen device
    public static let injectionPen = Device(
        type: .pen,
        name: "Injection Pen",
        maxVolume: 3.0,
        precision: 0.01,
        units: "units",
        maxUnits: 300,
        image: "pen"
    )
    
    /// All available devices
    public static let all: [Device] = [
        .insulinSyringe30,
        .insulinSyringe50,
        .insulinSyringe100,
        .injectionPen
    ]
    
    /// Get device by type
    public static func byType(_ type: CalculatorDeviceType) -> Device? {
        all.first { $0.type == type }
    }
}

// MARK: - Syringe Visual

/// Visual representation of a syringe with fill level and markings
public struct SyringeVisual: Codable, Sendable, Hashable {
    public let deviceType: String
    public let deviceImage: String
    public let fillLevel: Double // 0.0 to 1.0
    public let maxLevel: Double // maximum fill level (usually 1.0)
    public let markings: [Int] // unit markings to display
    public let instructions: [String] // step-by-step instructions
    
    public init(
        deviceType: String,
        deviceImage: String,
        fillLevel: Double,
        maxLevel: Double = 1.0,
        markings: [Int],
        instructions: [String]
    ) {
        self.deviceType = deviceType
        self.deviceImage = deviceImage
        self.fillLevel = min(max(fillLevel, 0), maxLevel) // Clamp to valid range
        self.maxLevel = maxLevel
        self.markings = markings
        self.instructions = instructions
    }
    
    /// Fill percentage (0-100)
    public var fillPercentage: Int {
        Int(fillLevel * 100)
    }
    
    /// Check if syringe is overfilled
    public var isOverfilled: Bool {
        fillLevel > 1.0
    }
    
    /// Check if syringe is empty
    public var isEmpty: Bool {
        fillLevel <= 0.0
    }
    
    /// Primary instruction (first one)
    public var primaryInstruction: String? {
        instructions.first
    }
    
    /// Create markings for a specific device type
    public static func markings(for device: Device) -> [Int] {
        switch device.type {
        case .syringe30:
            return [0, 5, 10, 15, 20, 25, 30]
        case .syringe50:
            return [0, 10, 20, 30, 40, 50]
        case .syringe100:
            return [0, 20, 40, 60, 80, 100]
        case .pen:
            return [0, 50, 100, 150, 200, 250, 300]
        }
    }
}

// MARK: - Suggestion

/// Optimization or warning suggestion for device/dosing
public struct Suggestion: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let type: SuggestionType
    public let title: String
    public let message: String
    public let actions: [SuggestionAction]
    
    public init(
        id: String = UUID().uuidString,
        type: SuggestionType,
        title: String,
        message: String,
        actions: [SuggestionAction] = []
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.actions = actions
    }
    
    /// Check if suggestion has actions
    public var hasActions: Bool {
        !actions.isEmpty
    }
    
    /// Primary action (first one)
    public var primaryAction: SuggestionAction? {
        actions.first
    }
    
    /// Check if this is a warning
    public var isWarning: Bool {
        type == .warning
    }
    
    /// Check if this is an optimization
    public var isOptimization: Bool {
        type == .optimization
    }
}

// MARK: - Suggestion Action

/// An actionable item within a suggestion
public struct SuggestionAction: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public let label: String
    public let impact: String
    public let actionType: ActionType?
    
    public enum ActionType: String, Codable, Sendable {
        case changeDevice
        case adjustVolume
        case adjustConcentration
        case splitDose
        case combineDose
    }
    
    public init(
        id: String = UUID().uuidString,
        label: String,
        impact: String,
        actionType: ActionType? = nil
    ) {
        self.id = id
        self.label = label
        self.impact = impact
        self.actionType = actionType
    }
    
    /// Check if this is a device change action
    public var isDeviceChange: Bool {
        actionType == .changeDevice
    }
    
    /// Check if this is a volume adjustment
    public var isVolumeAdjustment: Bool {
        actionType == .adjustVolume || actionType == .adjustConcentration
    }
}

// MARK: - Device Recommendation

/// Recommendation for device selection based on requirements
public struct DeviceRecommendation: Sendable {
    public let recommendedDevice: Device
    public let compatibleDevices: [Device]
    public let reasons: [String]
    public let warnings: [String]
    
    public init(
        recommendedDevice: Device,
        compatibleDevices: [Device],
        reasons: [String] = [],
        warnings: [String] = []
    ) {
        self.recommendedDevice = recommendedDevice
        self.compatibleDevices = compatibleDevices
        self.reasons = reasons
        self.warnings = warnings
    }
    
    /// Check if only one device is compatible
    public var hasLimitedOptions: Bool {
        compatibleDevices.count <= 1
    }
    
    /// Check if recommended device is the only option
    public var isOnlyOption: Bool {
        compatibleDevices.count == 1 && compatibleDevices.first?.id == recommendedDevice.id
    }
    
    /// Get alternative devices (excluding recommended)
    public var alternatives: [Device] {
        compatibleDevices.filter { $0.id != recommendedDevice.id }
    }
}
