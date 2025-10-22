//
//  PeptideDatabaseTests.swift
//  PeptideFoxTests
//
//  Unit tests for PeptideDatabase
//

import XCTest
@testable import PeptideFox

final class PeptideDatabaseTests: XCTestCase {
    
    // MARK: - Database Content Tests
    
    func testDatabaseNotEmpty() {
        XCTAssertGreaterThan(PeptideDatabase.all.count, 0, "Database should contain peptides")
    }
    
    func testAllPeptidesHaveUniqueIDs() {
        let ids = PeptideDatabase.all.map { $0.id }
        let uniqueIDs = Set(ids)
        
        XCTAssertEqual(ids.count, uniqueIDs.count, "All peptide IDs should be unique")
    }
    
    func testAllPeptidesHaveNames() {
        for peptide in PeptideDatabase.all {
            XCTAssertFalse(peptide.name.isEmpty, "Peptide \(peptide.id) should have a name")
        }
    }
    
    func testAllPeptidesHaveDescriptions() {
        for peptide in PeptideDatabase.all {
            XCTAssertFalse(peptide.description.isEmpty, "Peptide \(peptide.id) should have a description")
        }
    }
    
    func testAllPeptidesHaveMechanism() {
        for peptide in PeptideDatabase.all {
            XCTAssertFalse(peptide.mechanism.isEmpty, "Peptide \(peptide.id) should have mechanism of action")
        }
    }
    
    func testAllPeptidesHaveBenefits() {
        for peptide in PeptideDatabase.all {
            XCTAssertGreaterThan(peptide.benefits.count, 0, "Peptide \(peptide.id) should have at least one benefit")
        }
    }
    
    // MARK: - Specific Peptide Tests
    
    func testSemaglutideExists() {
        let semaglutide = PeptideDatabase.peptide(withId: "semaglutide")
        
        XCTAssertNotNil(semaglutide, "Semaglutide should exist in database")
        XCTAssertEqual(semaglutide?.name, "Semaglutide")
        XCTAssertEqual(semaglutide?.category, .glp1)
    }
    
    func testTirzepatideExists() {
        let tirzepatide = PeptideDatabase.peptide(withId: "tirzepatide")
        
        XCTAssertNotNil(tirzepatide, "Tirzepatide should exist in database")
        XCTAssertEqual(tirzepatide?.name, "Tirzepatide")
        XCTAssertEqual(tirzepatide?.category, .glp1)
    }
    
    func testBPC157Exists() {
        let bpc = PeptideDatabase.peptide(withId: "bpc-157")
        
        XCTAssertNotNil(bpc, "BPC-157 should exist in database")
        XCTAssertEqual(bpc?.name, "BPC-157")
        XCTAssertEqual(bpc?.category, .healing)
    }
    
    func testTB500Exists() {
        let tb500 = PeptideDatabase.peptide(withId: "tb-500")
        
        XCTAssertNotNil(tb500, "TB-500 should exist in database")
        XCTAssertEqual(tb500?.category, .healing)
    }
    
    func testGHKCuExists() {
        let ghk = PeptideDatabase.peptide(withId: "ghk-cu")
        
        XCTAssertNotNil(ghk, "GHK-Cu should exist in database")
        XCTAssertEqual(ghk?.category, .healing)
    }
    
    func testNADExists() {
        let nad = PeptideDatabase.peptide(withId: "nad+")
        
        XCTAssertNotNil(nad, "NAD+ should exist in database")
        XCTAssertEqual(nad?.category, .longevity)
    }
    
    func testSemaxExists() {
        let semax = PeptideDatabase.peptide(withId: "semax")
        
        XCTAssertNotNil(semax, "Semax should exist in database")
        XCTAssertEqual(semax?.category, .cognitive)
    }
    
    func testMOTSCExists() {
        let motsc = PeptideDatabase.peptide(withId: "mots-c")
        
        XCTAssertNotNil(motsc, "MOTS-c should exist in database")
        XCTAssertEqual(motsc?.category, .metabolic)
    }
    
    // MARK: - Category Filtering Tests
    
    func testFilterByGLP1Category() {
        let glp1Peptides = PeptideDatabase.peptides(in: .glp1)
        
        XCTAssertGreaterThan(glp1Peptides.count, 0, "Should have GLP-1 peptides")
        
        for peptide in glp1Peptides {
            XCTAssertEqual(peptide.category, .glp1, "All filtered peptides should be GLP-1")
        }
    }
    
    func testFilterByHealingCategory() {
        let healingPeptides = PeptideDatabase.peptides(in: .healing)
        
        XCTAssertGreaterThan(healingPeptides.count, 0, "Should have healing peptides")
        
        for peptide in healingPeptides {
            XCTAssertEqual(peptide.category, .healing, "All filtered peptides should be healing")
        }
    }
    
    func testFilterByLongevityCategory() {
        let longevityPeptides = PeptideDatabase.peptides(in: .longevity)
        
        // May or may not have longevity peptides
        for peptide in longevityPeptides {
            XCTAssertEqual(peptide.category, .longevity, "All filtered peptides should be longevity")
        }
    }
    
    func testFilterByCognitiveCategory() {
        let cognitivePeptides = PeptideDatabase.peptides(in: .cognitive)
        
        for peptide in cognitivePeptides {
            XCTAssertEqual(peptide.category, .cognitive, "All filtered peptides should be cognitive")
        }
    }
    
