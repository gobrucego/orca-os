import SwiftUI
import Observation

@MainActor
@Observable
public final class PeptideLibraryViewModel {
    // State
    var searchQuery: String = ""
    var selectedCategory: PeptideCategory?
    
    // Computed
    var filteredPeptides: [Peptide] {
        var peptides = PeptideDatabase.all
        
        // Filter by category
        if let category = selectedCategory {
            peptides = peptides.filter { $0.category == category }
        }
        
        // Filter by search
        if !searchQuery.isEmpty {
            let query = searchQuery.lowercased()
            peptides = peptides.filter {
                $0.name.lowercased().contains(query) ||
                $0.description.lowercased().contains(query) ||
                $0.benefits.joined().lowercased().contains(query)
            }
        }
        
        return peptides
    }
    
    var categoryCounts: [PeptideCategory: Int] {
        var counts: [PeptideCategory: Int] = [:]
        for category in PeptideCategory.allCases {
            counts[category] = PeptideDatabase.peptides(in: category).count
        }
        return counts
    }
    
    public init() {}
    
    // Actions
    func selectCategory(_ category: PeptideCategory?) {
        selectedCategory = category
    }
    
    func clearSearch() {
        searchQuery = ""
    }
}
