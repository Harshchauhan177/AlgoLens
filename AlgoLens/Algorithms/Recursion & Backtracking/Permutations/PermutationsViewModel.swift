//
//  PermutationsViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class PermutationsViewModel: ObservableObject {
    @Published var inputArray: [Int] = [1, 2, 3]
    @Published var permutations: [[Int]] = []
    @Published var currentPermutationIndex = 0
    
    init() {
        generatePermutations()
    }
    
    func generatePermutations() {
        permutations = []
        var current: [Int] = []
        var used = Array(repeating: false, count: inputArray.count)
        
        func backtrack() {
            if current.count == inputArray.count {
                permutations.append(current)
                return
            }
            
            for i in 0..<inputArray.count {
                if used[i] { continue }
                
                current.append(inputArray[i])
                used[i] = true
                
                backtrack()
                
                current.removeLast()
                used[i] = false
            }
        }
        
        backtrack()
        currentPermutationIndex = 0
    }
    
    func nextPermutation() {
        guard !permutations.isEmpty else { return }
        currentPermutationIndex = (currentPermutationIndex + 1) % permutations.count
    }
    
    func previousPermutation() {
        guard !permutations.isEmpty else { return }
        currentPermutationIndex = (currentPermutationIndex - 1 + permutations.count) % permutations.count
    }
    
    func reset() {
        inputArray = [1, 2, 3]
        generatePermutations()
    }
}
