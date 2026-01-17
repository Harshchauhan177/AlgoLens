//
//  NQueensViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class NQueensViewModel: ObservableObject {
    @Published var board: [[Int]] = []
    @Published var n = 4
    @Published var solutions: [[[Int]]] = []
    @Published var currentSolutionIndex = 0
    @Published var isAnimating = false
    @Published var animationSpeed: Double = 1.0
    
    init() {
        setupBoard()
    }
    
    func setupBoard() {
        board = Array(repeating: Array(repeating: 0, count: n), count: n)
        solutions = []
        currentSolutionIndex = 0
        solve()
    }
    
    private func solve() {
        var tempBoard = Array(repeating: Array(repeating: 0, count: n), count: n)
        
        func isSafe(_ row: Int, _ col: Int) -> Bool {
            // Check row
            for i in 0..<col {
                if tempBoard[row][i] == 1 { return false }
            }
            
            // Check upper diagonal
            var i = row, j = col
            while i >= 0 && j >= 0 {
                if tempBoard[i][j] == 1 { return false }
                i -= 1
                j -= 1
            }
            
            // Check lower diagonal
            i = row
            j = col
            while i < n && j >= 0 {
                if tempBoard[i][j] == 1 { return false }
                i += 1
                j -= 1
            }
            
            return true
        }
        
        func solveUtil(_ col: Int) {
            if col >= n {
                solutions.append(tempBoard)
                return
            }
            
            for row in 0..<n {
                if isSafe(row, col) {
                    tempBoard[row][col] = 1
                    solveUtil(col + 1)
                    tempBoard[row][col] = 0
                }
            }
        }
        
        solveUtil(0)
        if !solutions.isEmpty {
            board = solutions[0]
        }
    }
    
    func showNextSolution() {
        guard !solutions.isEmpty else { return }
        currentSolutionIndex = (currentSolutionIndex + 1) % solutions.count
        board = solutions[currentSolutionIndex]
    }
    
    func showPreviousSolution() {
        guard !solutions.isEmpty else { return }
        currentSolutionIndex = (currentSolutionIndex - 1 + solutions.count) % solutions.count
        board = solutions[currentSolutionIndex]
    }
    
    func reset() {
        setupBoard()
    }
}
