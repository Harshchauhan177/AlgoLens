//
//  Algorithm.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import Foundation

// MARK: - Algorithm Model
struct Algorithm: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let complexity: Complexity?
    let category: AlgorithmCategory
    
    struct Complexity: Hashable, Equatable {
        let time: String
        let space: String
    }
}

// MARK: - Searching Algorithms Data
extension Algorithm {
    static let searchingAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Linear Search",
            description: "Search elements one by one",
            icon: "arrow.forward.circle.fill",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0] // Searching Algorithms
        ),
        Algorithm(
            name: "Binary Search",
            description: "Divide and search in sorted data",
            icon: "arrow.left.and.right.circle.fill",
            complexity: Complexity(time: "O(log n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0] // Searching Algorithms
        ),
        Algorithm(
            name: "Jump Search",
            description: "Jump ahead by fixed steps",
            icon: "arrow.up.forward.circle.fill",
            complexity: Complexity(time: "O(√n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0] // Searching Algorithms
        ),
        Algorithm(
            name: "Interpolation Search",
            description: "Estimate position using value",
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            complexity: Complexity(time: "O(log log n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0] // Searching Algorithms
        ),
        Algorithm(
            name: "Exponential Search",
            description: "Expand range then binary search",
            icon: "arrow.up.right.circle.fill",
            complexity: Complexity(time: "O(log n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0] // Searching Algorithms
        ),
        Algorithm(
            name: "Fibonacci Search",
            description: "Search using Fibonacci intervals",
            icon: "function",
            complexity: Complexity(time: "O(log n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0] // Searching Algorithms
        )
    ]
}

// MARK: - Category Extension
extension Algorithm {
    enum Category {
        case searching
        case sorting
        case array
        case string
        case recursion
        case linkedList
        case stackQueue
        case tree
        case graph
        case greedy
        case dynamicProgramming
        case bitManipulation
    }
}
