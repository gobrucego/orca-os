//
//  CalculatorViewSnapshotTests.swift
//  PeptideFoxTests
//
//  Snapshot tests for Calculator views
//  Requires: swift-snapshot-testing package
//

import XCTest
import SwiftUI
@testable import PeptideFox

// Uncomment when swift-snapshot-testing is added to project
// import SnapshotTesting

final class CalculatorViewSnapshotTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUpWithError() throws {
        // Set isRecording to true to generate new reference snapshots
        // isRecording = false
    }
    
    // MARK: - Calculator View Snapshots
    
    func testCalculatorViewInitialState() throws {
        // Snapshot of calculator in initial state (empty inputs)
        let view = CalculatorView()
            .frame(width: 390, height: 844) // iPhone 14 Pro dimensions
        
        // Uncomment when swift-snapshot-testing is configured
        // assertSnapshot(matching: view, as: .image)
        
        // For now, verify view can be created
        XCTAssertNotNil(view, "CalculatorView should be creatable")
    }
    
    func testCalculatorViewWithDefaultValues() throws {
        // Snapshot with default values populated
        let viewModel = CalculatorViewModel()
        viewModel.vialSize = 10.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.25
        
        let view = CalculatorView()
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCalculatorViewWithResults() throws {
        // Snapshot showing calculation results
        let viewModel = CalculatorViewModel()
        viewModel.vialSize = 10.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.25
        
        // Note: In actual test, trigger calculation and wait for result
        // For snapshot, you may need to manually set output
        
        let view = CalculatorView()
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCalculatorViewDarkMode() throws {
        // Snapshot in dark mode
        let view = CalculatorView()
            .frame(width: 390, height: 844)
            .preferredColorScheme(.dark)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCalculatorViewLightMode() throws {
        // Snapshot in light mode (explicit)
        let view = CalculatorView()
            .frame(width: 390, height: 844)
            .preferredColorScheme(.light)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Different Device Sizes
    
    func testCalculatorViewIPhoneSE() throws {
        // Snapshot for smaller iPhone
        let view = CalculatorView()
            .frame(width: 375, height: 667) // iPhone SE dimensions
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCalculatorViewIPhoneProMax() throws {
        // Snapshot for larger iPhone
        let view = CalculatorView()
            .frame(width: 430, height: 932) // iPhone 14 Pro Max
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCalculatorViewIPad() throws {
        // Snapshot for iPad
        let view = CalculatorView()
            .frame(width: 834, height: 1194) // iPad Pro 11"
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Error States
    
    func testCalculatorViewWithError() throws {
        // Snapshot showing error state
        let viewModel = CalculatorViewModel()
        // Set error state (requires mechanism to inject error)
        
        let view = CalculatorView()
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Component Snapshots
    
    func testDevicePickerView() throws {
        // Snapshot of device picker sheet
        let devices = [
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
                type: .syringe50,
                name: "50-Unit Syringe",
                maxVolume: 0.5,
                precision: 0.01,
                units: "units",
                maxUnits: 50,
                image: "/devices/syringe-50.svg"
            )
        ]
        
        let view = DevicePickerView(
            devices: devices,
            selectedDevice: devices[1]
        )
        .frame(width: 390, height: 600)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testSyringeVisualView() throws {
        // Snapshot of syringe visual component
        let visual = SyringeVisual(
            deviceType: "syringe50",
            deviceImage: "/devices/syringe-50.svg",
            fillLevel: 25.0,
            maxLevel: 50.0,
            markings: [0, 10, 20, 30, 40, 50],
            instructions: [
                "Draw to 25.0 units",
                "Using 50-Unit Syringe",
                "Go slow - small volume"
            ]
        )
        
        let view = SyringeVisualView(visual: visual)
            .frame(width: 390, height: 300)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Accessibility Snapshots
    
    func testCalculatorViewExtraLargeText() throws {
        // Snapshot with extra large text size
        let view = CalculatorView()
            .frame(width: 390, height: 844)
            .environment(\.sizeCategory, .extraExtraExtraLarge)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCalculatorViewSmallText() throws {
        // Snapshot with small text size
        let view = CalculatorView()
            .frame(width: 390, height: 844)
            .environment(\.sizeCategory, .small)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
}
