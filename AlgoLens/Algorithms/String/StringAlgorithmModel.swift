//
//  StringAlgorithmModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

// MARK: - String Algorithms Data
extension Algorithm {
    static let stringAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Naive String Matching",
            description: "Simple pattern matching approach",
            icon: "text.magnifyingglass",
            complexity: Complexity(time: "O(n×m)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "KMP Algorithm",
            description: "Efficient pattern matching with prefix",
            icon: "text.alignleft",
            complexity: Complexity(time: "O(n+m)", space: "O(m)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "Rabin-Karp",
            description: "Pattern matching using hashing",
            icon: "number.circle.fill",
            complexity: Complexity(time: "O(n+m)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "Z Algorithm",
            description: "Linear time pattern matching",
            icon: "character.textbox",
            complexity: Complexity(time: "O(n+m)", space: "O(n+m)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "Longest Palindromic Substring",
            description: "Find longest palindrome in string",
            icon: "arrow.left.and.right",
            complexity: Complexity(time: "O(n²)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "Anagram Check",
            description: "Check if two strings are anagrams",
            icon: "arrow.triangle.2.circlepath",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "String Rotation",
            description: "Check if one string is rotation of other",
            icon: "arrow.clockwise.circle.fill",
            complexity: Complexity(time: "O(n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        ),
        Algorithm(
            name: "Subsequence Check",
            description: "Check if string is subsequence of another",
            icon: "arrow.down.right.circle.fill",
            complexity: Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[3] // String Algorithms
        )
    ]
}
