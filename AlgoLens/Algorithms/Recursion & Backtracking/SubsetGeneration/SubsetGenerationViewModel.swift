//
//  SubsetGenerationViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class SubsetGenerationViewModel: ObservableObject {
    @Published var inputArray: [Int] = [1, 2, 3]
    @Published var subsets: [[Int]] = []
    @Published var currentSubsetIndex = 0
    
    init() {
        generateSubsets()
    }
    
    func generateSubsets() {
        subsets = []
        var current: [Int] = []
        
        func backtrack(_ start: Int) {
            subsets.append(current)
            
            for i in start..<inputArray.count {
                current.append(inputArray[i])
                backtrack(i + 1)
                current.removeLast()
            }
        }
        
        backtrack(0)
        currentSubsetIndex = 0
    }
    
    func nextSubset() {
        guard !subsets.isEmpty else { return }
        currentSubsetIndex = (currentSubsetIndex + 1) % subsets.count
    }
    
    func previousSubset() {
        guard !subsets.isEmpty else { return }
        currentSubsetIndex = (currentSubsetIndex - 1 + subsets.count) % subsets.count
    }
    
    func reset() {
        inputArray = [1, 2, 3]
        generateSubsets()
    }
}
