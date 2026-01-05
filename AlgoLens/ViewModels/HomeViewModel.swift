//
//  HomeViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var categories: [AlgorithmCategory] = []
    @Published var selectedCategory: AlgorithmCategory?
    @Published var searchText = ""
    
    init() {
        loadCategories()
    }
    
    // MARK: - Data Loading
    private func loadCategories() {
        categories = AlgorithmCategory.allCategories
    }
    
    // MARK: - Computed Properties
    var filteredCategories: [AlgorithmCategory] {
        if searchText.isEmpty {
            return categories
        }
        return categories.filter { category in
            category.name.localizedCaseInsensitiveContains(searchText) ||
            category.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - User Actions
    func selectCategory(_ category: AlgorithmCategory) {
        selectedCategory = category
    }
    
    // MARK: - Future Expansion Points
    // - Track user progress per category
    // - Mark categories as completed
    // - Add favorites
    // - Track recently viewed
    // - Analytics tracking
}
