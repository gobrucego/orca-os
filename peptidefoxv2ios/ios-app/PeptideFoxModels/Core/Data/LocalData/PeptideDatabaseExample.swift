//
//  PeptideDatabaseExample.swift
//  PeptideFox
//
//  Example usage and validation of PeptideDatabase
//

import Foundation

/// Example usage of PeptideDatabase
public struct PeptideDatabaseExamples {
    
    // MARK: - Basic Usage
    
    /// Get a specific peptide by ID
    public static func getSpecificPeptide() {
        if let semaglutide = PeptideDatabase.shared.peptide(byID: "semaglutide") {
            print("Peptide: \(semaglutide.name)")
            print("Category: \(semaglutide.category.displayName)")
            print("Dose: \(semaglutide.typicalDose)")
            print("Cost: \(semaglutide.cost?.displayName ?? "Unknown")")
            print("Evidence: \(semaglutide.evidence?.displayName ?? "Unknown")")
            
            if let contraindications = semaglutide.contraindications {
                print("\nContraindications:")
                for warning in contraindications {
                    print("  - \(warning)")
                }
            }
        }
    }
    
    /// Get all GLP-1 peptides
    public static func getGLP1Peptides() {
        let glp1s = PeptideDatabase.shared.peptides(byCategory: .glp)
        print("GLP-1 Peptides (\(glp1s.count)):")
        for peptide in glp1s {
            print("  - \(peptide.name): \(peptide.description)")
        }
    }
    
    /// Get all healing peptides
    public static func getHealingPeptides() {
        let healingPeptides = PeptideDatabase.shared.peptides(byCategory: .healing)
        print("Healing Peptides (\(healingPeptides.count)):")
        for peptide in healingPeptides {
            print("  - \(peptide.name): \(peptide.description)")
        }
    }
    
    // MARK: - Search Examples
    
    /// Search peptides by query
    public static func searchPeptides(query: String) {
        let results = PeptideDatabase.shared.search(query: query)
        print("Search results for '\(query)' (\(results.count)):")
        for peptide in results {
            print("  - \(peptide.name): \(peptide.description)")
        }
    }
    
    // MARK: - Synergy Examples
    
    /// Find synergistic peptides
    public static func findSynergies(for peptideID: String) {
        guard let peptide = PeptideDatabase.shared.peptide(byID: peptideID) else {
            print("Peptide not found: \(peptideID)")
            return
        }
        
        let synergies = PeptideDatabase.shared.synergisticPairs(for: peptideID)
        print("\(peptide.name) works well with:")
        for synergy in synergies {
            print("  - \(synergy.name) (\(synergy.category.displayName))")
        }
    }
    
    // MARK: - Statistics
    
    /// Print database statistics
    public static func printStatistics() {
        let stats = PeptideDatabase.shared.statistics
        
        print("=== PeptideDatabase Statistics ===")
        print("Total Peptides: \(stats.totalPeptides)")
        print("\nBy Category:")
        for (category, count) in stats.byCategory.sorted(by: { $0.value > $1.value }) {
            print("  \(category.displayName): \(count)")
        }
        print("\nData Completeness:")
        print("  With Full Protocol: \(stats.withFullProtocol)")
        print("  With Contraindications: \(stats.withContraindications)")
        print("  With Strong Evidence: \(stats.withStrongEvidence)")
        print("\nAverage Synergies per Peptide: \(String(format: "%.1f", stats.averageSynergiesPerPeptide))")
    }
    
    // MARK: - Validation
    
    /// Validate database integrity
    public static func validateDatabase() -> [String] {
        var issues: [String] = []
        let db = PeptideDatabase.shared
        
        // Check total count
        if db.totalCount < 20 {
            issues.append("WARNING: Only \(db.totalCount) peptides in database (expected 28+)")
        }
        
        // Check each category has peptides
        for category in PeptideCategory.allCases {
            let count = db.peptides(byCategory: category).count
            if count == 0 {
                issues.append("WARNING: No peptides in category \(category.displayName)")
            }
        }
        
        // Check for duplicates
        let allIDs = db.allPeptides.map { $0.id }
        let uniqueIDs = Set(allIDs)
        if allIDs.count != uniqueIDs.count {
            issues.append("ERROR: Duplicate peptide IDs found")
        }
        
        // Check critical fields
        for peptide in db.allPeptides {
            if peptide.name.isEmpty {
                issues.append("ERROR: Peptide \(peptide.id) has empty name")
            }
            if peptide.description.isEmpty {
                issues.append("ERROR: Peptide \(peptide.id) has empty description")
            }
            if peptide.mechanism.isEmpty {
                issues.append("ERROR: Peptide \(peptide.id) has empty mechanism")
            }
            if peptide.benefits.isEmpty {
                issues.append("WARNING: Peptide \(peptide.id) has no benefits listed")
            }
        }
        
        // Check GLP-1 peptides have proper contraindications
        let glp1s = db.peptides(byCategory: .glp)
        for glp1 in glp1s {
            if glp1.contraindications == nil || glp1.contraindications!.isEmpty {
                issues.append("WARNING: GLP-1 peptide \(glp1.id) missing contraindications")
            }
        }
        
        if issues.isEmpty {
            print("✅ Database validation passed!")
        } else {
            print("⚠️ Database validation found \(issues.count) issue(s):")
            for issue in issues {
                print("  \(issue)")
            }
        }
        
        return issues
    }
    
    // MARK: - Usage Examples
    
    /// Run all examples
    public static func runAllExamples() {
        print("=" * 60)
        print("PEPTIDEFOX DATABASE EXAMPLES")
        print("=" * 60)
        print()
        
        printStatistics()
        print()
        
        print("=" * 60)
        getGLP1Peptides()
        print()
        
        print("=" * 60)
        searchPeptides(query: "healing")
        print()
        
        print("=" * 60)
        findSynergies(for: "bpc157")
        print()
        
        print("=" * 60)
        _ = validateDatabase()
    }
}

// MARK: - String Repetition Helper

fileprivate extension String {
    static func * (left: String, right: Int) -> String {
        String(repeating: left, count: right)
    }
}
