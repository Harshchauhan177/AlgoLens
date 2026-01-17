//
//  RecursionAlgorithmModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

// MARK: - Recursion & Backtracking Algorithms Data
extension Algorithm {
    static let recursionAlgorithms: [Algorithm] = [
        Algorithm(
            name: "Tower of Hanoi",
            description: "Move disks between towers recursively",
            icon: "building.columns.fill",
            complexity: Complexity(time: "O(2^n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[4] // Recursion & Backtracking
        ),
        Algorithm(
            name: "N-Queens",
            description: "Place N queens on N×N chessboard",
            icon: "crown.fill",
            complexity: Complexity(time: "O(N!)", space: "O(N²)"),
            category: AlgorithmCategory.allCategories[4]
        ),
        Algorithm(
            name: "Rat in a Maze",
            description: "Find path from start to end in maze",
            icon: "arrow.turn.up.right",
            complexity: Complexity(time: "O(2^(n²))", space: "O(n²)"),
            category: AlgorithmCategory.allCategories[4]
        ),
        Algorithm(
            name: "Sudoku Solver",
            description: "Solve 9×9 Sudoku puzzle using backtracking",
            icon: "number.square.fill",
            complexity: Complexity(time: "O(9^(n²))", space: "O(n²)"),
            category: AlgorithmCategory.allCategories[4]
        ),
        Algorithm(
            name: "Permutations",
            description: "Generate all arrangements of elements",
            icon: "shuffle.circle.fill",
            complexity: Complexity(time: "O(n!)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[4]
        ),
        Algorithm(
            name: "Combinations",
            description: "Generate all possible selections",
            icon: "circle.grid.cross.fill",
            complexity: Complexity(time: "O(2^n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[4]
        ),
        Algorithm(
            name: "Subset Generation",
            description: "Generate all possible subsets",
            icon: "square.stack.3d.up.fill",
            complexity: Complexity(time: "O(2^n)", space: "O(n)"),
            category: AlgorithmCategory.allCategories[4]
        ),
        Algorithm(
            name: "Word Search",
            description: "Find word in 2D character grid",
            icon: "character.magnify",
            complexity: Complexity(time: "O(N·3^L)", space: "O(L)"),
            category: AlgorithmCategory.allCategories[4]
        )
    ]
}
