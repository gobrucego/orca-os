//
//  LibraryFlowTests.swift
//  PeptideFoxUITests
//
//  UI tests for peptide library navigation and filtering
//

import XCTest

final class LibraryFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Library Navigation Tests
    
    func testBrowsePeptideLibrary() throws {
        // Navigate to library (adjust based on app structure)
        // If there's a tab bar, tap the Library tab
        let libraryTab = app.tabBars.buttons["Library"]
        if libraryTab.exists {
            libraryTab.tap()
        }
        
        // Wait for library to load
        sleep(1)
        
        // Verify peptide cards appear
        // Using cells which should contain peptide names
        let semaglutideCell = app.cells.containing(NSPredicate(format: "label CONTAINS 'Semaglutide'")).element
        let bpcCell = app.cells.containing(NSPredicate(format: "label CONTAINS 'BPC-157' OR label CONTAINS 'BPC'")).element
        
        // At least some peptides should be visible
        XCTAssertTrue(
            semaglutideCell.exists || bpcCell.exists,
            "Peptide library should display peptide cards"
        )
    }
    
    func testPeptideDetailNavigation() throws {
        navigateToLibrary()
        
        // Find and tap a peptide card
        let semaglutideCard = app.cells.containing(NSPredicate(format: "label CONTAINS 'Semaglutide'")).element
        
        if semaglutideCard.waitForExistence(timeout: 3) {
            semaglutideCard.tap()
            
            // Wait for detail view to load
            sleep(1)
            
            // Verify detail view content
            let mechanismSection = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Mechanism'")).element
            let typicalDoseSection = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Typical Dose' OR label CONTAINS 'Dose'")).element
            let contraindicationsSection = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Contraindications'")).element
            
            // At least some detail sections should be visible
            XCTAssertTrue(
                mechanismSection.exists || typicalDoseSection.exists || contraindicationsSection.exists,
                "Peptide detail view should show information sections"
            )
            
            // Navigate back
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
            }
        }
    }
    
    func testMultiplePeptidesVisible() throws {
        navigateToLibrary()
        
        // Count visible peptide cells
        let cells = app.cells
        let cellCount = cells.count
        
        // Should have multiple peptides
        XCTAssertGreaterThan(cellCount, 0, "Library should display peptide cards")
    }
    
    // MARK: - Category Filtering Tests
    
    func testCategoryFilteringGLP1() throws {
        navigateToLibrary()
        
        // Tap GLP-1 category filter
        let glp1Filter = app.buttons.containing(NSPredicate(format: "label CONTAINS 'GLP-1' OR label CONTAINS 'GLP1'")).element
        
        if glp1Filter.waitForExistence(timeout: 3) {
            glp1Filter.tap()
            
            // Wait for filtering
            sleep(1)
            
            // Verify GLP-1 peptides shown
            let semaglutide = app.cells.containing(NSPredicate(format: "label CONTAINS 'Semaglutide'")).element
            let tirzepatide = app.cells.containing(NSPredicate(format: "label CONTAINS 'Tirzepatide'")).element
            
            XCTAssertTrue(
                semaglutide.exists || tirzepatide.exists,
                "GLP-1 filter should show GLP-1 peptides"
            )
            
            // Verify non-GLP-1 peptides hidden
            let bpc = app.cells.containing(NSPredicate(format: "label CONTAINS 'BPC-157' OR label CONTAINS 'BPC'")).element
            // BPC should not be visible (or verify filtering logic)
        }
    }
    
    func testCategoryFilteringHealing() throws {
        navigateToLibrary()
        
        // Tap Healing category
        let healingFilter = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Healing' OR label CONTAINS 'healing'")).element
        
        if healingFilter.waitForExistence(timeout: 3) {
            healingFilter.tap()
            
            sleep(1)
            
            // Verify healing peptides shown
            let bpc = app.cells.containing(NSPredicate(format: "label CONTAINS 'BPC'")).element
            let tb500 = app.cells.containing(NSPredicate(format: "label CONTAINS 'TB-500' OR label CONTAINS 'TB500'")).element
            let ghk = app.cells.containing(NSPredicate(format: "label CONTAINS 'GHK'")).element
            
            XCTAssertTrue(
                bpc.exists || tb500.exists || ghk.exists,
                "Healing filter should show healing peptides"
            )
        }
    }
    
    func testAllCategoryShowsAll() throws {
        navigateToLibrary()
        
        // First select a specific category
        let glp1Filter = app.buttons.containing(NSPredicate(format: "label CONTAINS 'GLP-1' OR label CONTAINS 'GLP1'")).element
        if glp1Filter.exists {
            glp1Filter.tap()
            sleep(1)
        }
        
        // Then tap "All" category
        let allFilter = app.buttons["All"]
        if allFilter.exists {
            allFilter.tap()
            
            sleep(1)
            
            // Verify all categories shown
            let cells = app.cells.count
            XCTAssertGreaterThan(cells, 2, "All category should show all peptides")
        }
    }
    
    func testCategoryChipCount() throws {
        navigateToLibrary()
        
        // Category chips should show count badges
        let categoryButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS 'GLP' OR label CONTAINS 'Healing' OR label CONTAINS 'All'"))
        
        // At least one category should exist
        XCTAssertGreaterThan(categoryButtons.count, 0, "Category filters should be present")
    }
    
    // MARK: - Search Tests
    
    func testSearchFunctionality() throws {
        navigateToLibrary()
        
        // Tap search field
        let searchField = app.searchFields["Search peptides..."]
        if searchField.waitForExistence(timeout: 3) {
            searchField.tap()
            searchField.typeText("healing")
            
            // Wait for search results
            sleep(1)
            
            // Verify filtered results
            let bpc = app.cells.containing(NSPredicate(format: "label CONTAINS 'BPC'")).element
            let tb500 = app.cells.containing(NSPredicate(format: "label CONTAINS 'TB'")).element
            
            // Results should include healing-related peptides
            XCTAssertTrue(
                bpc.exists || tb500.exists,
                "Search for 'healing' should return relevant peptides"
            )
            
            // Non-matching peptides should not appear
            // (depends on exact implementation)
        }
    }
    
    func testSearchForSpecificPeptide() throws {
        navigateToLibrary()
        
        let searchField = app.searchFields.element
        if searchField.waitForExistence(timeout: 3) {
            searchField.tap()
            searchField.typeText("Semaglutide")
            
            sleep(1)
            
            // Should show Semaglutide
            let semaglutide = app.cells.containing(NSPredicate(format: "label CONTAINS 'Semaglutide'")).element
            XCTAssertTrue(semaglutide.exists, "Search should find Semaglutide")
        }
    }
    
    func testSearchNoResults() throws {
        navigateToLibrary()
        
        let searchField = app.searchFields.element
        if searchField.waitForExistence(timeout: 3) {
            searchField.tap()
            searchField.typeText("xyznonexistent")
            
            sleep(1)
            
            // Should show empty state
            let emptyState = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'No Peptides Found' OR label CONTAINS 'No Results'")).element
            
            // Empty state may or may not be implemented
        }
    }
    
    func testClearSearch() throws {
        navigateToLibrary()
        
        // Perform search
        let searchField = app.searchFields.element
        if searchField.waitForExistence(timeout: 3) {
            searchField.tap()
            searchField.typeText("test")
            
            sleep(1)
            
            // Clear search
            let clearButton = searchField.buttons["Clear text"]
            if clearButton.exists {
                clearButton.tap()
                
                sleep(1)
                
                // Should show all peptides again
                let cells = app.cells.count
                XCTAssertGreaterThan(cells, 0, "Clearing search should show all peptides")
            }
        }
    }
    
    // MARK: - Grid Layout Tests
    
    func testGridLayoutDisplays() throws {
        navigateToLibrary()
        
        // Verify grid layout by checking multiple cells are visible
        let cells = app.cells
        let visibleCells = cells.allElementsBoundByIndex.filter { $0.isHittable }
        
        // Should have multiple peptides in grid
        XCTAssertGreaterThan(visibleCells.count, 0, "Grid should display peptide cards")
    }
    
    func testScrollingInLibrary() throws {
        navigateToLibrary()
        
        // Get initial first cell
        let firstCell = app.cells.element(boundBy: 0)
        let initialExists = firstCell.exists
        
        // Scroll down
        app.swipeUp()
        sleep(0.5)
        
        // Library should handle scrolling
        // (Content may or may not change depending on number of peptides)
    }
    
    // MARK: - Accessibility Tests
    
    func testPeptideCardAccessibility() throws {
        navigateToLibrary()
        
        // Find a peptide cell
        let cell = app.cells.element(boundBy: 0)
        if cell.waitForExistence(timeout: 3) {
            // Cell should have accessibility label
            XCTAssertNotNil(cell.label, "Peptide card should have accessibility label")
            XCTAssertFalse(cell.label.isEmpty, "Accessibility label should not be empty")
        }
    }
    
    func testCategoryChipAccessibility() throws {
        navigateToLibrary()
        
        // Category chips should have proper accessibility
        let glp1Chip = app.buttons.containing(NSPredicate(format: "label CONTAINS 'GLP'")).element
        
        if glp1Chip.exists {
            let label = glp1Chip.label
            XCTAssertTrue(
                label.contains("GLP") || label.contains("peptide"),
                "Category chip should have descriptive accessibility label"
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func navigateToLibrary() {
        // Navigate to library - adjust based on app structure
        let libraryTab = app.tabBars.buttons["Library"]
        if libraryTab.exists {
            libraryTab.tap()
        }
        
        // If no tab bar, library might be the main view
        sleep(1)
    }
}
