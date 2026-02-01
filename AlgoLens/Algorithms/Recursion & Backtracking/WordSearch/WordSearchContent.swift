//
//  WordSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension AlgorithmContent {
    static func wordSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Word Search is a backtracking algorithm that finds if a given word exists in a 2D grid of characters. The word can be constructed from letters of sequentially adjacent cells (horizontally or vertically). Each cell can only be used once per word.",
            whenToUse: [
                "When solving word puzzle games like Boggle",
                "For pattern matching in 2D grids",
                "In crossword puzzle validation",
                "For DNA sequence searching in grid representations",
                "When implementing word game solvers"
            ],
            keyIdea: "Use depth-first search with backtracking to explore all possible paths from each cell, marking visited cells to prevent reuse.",
            codeImplementations: [
                .pseudocode: """
                function exist(board, word):
                    rows = board.length
                    cols = board[0].length
                    
                    function dfs(row, col, index):
                        if index == word.length:
                            return true
                        
                        if row < 0 or row >= rows or col < 0 or col >= cols:
                            return false
                        
                        if visited[row][col] or board[row][col] != word[index]:
                            return false
                        
                        visited[row][col] = true
                        
                        found = dfs(row-1, col, index+1) or
                                dfs(row+1, col, index+1) or
                                dfs(row, col-1, index+1) or
                                dfs(row, col+1, index+1)
                        
                        visited[row][col] = false
                        return found
                    
                    for each cell (row, col) in board:
                        if dfs(row, col, 0):
                            return true
                    
                    return false
                """,
                .c: """
                bool dfs(char** board, int rows, int cols, char* word, 
                         bool** visited, int row, int col, int index) {
                    if (word[index] == '\\0') return true;
                    
                    if (row < 0 || row >= rows || col < 0 || col >= cols)
                        return false;
                    
                    if (visited[row][col] || board[row][col] != word[index])
                        return false;
                    
                    visited[row][col] = true;
                    
                    bool found = dfs(board, rows, cols, word, visited, row-1, col, index+1) ||
                                 dfs(board, rows, cols, word, visited, row+1, col, index+1) ||
                                 dfs(board, rows, cols, word, visited, row, col-1, index+1) ||
                                 dfs(board, rows, cols, word, visited, row, col+1, index+1);
                    
                    visited[row][col] = false;
                    return found;
                }

                bool exist(char** board, int rows, int cols, char* word) {
                    bool** visited = allocateVisited(rows, cols);
                    
                    for (int i = 0; i < rows; i++) {
                        for (int j = 0; j < cols; j++) {
                            if (dfs(board, rows, cols, word, visited, i, j, 0))
                                return true;
                        }
                    }
                    return false;
                }
                """,
                .cpp: """
                bool dfs(vector<vector<char>>& board, string& word, 
                         vector<vector<bool>>& visited, int row, int col, int index) {
                    if (index == word.length()) return true;
                    
                    int rows = board.size();
                    int cols = board[0].size();
                    
                    if (row < 0 || row >= rows || col < 0 || col >= cols)
                        return false;
                    
                    if (visited[row][col] || board[row][col] != word[index])
                        return false;
                    
                    visited[row][col] = true;
                    
                    bool found = dfs(board, word, visited, row-1, col, index+1) ||
                                 dfs(board, word, visited, row+1, col, index+1) ||
                                 dfs(board, word, visited, row, col-1, index+1) ||
                                 dfs(board, word, visited, row, col+1, index+1);
                    
                    visited[row][col] = false;
                    return found;
                }

                bool exist(vector<vector<char>>& board, string word) {
                    int rows = board.size();
                    int cols = board[0].size();
                    vector<vector<bool>> visited(rows, vector<bool>(cols, false));
                    
                    for (int i = 0; i < rows; i++) {
                        for (int j = 0; j < cols; j++) {
                            if (dfs(board, word, visited, i, j, 0))
                                return true;
                        }
                    }
                    return false;
                }
                """,
                .java: """
                public boolean exist(char[][] board, String word) {
                    int rows = board.length;
                    int cols = board[0].length;
                    boolean[][] visited = new boolean[rows][cols];
                    
                    for (int i = 0; i < rows; i++) {
                        for (int j = 0; j < cols; j++) {
                            if (dfs(board, word, visited, i, j, 0))
                                return true;
                        }
                    }
                    return false;
                }

                private boolean dfs(char[][] board, String word, boolean[][] visited,
                                   int row, int col, int index) {
                    if (index == word.length()) return true;
                    
                    int rows = board.length;
                    int cols = board[0].length;
                    
                    if (row < 0 || row >= rows || col < 0 || col >= cols)
                        return false;
                    
                    if (visited[row][col] || board[row][col] != word.charAt(index))
                        return false;
                    
                    visited[row][col] = true;
                    
                    boolean found = dfs(board, word, visited, row-1, col, index+1) ||
                                    dfs(board, word, visited, row+1, col, index+1) ||
                                    dfs(board, word, visited, row, col-1, index+1) ||
                                    dfs(board, word, visited, row, col+1, index+1);
                    
                    visited[row][col] = false;
                    return found;
                }
                """,
                .python: """
                def exist(board, word):
                    rows = len(board)
                    cols = len(board[0])
                    visited = [[False] * cols for _ in range(rows)]
                    
                    def dfs(row, col, index):
                        if index == len(word):
                            return True
                        
                        if row < 0 or row >= rows or col < 0 or col >= cols:
                            return False
                        
                        if visited[row][col] or board[row][col] != word[index]:
                            return False
                        
                        visited[row][col] = True
                        
                        found = (dfs(row-1, col, index+1) or
                                dfs(row+1, col, index+1) or
                                dfs(row, col-1, index+1) or
                                dfs(row, col+1, index+1))
                        
                        visited[row][col] = False
                        return found
                    
                    for i in range(rows):
                        for j in range(cols):
                            if dfs(i, j, 0):
                                return True
                    
                    return False
                """,
                .swift: """
                func exist(_ board: [[Character]], _ word: String) -> Bool {
                    let rows = board.count
                    let cols = board[0].count
                    let chars = Array(word)
                    var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
                    
                    func dfs(_ row: Int, _ col: Int, _ index: Int) -> Bool {
                        if index == chars.count { return true }
                        
                        if row < 0 || row >= rows || col < 0 || col >= cols {
                            return false
                        }
                        
                        if visited[row][col] || board[row][col] != chars[index] {
                            return false
                        }
                        
                        visited[row][col] = true
                        
                        let found = dfs(row-1, col, index+1) ||
                                    dfs(row+1, col, index+1) ||
                                    dfs(row, col-1, index+1) ||
                                    dfs(row+1, col+1, index+1)
                        
                        visited[row][col] = false
                        return found
                    }
                    
                    for i in 0..<rows {
                        for j in 0..<cols {
                            if dfs(i, j, 0) { return true }
                        }
                    }
                    return false
                }
                """,
                .javascript: """
                function exist(board, word) {
                    const rows = board.length;
                    const cols = board[0].length;
                    const visited = Array(rows).fill(0).map(() => Array(cols).fill(false));
                    
                    function dfs(row, col, index) {
                        if (index === word.length) return true;
                        
                        if (row < 0 || row >= rows || col < 0 || col >= cols)
                            return false;
                        
                        if (visited[row][col] || board[row][col] !== word[index])
                            return false;
                        
                        visited[row][col] = true;
                        
                        const found = dfs(row-1, col, index+1) ||
                                     dfs(row+1, col, index+1) ||
                                     dfs(row, col-1, index+1) ||
                                     dfs(row, col+1, index+1);
                        
                        visited[row][col] = false;
                        return found;
                    }
                    
                    for (let i = 0; i < rows; i++) {
                        for (let j = 0; j < cols; j++) {
                            if (dfs(i, j, 0)) return true;
                        }
                    }
                    return false;
                }
                """
            ],
            
            steps: [
                AlgorithmStep(title: "Initialize", description: "Start searching from each cell in the grid", type: .start),
                AlgorithmStep(title: "Check Match", description: "Verify if current cell matches the required character", type: .decision),
                AlgorithmStep(title: "Mark Visited", description: "Mark current cell as visited to prevent reuse", type: .process),
                AlgorithmStep(title: "Explore Directions", description: "Try all 4 directions (up, down, left, right)", type: .process),
                AlgorithmStep(title: "Recursive Search", description: "Recursively search for next character in word", type: .process),
                AlgorithmStep(title: "Backtrack", description: "Unmark cell and try different path if needed", type: .process),
                AlgorithmStep(title: "Complete", description: "Word found or all paths exhausted", type: .end)
            ]
        )
    }
}
