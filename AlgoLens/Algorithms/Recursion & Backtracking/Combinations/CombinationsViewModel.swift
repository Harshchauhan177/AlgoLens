//
//  CombinationsViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class CombinationsViewModel: ObservableObject {
    @Published var n = 4
    @Published var k = 2
    @Published var combinations: [[Int]] = []
    @Published var currentCombinationIndex = 0
    
    init() {
        generateCombinations()
    }
    
    func generateCombinations() {
        combinations = []
        var current: [Int] = []
        
        func backtrack(_ start: Int) {
            if current.count == k {
                combinations.append(current)
                return
            }
            
            for i in start...n {
                current.append(i)
                backtrack(i + 1)
                current.removeLast()
            }
        }
        
        backtrack(1)
        currentCombinationIndex = 0
    }
    
    func nextCombination() {
        guard !combinations.isEmpty else { return }
        currentCombinationIndex = (currentCombinationIndex + 1) % combinations.count
    }
    
    func previousCombination() {
        guard !combinations.isEmpty else { return }
        currentCombinationIndex = (currentCombinationIndex - 1 + combinations.count) % combinations.count
    }
    
    func reset() {
        n = 4
        k = 2
        generateCombinations()
    }
    
    func updateParameters() {
        if k > n {
            k = n
        }
        generateCombinations()
    }
}
