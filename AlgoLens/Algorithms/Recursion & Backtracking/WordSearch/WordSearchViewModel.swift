//
//  WordSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class WordSearchViewModel: ObservableObject {
    @Published var board: [[Character]] = []
    @Published var word = "ABCCED"
    @Published var found = false
    @Published var path: [(Int, Int)] = []
    @Published var currentStep = 0
    
    init() {
        setupBoard()
    }
    
    func setupBoard() {
        board = [
            ["A","B","C","E"],
            ["S","F","C","S"],
            ["A","D","E","E"]
        ]
        found = false
        path = []
        currentStep = 0
    }
    
    func search() {
        let rows = board.count
        let cols = board[0].count
        let chars = Array(word)
        var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
        path = []
        
        func dfs(_ row: Int, _ col: Int, _ index: Int, _ currentPath: [(Int, Int)]) -> Bool {
            if index == chars.count {
                path = currentPath
                return true
            }
            
            if row < 0 || row >= rows || col < 0 || col >= cols {
                return false
            }
            
            if visited[row][col] || board[row][col] != chars[index] {
                return false
            }
            
            visited[row][col] = true
            var newPath = currentPath
            newPath.append((row, col))
            
            let result = dfs(row - 1, col, index + 1, newPath) ||
                        dfs(row + 1, col, index + 1, newPath) ||
                        dfs(row, col - 1, index + 1, newPath) ||
                        dfs(row, col + 1, index + 1, newPath)
            
            visited[row][col] = false
            
            return result
        }
        
        for row in 0..<rows {
            for col in 0..<cols {
                if dfs(row, col, 0, []) {
                    found = true
                    return
                }
            }
        }
        
        found = false
    }
    
    func reset() {
        setupBoard()
    }
}
