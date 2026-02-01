//
//  NQueensContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension AlgorithmContent {
    static func nQueensContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "The N-Queens problem is a classic backtracking puzzle where you place N chess queens on an N×N chessboard so no two queens threaten each other. Queens attack any piece in the same row, column, or diagonal. This demonstrates the power of backtracking in constraint satisfaction problems.",
            whenToUse: [
                "When learning backtracking algorithms",
                "For solving constraint satisfaction problems",
                "When exploring all possible valid configurations",
                "For understanding pruning and optimization techniques",
                "In conflict resolution and scheduling problems"
            ],
            keyIdea: "Place queens column by column, checking if each position is safe (no conflicts with previously placed queens). If stuck, backtrack and try a different position.",
            codeImplementations: [
                .pseudocode: """
                function solveNQueens(n):
                    board = empty n×n board
                    solutions = []
                    
                    function isSafe(row, col):
                        check row, upper diagonal, lower diagonal for conflicts
                        return true if safe
                    
                    function solve(col):
                        if col >= n:
                            add board to solutions
                            return
                        
                        for row in 0 to n-1:
                            if isSafe(row, col):
                                place queen at (row, col)
                                solve(col + 1)
                                remove queen (backtrack)
                    
                    solve(0)
                    return solutions
                """,
                .c: """
                #include <stdio.h>
                #include <stdbool.h>
                
                bool isSafe(int board[][10], int row, int col, int n) {
                    for (int i = 0; i < col; i++)
                        if (board[row][i]) return false;
                    
                    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--)
                        if (board[i][j]) return false;
                    
                    for (int i = row, j = col; i < n && j >= 0; i++, j--)
                        if (board[i][j]) return false;
                    
                    return true;
                }
                
                bool solve(int board[][10], int col, int n) {
                    if (col >= n) return true;
                    
                    for (int i = 0; i < n; i++) {
                        if (isSafe(board, i, col, n)) {
                            board[i][col] = 1;
                            if (solve(board, col + 1, n)) return true;
                            board[i][col] = 0; // Backtrack
                        }
                    }
                    return false;
                }
                """,
                .cpp: """
                class Solution {
                public:
                    vector<vector<string>> solveNQueens(int n) {
                        vector<vector<string>> solutions;
                        vector<string> board(n, string(n, '.'));
                        solve(0, board, solutions, n);
                        return solutions;
                    }
                    
                private:
                    bool isSafe(int row, int col, vector<string>& board, int n) {
                        for (int i = 0; i < col; i++)
                            if (board[row][i] == 'Q') return false;
                        
                        for (int i = row, j = col; i >= 0 && j >= 0; i--, j--)
                            if (board[i][j] == 'Q') return false;
                        
                        for (int i = row, j = col; i < n && j >= 0; i++, j--)
                            if (board[i][j] == 'Q') return false;
                        
                        return true;
                    }
                    
                    void solve(int col, vector<string>& board, 
                              vector<vector<string>>& solutions, int n) {
                        if (col >= n) {
                            solutions.push_back(board);
                            return;
                        }
                        
                        for (int row = 0; row < n; row++) {
                            if (isSafe(row, col, board, n)) {
                                board[row][col] = 'Q';
                                solve(col + 1, board, solutions, n);
                                board[row][col] = '.'; // Backtrack
                            }
                        }
                    }
                };
                """,
                .java: """
                public List<List<String>> solveNQueens(int n) {
                    List<List<String>> solutions = new ArrayList<>();
                    char[][] board = new char[n][n];
                    for (int i = 0; i < n; i++)
                        Arrays.fill(board[i], '.');
                    solve(0, board, solutions, n);
                    return solutions;
                }
                
                private boolean isSafe(int row, int col, char[][] board, int n) {
                    for (int i = 0; i < col; i++)
                        if (board[row][i] == 'Q') return false;
                    
                    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--)
                        if (board[i][j] == 'Q') return false;
                    
                    for (int i = row, j = col; i < n && j >= 0; i++, j--)
                        if (board[i][j] == 'Q') return false;
                    
                    return true;
                }
                
                private void solve(int col, char[][] board, 
                                  List<List<String>> solutions, int n) {
                    if (col >= n) {
                        List<String> solution = new ArrayList<>();
                        for (char[] row : board)
                            solution.add(new String(row));
                        solutions.add(solution);
                        return;
                    }
                    
                    for (int row = 0; row < n; row++) {
                        if (isSafe(row, col, board, n)) {
                            board[row][col] = 'Q';
                            solve(col + 1, board, solutions, n);
                            board[row][col] = '.'; // Backtrack
                        }
                    }
                }
                """,
                .python: """
                def solve_n_queens(n):
                    def is_safe(row, col, board):
                        # Check row on left side
                        for i in range(col):
                            if board[row][i] == 'Q':
                                return False
                        
                        # Check upper diagonal
                        i, j = row, col
                        while i >= 0 and j >= 0:
                            if board[i][j] == 'Q':
                                return False
                            i -= 1
                            j -= 1
                        
                        # Check lower diagonal
                        i, j = row, col
                        while i < n and j >= 0:
                            if board[i][j] == 'Q':
                                return False
                            i += 1
                            j -= 1
                        
                        return True
                    
                    def solve(col, board, solutions):
                        if col >= n:
                            solutions.append([''.join(row) for row in board])
                            return
                        
                        for row in range(n):
                            if is_safe(row, col, board):
                                board[row][col] = 'Q';
                                solve(col + 1, board, solutions)
                                board[row][col] = '.'  # Backtrack
                    
                    board = [['.' for _ in range(n)] for _ in range(n)]
                    solutions = []
                    solve(0, board, solutions)
                    return solutions
                """,
                .swift: """
                func solveNQueens(_ n: Int) -> [[String]] {
                    var solutions: [[String]] = []
                    var board = Array(repeating: Array(repeating: ".", count: n), count: n)
                    
                    func isSafe(_ row: Int, _ col: Int) -> Bool {
                        // Check row on left side
                        for i in 0..<col {
                            if board[row][i] == "Q" { return false }
                        }
                        
                        // Check upper diagonal
                        var i = row, j = col
                        while i >= 0 && j >= 0 {
                            if board[i][j] == "Q" { return false }
                            i -= 1
                            j -= 1
                        }
                        
                        // Check lower diagonal
                        i = row
                        j = col
                        while i < n && j >= 0 {
                            if board[i][j] == "Q" { return false }
                            i += 1
                            j -= 1
                        }
                        
                        return true
                    }
                    
                    func solve(_ col: Int) {
                        if col >= n {
                            solutions.append(board.map { $0.joined() })
                            return
                        }
                        
                        for row in 0..<n {
                            if isSafe(row, col) {
                                board[row][col] = "Q"
                                solve(col + 1)
                                board[row][col] = "." // Backtrack
                            }
                        }
                    }
                    
                    solve(0)
                    return solutions
                }
                """,
                .javascript: """
                function solveNQueens(n) {
                    const solutions = [];
                    const board = Array(n).fill().map(() => Array(n).fill('.'));
                    
                    function isSafe(row, col) {
                        // Check row on left side
                        for (let i = 0; i < col; i++) {
                            if (board[row][i] === 'Q') return false;
                        }
                        
                        // Check upper diagonal
                        for (let i = row, j = col; i >= 0 && j >= 0; i--, j--) {
                            if (board[i][j] === 'Q') return false;
                        }
                        
                        // Check lower diagonal
                        for (let i = row, j = col; i < n && j >= 0; i++, j--) {
                            if (board[i][j] === 'Q') return false;
                        }
                        
                        return true;
                    }
                    
                    function solve(col) {
                        if (col >= n) {
                            solutions.push(board.map(row => row.join('')));
                            return;
                        }
                        
                        for (let row = 0; row < n; row++) {
                            if (isSafe(row, col)) {
                                board[row][col] = 'Q';
                                solve(col + 1);
                                board[row][col] = '.'; // Backtrack
                            }
                        }
                    }
                    
                    solve(0);
                    return solutions;
                }
                """
            ],
            
            steps: [
                AlgorithmStep(title: "Initialize", description: "Create empty N×N board and start with column 0", type: .start),
                AlgorithmStep(title: "Try Each Row", description: "For current column, try placing queen in each row", type: .process),
                AlgorithmStep(title: "Check Safety", description: "Verify no conflicts in row, upper diagonal, and lower diagonal", type: .decision),
                AlgorithmStep(title: "Place Queen", description: "If safe, place queen and recursively solve next column", type: .process),
                AlgorithmStep(title: "Solution Found?", description: "If all columns filled, record solution", type: .decision),
                AlgorithmStep(title: "Backtrack", description: "Remove queen and try next row in current column", type: .process),
                AlgorithmStep(title: "All Solutions Found", description: "Return all valid configurations found", type: .success),
                AlgorithmStep(title: "Complete", description: "Time: O(N!), Space: O(N²), Solutions for N=8: 92", type: .end)
            ]
        )
    }
}
