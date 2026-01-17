////
////  WordSearchContent.swift
////  AlgoLens
////
////  Created by harsh chauhan on 17/01/26.
////
//
//import Foundation
//
//extension AlgorithmContent {
//    static func wordSearchContent() -> AlgorithmContent {
//        AlgorithmContent(
//            introduction: """
//            Word Search is a classic backtracking problem where we need to find if a given word exists in a 2D grid of characters. The word can be constructed from letters of sequentially adjacent cells, where adjacent cells are horizontally or vertically neighboring.
//            
//            The same cell cannot be used more than once in forming the word. This problem demonstrates the power of backtracking with path tracking.
//            
//            Example grid:
//            [['A','B','C','E'],
//             ['S','F','C','S'],
//             ['A','D','E','E']]
//            
//            Word "ABCCED" exists, but "ABCB" does not (can't reuse 'B').
//            """,
//            
//            howItWorks: """
//            The algorithm uses depth-first search with backtracking:
//            
//            1. **Find Starting Points**: Search for cells matching the first letter
//            
//            2. **Start DFS**: From each matching cell, attempt to build the word
//            
//            3. **Explore Four Directions**: At each step, try:
//               • Up (row-1, col)
//               • Down (row+1, col)
//               • Left (row, col-1)
//               • Right (row, col+1)
//            
//            4. **Check Validity**:
//               • Within grid bounds
//               • Matches next character in word
//               • Not already visited in current path
//            
//            5. **Mark Visited**: Temporarily mark cell as visited to prevent reuse
//            
//            6. **Recursive Search**: 
//               • If word completed, return true
//               • Try all 4 directions recursively
//            
//            7. **Backtrack**: Unmark cell and try different path
//            
//            **Key Optimization**: Early termination when word is found or path is invalid.
//            """,
//            
//            realWorldApplications: """
//            • **Crossword Puzzles**: Automated puzzle solving
//            • **Word Games**: Boggle, Scrabble helpers
//            • **Text Recognition**: OCR validation
//            • **Pattern Matching**: Finding patterns in grids
//            • **DNA Sequencing**: Finding gene sequences in data
//            • **Image Analysis**: Character recognition in images
//            • **Educational Apps**: Word search game solvers
//            • **Natural Language Processing**: Text extraction from structured data
//            """,
//            
//            codeExample: """
//            func exist(_ board: [[Character]], _ word: String) -> Bool {
//                guard !board.isEmpty && !board[0].isEmpty else { return false }
//                
//                let rows = board.count
//                let cols = board[0].count
//                let chars = Array(word)
//                var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
//                
//                func dfs(_ row: Int, _ col: Int, _ index: Int) -> Bool {
//                    // Found complete word
//                    if index == chars.count {
//                        return true
//                    }
//                    
//                    // Check boundaries
//                    if row < 0 || row >= rows || col < 0 || col >= cols {
//                        return false
//                    }
//                    
//                    // Check if already visited or character doesn't match
//                    if visited[row][col] || board[row][col] != chars[index] {
//                        return false
//                    }
//                    
//                    // Mark as visited
//                    visited[row][col] = true
//                    
//                    // Try all four directions
//                    let found = dfs(row - 1, col, index + 1) ||  // Up
//                                dfs(row + 1, col, index + 1) ||  // Down
//                                dfs(row, col - 1, index + 1) ||  // Left
//                                dfs(row, col + 1, index + 1)     // Right
//                    
//                    // Backtrack
//                    visited[row][col] = false
//                    
//                    return found
//                }
//                
//                // Try starting from each cell
//                for row in 0..<rows {
//                    for col in 0..<cols {
//                        if dfs(row, col, 0) {
//                            return true
//                        }
//                    }
//                }
//                
//                return false
//            }
//            
//            // Example usage
//            let board: [[Character]] = [
//                ["A","B","C","E"],
//                ["S","F","C","S"],
//                ["A","D","E","E"]
//            ]
//            print(exist(board, "ABCCED"))  // true
//            print(exist(board, "SEE"))     // true
//            print(exist(board, "ABCB"))    // false
//            """
//        )
//    }
//}
