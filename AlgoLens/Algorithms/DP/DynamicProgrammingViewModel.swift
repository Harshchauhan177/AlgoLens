//
//  DynamicProgrammingViewModel.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import SwiftUI
import Combine

@MainActor
class DynamicProgrammingViewModel: ObservableObject {
    @Published var algorithms: [Algorithm] = []
    @Published var selectedAlgorithm: Algorithm?
    
    init() {
        loadAlgorithms()
    }
    
    // MARK: - Data Loading
    private func loadAlgorithms() {
        algorithms = Algorithm.dynamicProgrammingAlgorithms
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
