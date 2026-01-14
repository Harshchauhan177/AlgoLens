//
//  ArrayAlgorithmModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

// MARK: - Array Algorithms Data
extension Algorithm {
    static let arrayAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Two Pointer",
            description: "Use two pointers to solve problems efficiently",
            icon: "arrow.left.and.right.circle.fill",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        ),
        Algorithm(
            name: "Sliding Window",
            description: "Maintain a window that slides through array",
            icon: "rectangle.inset.filled.and.person.filled",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        ),
        Algorithm(
            name: "Prefix Sum",
            description: "Precompute cumulative sums for range queries",
            icon: "chart.bar.fill",
            complexity: Complexity(time: "O(n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        ),
        Algorithm(
            name: "Kadane's Algorithm",
            description: "Find maximum sum subarray efficiently",
            icon: "sum",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        ),
        Algorithm(
            name: "Moore's Voting",
            description: "Find majority element in linear time",
            icon: "chart.pie.fill",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        ),
        Algorithm(
            name: "Dutch National Flag",
            description: "Sort array with three distinct values",
            icon: "flag.fill",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        ),
        Algorithm(
            name: "Subarray Sum",
            description: "Find subarrays with given sum using hashing",
            icon: "list.bullet.rectangle.fill",
            complexity: Complexity(time: "O(n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[2] // Array Algorithms
        )
    ]
}