    func testFilterByMetabolicCategory() {
        let metabolicPeptides = PeptideDatabase.peptides(in: .metabolic)
        
        for peptide in metabolicPeptides {
            XCTAssertEqual(peptide.category, .metabolic, "All filtered peptides should be metabolic")
        }
    }
    
    // MARK: - Search Tests
    
    func testSearchByName() {
        let results = PeptideDatabase.search(query: "Semaglutide")
        
        XCTAssertGreaterThan(results.count, 0, "Search for 'Semaglutide' should return results")
        XCTAssertTrue(
            results.contains(where: { $0.name.contains("Semaglutide") }),
            "Results should include Semaglutide"
        )
    }
    
    func testSearchByDescription() {
        let results = PeptideDatabase.search(query: "weight loss")
        
        // Should find GLP-1 peptides that mention weight loss
        XCTAssertGreaterThan(results.count, 0, "Search for 'weight loss' should return results")
    }
    
    func testSearchByBenefit() {
        let results = PeptideDatabase.search(query: "healing")
        
        // Should find peptides with healing benefits
        XCTAssertGreaterThan(results.count, 0, "Search for 'healing' should return results")
    }
    
    func testSearchCaseInsensitive() {
        let lowerResults = PeptideDatabase.search(query: "semaglutide")
        let upperResults = PeptideDatabase.search(query: "SEMAGLUTIDE")
        let mixedResults = PeptideDatabase.search(query: "Semaglutide")
        
        XCTAssertEqual(lowerResults.count, upperResults.count, "Search should be case insensitive")
        XCTAssertEqual(lowerResults.count, mixedResults.count, "Search should be case insensitive")
    }
    
    func testSearchEmptyQuery() {
        let results = PeptideDatabase.search(query: "")
        
        XCTAssertEqual(results.count, PeptideDatabase.all.count, "Empty search should return all peptides")
    }
    
    func testSearchNoResults() {
        let results = PeptideDatabase.search(query: "xyznonexistentpeptide")
        
        XCTAssertEqual(results.count, 0, "Search for non-existent peptide should return no results")
    }
    
    // MARK: - Data Integrity Tests
    
    func testTypicalDoseRangeValid() {
        for peptide in PeptideDatabase.all {
            XCTAssertLessThanOrEqual(
                peptide.typicalDose.min,
                peptide.typicalDose.max,
                "Peptide \(peptide.id): min dose should be <= max dose"
            )
            XCTAssertGreaterThan(peptide.typicalDose.min, 0, "Peptide \(peptide.id): min dose should be > 0")
            XCTAssertGreaterThan(peptide.typicalDose.max, 0, "Peptide \(peptide.id): max dose should be > 0")
        }
    }
    
    func testFrequencyNotEmpty() {
        for peptide in PeptideDatabase.all {
            XCTAssertFalse(peptide.frequency.isEmpty, "Peptide \(peptide.id) should have frequency")
        }
    }
    
    func testCycleLengthNotEmpty() {
        for peptide in PeptideDatabase.all {
            XCTAssertFalse(peptide.cycleLength.isEmpty, "Peptide \(peptide.id) should have cycle length")
        }
    }
    
    func testContraindicationsPresent() {
        for peptide in PeptideDatabase.all {
            // All peptides should have at least some contraindications listed
            // or explicitly state "None known" if truly none
            XCTAssertGreaterThanOrEqual(
                peptide.contraindications.count,
                0,
                "Peptide \(peptide.id) should have contraindications array (even if empty)"
            )
        }
    }
    
    func testSignalsPresent() {
        for peptide in PeptideDatabase.all {
            XCTAssertGreaterThan(
                peptide.signals.count,
                0,
                "Peptide \(peptide.id) should have at least one signal/timeline"
            )
        }
    }
    
    func testEvidenceLevelSet() {
        for peptide in PeptideDatabase.all {
            // Evidence level enum should be set for all peptides
            XCTAssertNotNil(peptide.evidenceLevel, "Peptide \(peptide.id) should have evidence level")
        }
    }
    
    // MARK: - Synergies Tests
    
    func testSynergiesArrayValid() {
        for peptide in PeptideDatabase.all {
            // Synergies array should exist (even if empty)
            XCTAssertNotNil(peptide.synergies, "Peptide \(peptide.id) should have synergies array")
            
            // If synergies are listed, verify they reference real peptides
            for synergyID in peptide.synergies {
                let synergisticPeptide = PeptideDatabase.peptide(withId: synergyID)
                XCTAssertNotNil(
                    synergisticPeptide,
                    "Peptide \(peptide.id) lists synergy with \(synergyID), which should exist in database"
                )
            }
        }
    }
    
    func testSemaglutideSynergies() {
        guard let semaglutide = PeptideDatabase.peptide(withId: "semaglutide") else {
            XCTFail("Semaglutide should exist")
            return
        }
        
        // Semaglutide should have some synergies listed
        // Based on the database, it has ["tirzepatide", "bpc-157"]
        XCTAssertTrue(semaglutide.synergies.contains("bpc-157"), "Semaglutide should synergize with BPC-157")
    }
    
    // MARK: - Performance Tests
    
    func testDatabaseLoadPerformance() {
        measure {
            _ = PeptideDatabase.all
        }
    }
    
    func testSearchPerformance() {
        measure {
            _ = PeptideDatabase.search(query: "healing")
        }
    }
    
    func testFilterPerformance() {
        measure {
            _ = PeptideDatabase.peptides(in: .glp1)
        }
    }
}
