//
//  ViewModelTests.swift
//  PeptideFoxTests
//
//  Unit tests for ViewModels
//

import XCTest
@testable import PeptideFox

@MainActor
final class CalculatorViewModelTests: XCTestCase {
    var viewModel: CalculatorViewModel!
    
    override func setUpWithError() throws {
        viewModel = CalculatorViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertEqual(viewModel.vialSize, 10.0, "Initial vial size should be 10mg")
        XCTAssertEqual(viewModel.reconstitutionVolume, 2.0, "Initial reconstitution should be 2ml")
        XCTAssertEqual(viewModel.targetDose, 0.25, "Initial target dose should be 0.25mg")
        XCTAssertEqual(viewModel.selectedFrequency.pattern, "weekly", "Initial frequency should be weekly")
        XCTAssertNil(viewModel.output, "Initial output should be nil")
        XCTAssertNil(viewModel.error, "Initial error should be nil")
        XCTAssertFalse(viewModel.isCalculating, "Should not be calculating initially")
    }
    
    // MARK: - Can Calculate Tests
    
    func testCanCalculateWithValidInputs() {
        viewModel.vialSize = 10.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.25
        
        XCTAssertTrue(viewModel.canCalculate, "Should be able to calculate with valid inputs")
    }
    
    func testCannotCalculateWithZeroVialSize() {
        viewModel.vialSize = 0.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.25
        
        XCTAssertFalse(viewModel.canCalculate, "Should not be able to calculate with zero vial size")
    }
    
    func testCannotCalculateWithZeroReconstitution() {
        viewModel.vialSize = 10.0
        viewModel.reconstitutionVolume = 0.0
        viewModel.targetDose = 0.25
        
        XCTAssertFalse(viewModel.canCalculate, "Should not be able to calculate with zero reconstitution")
    }
    
    func testCannotCalculateWithZeroTargetDose() {
        viewModel.vialSize = 10.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.0
        
        XCTAssertFalse(viewModel.canCalculate, "Should not be able to calculate with zero target dose")
    }
    
    // MARK: - Calculate Tests
    
    func testCalculateSuccess() async {
        viewModel.vialSize = 10.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.25
        
        viewModel.calculate()
        
        // Wait for async calculation
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        
        XCTAssertNotNil(viewModel.output, "Output should be set after calculation")
        XCTAssertNil(viewModel.error, "Error should be nil on successful calculation")
        XCTAssertFalse(viewModel.isCalculating, "Should not be calculating after completion")
    }
    
    func testCalculateWithInvalidInput() async {
        viewModel.vialSize = 0.0
        viewModel.reconstitutionVolume = 2.0
        viewModel.targetDose = 0.25
        
        viewModel.calculate()
        
        // Wait for async calculation
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNil(viewModel.output, "Output should be nil on error")
        XCTAssertNotNil(viewModel.error, "Error should be set on invalid input")
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Set custom values
        viewModel.vialSize = 15.0
        viewModel.reconstitutionVolume = 3.0
        viewModel.targetDose = 0.5
        
        // Calculate to populate output
        viewModel.calculate()
        
        // Reset
        viewModel.reset()
        
        // Verify reset to defaults
        XCTAssertEqual(viewModel.vialSize, 10.0, "Vial size should reset to 10mg")
        XCTAssertEqual(viewModel.reconstitutionVolume, 2.0, "Reconstitution should reset to 2ml")
        XCTAssertEqual(viewModel.targetDose, 0.25, "Target dose should reset to 0.25mg")
        XCTAssertNil(viewModel.output, "Output should be cleared")
        XCTAssertNil(viewModel.error, "Error should be cleared")
    }
    
    // MARK: - Frequency Selection Tests
    
    func testFrequencySelection() {
        let dailyFrequency = FrequencySchedule(intervalDays: 1, injectionsPerWeek: 7, pattern: "daily")
        viewModel.selectedFrequency = dailyFrequency
        
        XCTAssertEqual(viewModel.selectedFrequency.pattern, "daily")
        XCTAssertEqual(viewModel.selectedFrequency.intervalDays, 1)
        XCTAssertEqual(viewModel.selectedFrequency.injectionsPerWeek, 7)
    }
}

@MainActor
final class PeptideLibraryViewModelTests: XCTestCase {
    var viewModel: PeptideLibraryViewModel!
    
