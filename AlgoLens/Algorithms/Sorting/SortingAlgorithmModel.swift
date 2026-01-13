//
//  SortingAlgorithmModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

// MARK: - Sorting Algorithms Data
extension Algorithm {
    static let sortingAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Bubble Sort",
            description: "Compare adjacent elements and swap",
            icon: "bubble.left.and.bubble.right.fill",
            complexity: Complexity(time: "O(n²)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        ),
        Algorithm(
            name: "Selection Sort",
            description: "Select minimum and place it first",
            icon: "hand.point.up.left.fill",
            complexity: Complexity(time: "O(n²)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        ),
        Algorithm(
            name: "Insertion Sort",
            description: "Insert elements in sorted position",
            icon: "arrow.down.to.line.compact",
            complexity: Complexity(time: "O(n²)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        ),
        Algorithm(
            name: "Merge Sort",
            description: "Divide, sort, and merge arrays",
            icon: "arrow.triangle.merge",
            complexity: Complexity(time: "O(n log n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        ),
        Algorithm(
            name: "Quick Sort",
            description: "Partition around pivot element",
            icon: "bolt.fill",
            complexity: Complexity(time: "O(n log n)", space: "O(log n)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        ),
        Algorithm(
            name: "Heap Sort",
            description: "Build heap and extract elements",
            icon: "pyramid.fill",
            complexity: Complexity(time: "O(n log n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        ),
        Algorithm(
            name: "Counting Sort",
            description: "Count occurrences and place",
            icon: "number.circle.fill",
            complexity: Complexity(time: "O(n + k)", space: "O(k)"),
            category: AlgorithmCategory.allCategories[1] // Sorting Algorithms
        )
    ]
}
