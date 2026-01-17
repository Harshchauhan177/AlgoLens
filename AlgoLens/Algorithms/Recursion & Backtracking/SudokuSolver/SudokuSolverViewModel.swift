//
//  SudokuSolverViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class SudokuSolverViewModel: ObservableObject {
    @Published var board: [[Int]] = []
    @Published var isSolved = false
    
    init() {
        setupBoard()
    }
    
    func setupBoard() {
        board = [
            [5, 3, 0, 0, 7, 0, 0, 0, 0],
            [6, 0, 0, 1, 9, 5, 0, 0, 0],
            [0, 9, 8, 0, 0, 0, 0, 6, 0],
            [8, 0, 0, 0, 6, 0, 0, 0, 3],
            [4, 0, 0, 8, 0, 3, 0, 0, 1],
            [7, 0, 0, 0, 2, 0, 0, 0, 6],
            [0, 6, 0, 0, 0, 0, 2, 8, 0],
            [0, 0, 0, 4, 1, 9, 0, 0, 5],
            [0, 0, 0, 0, 8, 0, 0, 7, 9]
        ]
        isSolved = false
    }
    
    func solve() {
        func isValid(_ row: Int, _ col: Int, _ num: Int) -> Bool {
            // Check row
            for j in 0..<9 {
                if board[row][j] == num { return false }
            }
            
            // Check column
            for i in 0..<9 {
                if board[i][col] == num { return false }
            }
            
            // Check 3×3 box
            let boxRow = (row / 3) * 3
            let boxCol = (col / 3) * 3
            for i in 0..<3 {
                for j in 0..<3 {
                    if board[boxRow + i][boxCol + j] == num {
                        return false
                    }
                }
            }
            
            return true
        }
        
        func solveUtil() -> Bool {
            for i in 0..<9 {
                for j in 0..<9 {
                    if board[i][j] == 0 {
                        for num in 1...9 {
                            if isValid(i, j, num) {
                                board[i][j] = num
                                
                                if solveUtil() {
                                    return true
                                }
                                
                                board[i][j] = 0 // Backtrack
                            }
                        }
                        return false
                    }
                }
            }
            return true
        }
        
        isSolved = solveUtil()
    }
    
    func reset() {
        setupBoard()
    }
}
