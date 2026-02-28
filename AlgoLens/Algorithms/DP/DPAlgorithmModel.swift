//
//  DPAlgorithmModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import Foundation

// MARK: - DP Algorithms Data
extension Algorithm {
    static let DPAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Fibonacci (DP)",
            description: "Calculate Fibonacci numbers using dynamic programming",
            icon: "function",
            complexity: Complexity(time: "O(n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[1] // Dynamic Programming
        )
    ]
}
