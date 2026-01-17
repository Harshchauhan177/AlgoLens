//
//  RatInMazeViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class RatInMazeViewModel: ObservableObject {
    @Published var maze: [[Int]] = []
    @Published var path: [[Int]] = []
    @Published var currentPosition: (Int, Int) = (0, 0)
    @Published var solutions: [String] = []
    @Published var currentSolutionIndex = 0
    @Published var isAnimating = false
    
    init() {
        setupMaze()
    }
    
    func setupMaze() {
        maze = [
            [1, 0, 0, 0],
            [1, 1, 0, 1],
            [0, 1, 0, 0],
            [1, 1, 1, 1]
        ]
        path = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        currentPosition = (0, 0)
        solutions = []
        solve()
    }
    
    private func solve() {
        let n = maze.count
        var visited = Array(repeating: Array(repeating: false, count: n), count: n)
        
        func isSafe(_ x: Int, _ y: Int) -> Bool {
            return x >= 0 && x < n && y >= 0 && y < n && 
                   maze[x][y] == 1 && !visited[x][y]
        }
        
        func solveUtil(_ x: Int, _ y: Int, _ pathStr: String) {
            if x == n - 1 && y == n - 1 {
                solutions.append(pathStr)
                return
            }
            
            visited[x][y] = true
            
            // Down
            if isSafe(x + 1, y) {
                solveUtil(x + 1, y, pathStr + "D")
            }
            
            // Right
            if isSafe(x, y + 1) {
                solveUtil(x, y + 1, pathStr + "R")
            }
            
            // Up
            if isSafe(x - 1, y) {
                solveUtil(x - 1, y, pathStr + "U")
            }
            
            // Left
            if isSafe(x, y - 1) {
                solveUtil(x, y - 1, pathStr + "L")
            }
            
            visited[x][y] = false
        }
        
        if maze[0][0] == 1 {
            solveUtil(0, 0, "")
        }
        
        if !solutions.isEmpty {
            displaySolution(0)
        }
    }
    
    func displaySolution(_ index: Int) {
        guard index < solutions.count else { return }
        path = Array(repeating: Array(repeating: 0, count: maze.count), count: maze.count)
        
        var x = 0, y = 0
        path[x][y] = 1
        
        for char in solutions[index] {
            switch char {
            case "D": x += 1
            case "R": y += 1
            case "U": x -= 1
            case "L": y -= 1
            default: break
            }
            if x >= 0 && x < maze.count && y >= 0 && y < maze.count {
                path[x][y] = 1
            }
        }
    }
    
    func showNextSolution() {
        guard !solutions.isEmpty else { return }
        currentSolutionIndex = (currentSolutionIndex + 1) % solutions.count
        displaySolution(currentSolutionIndex)
    }
    
    func showPreviousSolution() {
        guard !solutions.isEmpty else { return }
        currentSolutionIndex = (currentSolutionIndex - 1 + solutions.count) % solutions.count
        displaySolution(currentSolutionIndex)
    }
    
    func reset() {
        setupMaze()
    }
}
