//
//  SortingAlgorithmsViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class SortingAlgorithmsViewModel: ObservableObject {
    @Published var algorithms: [Algorithm] = []
    @Published var selectedAlgorithm: Algorithm?
    
    init() {
        loadAlgorithms()
    }
    
    // MARK: - Data Loading
    private func loadAlgorithms() {
        algorithms = Algorithm.sortingAlgorithms
    }
    
    // MARK: - User Actions
    func selectAlgorithm(_ algorithm: Algorithm) {
        selectedAlgorithm = algorithm
    }
    
    // MARK: - Future Expansion Points
    // - Track completion status
    // - Save user progress
    // - Mark favorites
    // - Track time spent on each algorithm
}
