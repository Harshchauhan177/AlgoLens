//
//  DynamicProgrammingAlgorithmModel.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import Foundation

// MARK: - Dynamic Programming Algorithms Data
extension Algorithm {
    static let dynamicProgrammingAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Fibonacci (DP)",
            description: "Calculate Fibonacci numbers using dynamic programming",
            icon: "function",
            complexity: Complexity(time: "O(n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[1] // Dynamic Programming
        )
    ]
}
