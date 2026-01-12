//
//  AlgorithmCategory.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import Foundation

// MARK: - Algorithm Category Model
struct AlgorithmCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: CategoryColor
    
    enum CategoryColor: String {
        case blue, purple, green, orange, red, pink, teal, indigo, mint, cyan, yellow, brown
    }
}

// MARK: - Category Data
extension AlgorithmCategory {
    static let allCategories: [AlgorithmCategory] = [
        AlgorithmCategory(
            name: "Searching Algorithms",
            description: "Linear, Binary, Jump, and Exponential Search",
            icon: "magnifyingglass.circle.fill",
            color: .blue
        ),
        AlgorithmCategory(
            name: "Sorting Algorithms",
            description: "Bubble, Quick, Merge, Heap, and more",
            icon: "arrow.up.arrow.down.circle.fill",
            color: .purple
        ),
        AlgorithmCategory(
            name: "Array Algorithms",
            description: "Kadane's, Two Pointers, Sliding Window",
            icon: "square.grid.3x3.fill",
            color: .green
        ),
        AlgorithmCategory(
            name: "String Algorithms",
            description: "Pattern Matching, KMP, Rabin-Karp",
            icon: "textformat.abc",
            color: .orange
        ),
        AlgorithmCategory(
            name: "Recursion & Backtracking",
            description: "N-Queens, Sudoku, Permutations",
            icon: "arrow.triangle.2.circlepath.circle.fill",
            color: .red
        ),
        AlgorithmCategory(
            name: "Linked List Algorithms",
            description: "Reversal, Cycle Detection, Merge",
            icon: "link.circle.fill",
            color: .pink
        ),
        AlgorithmCategory(
            name: "Stack & Queue Algorithms",
            description: "Expression Evaluation, BFS, Monotonic Stack",
            icon: "square.stack.3d.up.fill",
            color: .teal
        ),
        AlgorithmCategory(
            name: "Tree Algorithms",
            description: "Traversals, BST, AVL, Segment Trees",
            icon: "tree.fill",
            color: .indigo
        ),
        AlgorithmCategory(
            name: "Graph Algorithms",
            description: "DFS, BFS, Dijkstra, Floyd-Warshall",
            icon: "circle.hexagongrid.circle.fill",
            color: .mint
        ),
        AlgorithmCategory(
            name: "Greedy Algorithms",
            description: "Activity Selection, Huffman Coding",
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            color: .cyan
        ),
        AlgorithmCategory(
            name: "Dynamic Programming",
            description: "Knapsack, LCS, Matrix Chain Multiplication",
            icon: "memorychip.fill",
            color: .yellow
        ),
        AlgorithmCategory(
            name: "Bit Manipulation",
            description: "XOR, Bit Masking, Power of Two",
            icon: "01.circle.fill",
            color: .brown
        )
    ]
}