    override func setUpWithError() throws {
        viewModel = PeptideLibraryViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertNil(viewModel.selectedCategory, "No category should be selected initially")
        XCTAssertTrue(viewModel.searchQuery.isEmpty, "Search query should be empty initially")
        XCTAssertEqual(
            viewModel.filteredPeptides.count,
            PeptideDatabase.all.count,
            "Should show all peptides initially"
        )
    }
    
    // MARK: - Category Filtering Tests
    
    func testSelectGLP1Category() {
        viewModel.selectCategory(.glp1)
        
        XCTAssertEqual(viewModel.selectedCategory, .glp1, "GLP-1 category should be selected")
        
        let glp1Peptides = PeptideDatabase.peptides(in: .glp1)
        XCTAssertEqual(
            viewModel.filteredPeptides.count,
            glp1Peptides.count,
            "Should show only GLP-1 peptides"
        )
        
        for peptide in viewModel.filteredPeptides {
            XCTAssertEqual(peptide.category, .glp1, "All filtered peptides should be GLP-1")
        }
    }
    
    func testSelectHealingCategory() {
        viewModel.selectCategory(.healing)
        
        XCTAssertEqual(viewModel.selectedCategory, .healing)
        
        for peptide in viewModel.filteredPeptides {
            XCTAssertEqual(peptide.category, .healing, "All filtered peptides should be healing")
        }
    }
    
    func testDeselectCategory() {
        // Select a category
        viewModel.selectCategory(.glp1)
        XCTAssertNotNil(viewModel.selectedCategory)
        
        // Deselect by selecting nil
        viewModel.selectCategory(nil)
        XCTAssertNil(viewModel.selectedCategory, "Category should be deselected")
        XCTAssertEqual(
            viewModel.filteredPeptides.count,
            PeptideDatabase.all.count,
            "Should show all peptides when category deselected"
        )
    }
    
    // MARK: - Search Tests
    
    func testSearchByName() {
        viewModel.searchQuery = "Semaglutide"
        
        XCTAssertGreaterThan(viewModel.filteredPeptides.count, 0, "Should find peptides")
        XCTAssertTrue(
            viewModel.filteredPeptides.contains(where: { $0.name.contains("Semaglutide") }),
            "Should include Semaglutide in results"
        )
    }
    
    func testSearchCaseInsensitive() {
        let lowerQuery = "semaglutide"
        let upperQuery = "SEMAGLUTIDE"
        
        viewModel.searchQuery = lowerQuery
        let lowerResults = viewModel.filteredPeptides.count
        
        viewModel.searchQuery = upperQuery
        let upperResults = viewModel.filteredPeptides.count
        
        XCTAssertEqual(lowerResults, upperResults, "Search should be case insensitive")
    }
    
    func testSearchNoResults() {
        viewModel.searchQuery = "nonexistentpeptide"
        
        XCTAssertEqual(viewModel.filteredPeptides.count, 0, "Should return no results for non-existent peptide")
    }
    
    func testClearSearch() {
        // Perform search
        viewModel.searchQuery = "test"
        
        // Clear search
        viewModel.clearSearch()
        
        XCTAssertTrue(viewModel.searchQuery.isEmpty, "Search query should be cleared")
        XCTAssertEqual(
            viewModel.filteredPeptides.count,
            PeptideDatabase.all.count,
            "Should show all peptides after clearing search"
        )
    }
    
    // MARK: - Combined Filter and Search Tests
    
    func testCategoryAndSearchCombined() {
        // Select GLP-1 category
        viewModel.selectCategory(.glp1)
        
        // Search within category
        viewModel.searchQuery = "Semaglutide"
        
        // Should only show GLP-1 peptides matching "Semaglutide"
        for peptide in viewModel.filteredPeptides {
            XCTAssertEqual(peptide.category, .glp1, "Should only show GLP-1 peptides")
            XCTAssertTrue(
                peptide.name.lowercased().contains("semaglutide") ||
                peptide.description.lowercased().contains("semaglutide"),
                "Should match search query"
            )
        }
    }
    
    // MARK: - Category Counts Tests
    
    func testCategoryCounts() {
        let categoryCounts = viewModel.categoryCounts
        
        // Verify counts match database
        for category in PeptideCategory.allCases {
            let dbCount = PeptideDatabase.peptides(in: category).count
            XCTAssertEqual(
                categoryCounts[category],
                dbCount,
                "Category count for \(category.rawValue) should match database"
            )
        }
    }
}
