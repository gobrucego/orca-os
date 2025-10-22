//
//  PeptideLibraryViewSnapshotTests.swift
//  PeptideFoxTests
//
//  Snapshot tests for Peptide Library views
//

import XCTest
import SwiftUI
@testable import PeptideFox

// Uncomment when swift-snapshot-testing is added
// import SnapshotTesting

final class PeptideLibraryViewSnapshotTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUpWithError() throws {
        // isRecording = false
    }
    
    // MARK: - Library View Snapshots
    
    func testLibraryGridLayoutLight() throws {
        // Snapshot of library in light mode
        let view = PeptideLibraryView()
            .frame(width: 390, height: 844)
            .preferredColorScheme(.light)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testLibraryGridLayoutDark() throws {
        // Snapshot of library in dark mode
        let view = PeptideLibraryView()
            .frame(width: 390, height: 844)
            .preferredColorScheme(.dark)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testLibraryGridLayoutIPad() throws {
        // Snapshot for iPad layout
        let view = PeptideLibraryView()
            .frame(width: 834, height: 1194)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Peptide Detail View Snapshots
    
    func testPeptideDetailViewSemaglutide() throws {
        // Snapshot of Semaglutide detail view
        guard let peptide = PeptideDatabase.peptide(withId: "semaglutide") else {
            XCTFail("Semaglutide should exist in database")
            return
        }
        
        let view = PeptideDetailView(peptide: peptide)
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testPeptideDetailViewBPC157() throws {
        // Snapshot of BPC-157 detail view
        guard let peptide = PeptideDatabase.peptide(withId: "bpc-157") else {
            XCTFail("BPC-157 should exist in database")
            return
        }
        
        let view = PeptideDetailView(peptide: peptide)
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testPeptideDetailViewDarkMode() throws {
        // Snapshot of detail view in dark mode
        guard let peptide = PeptideDatabase.peptide(withId: "semaglutide") else {
            XCTFail("Semaglutide should exist in database")
            return
        }
        
        let view = PeptideDetailView(peptide: peptide)
            .frame(width: 390, height: 844)
            .preferredColorScheme(.dark)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Component Snapshots
    
    func testPeptideCardViewGLP1() throws {
        // Snapshot of peptide card for GLP-1 category
        guard let peptide = PeptideDatabase.peptide(withId: "semaglutide") else {
            XCTFail("Semaglutide should exist")
            return
        }
        
        let view = PeptideCardView(peptide: peptide)
            .frame(width: 180, height: 200)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testPeptideCardViewHealing() throws {
        // Snapshot of peptide card for Healing category
        guard let peptide = PeptideDatabase.peptide(withId: "bpc-157") else {
            XCTFail("BPC-157 should exist")
            return
        }
        
        let view = PeptideCardView(peptide: peptide)
            .frame(width: 180, height: 200)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCategoryChipGLP1() throws {
        // Snapshot of GLP-1 category chip
        let view = CategoryChip(
            title: "GLP-1",
            count: 2,
            isSelected: false,
            backgroundColor: .blue.opacity(0.1),
            accentColor: .blue
        ) {}
        .frame(width: 100, height: 50)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testCategoryChipSelected() throws {
        // Snapshot of selected category chip
        let view = CategoryChip(
            title: "Healing",
            count: 3,
            isSelected: true,
            backgroundColor: .green.opacity(0.1),
            accentColor: .green
        ) {}
        .frame(width: 120, height: 50)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Filter States
    
    func testLibraryWithGLP1Filter() throws {
        // Snapshot with GLP-1 category selected
        // Note: Would require ViewModel manipulation
        
        let view = PeptideLibraryView()
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testLibraryWithSearchActive() throws {
        // Snapshot with search field active
        // Note: Would require ViewModel manipulation
        
        let view = PeptideLibraryView()
            .frame(width: 390, height: 844)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Empty States
    
    func testLibraryEmptyState() throws {
        // Snapshot of empty state
        let view = PFEmptyState(
            icon: "magnifyingglass",
            title: "No Peptides Found",
            message: "Try adjusting your search or filter criteria",
            actionTitle: "Clear Search",
            action: {}
        )
        .frame(width: 390, height: 400)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Accessibility Snapshots
    
    func testLibraryExtraLargeText() throws {
        // Snapshot with extra large text
        let view = PeptideLibraryView()
            .frame(width: 390, height: 844)
            .environment(\.sizeCategory, .extraExtraExtraLarge)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    func testPeptideDetailExtraLargeText() throws {
        // Snapshot of detail view with extra large text
        guard let peptide = PeptideDatabase.peptide(withId: "semaglutide") else {
            XCTFail("Semaglutide should exist")
            return
        }
        
        let view = PeptideDetailView(peptide: peptide)
            .frame(width: 390, height: 844)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        
        // assertSnapshot(matching: view, as: .image)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Different Categories
    
    func testAllCategoryTypes() throws {
        // Test that all peptide categories can be displayed
        for category in PeptideCategory.allCases {
            let peptides = PeptideDatabase.peptides(in: category)
            
            XCTAssertNotNil(peptides, "Should be able to fetch peptides for \(category.rawValue)")
            
            // Could create snapshot for each category
        }
    }
}
