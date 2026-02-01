//
//  RatInMazeViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

// MARK: - Data Models

struct RatPosition: Identifiable, Equatable {
    let id = UUID()
    let row: Int
    let col: Int
}

struct PathStep: Identifiable {
    let id = UUID()
    let row: Int
    let col: Int
    let action: ActionType
    let reason: String
    let direction: String
    
    enum ActionType {
        case trying, moved, blocked, backtrack, success
    }
}

// MARK: - ViewModel

@MainActor
class RatInMazeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var maze: [[Int]] = []
    @Published var path: [[Int]] = []
    @Published var n = 4
    @Published var currentPosition: RatPosition = RatPosition(row: 0, col: 0)
    @Published var visitedCells: Set<String> = []
    @Published var currentStep = 0
    @Published var isAnimating = false
    @Published var isCompleted = false
    
    // MARK: - Visualization State
    @Published var tryingPosition: RatPosition?
    @Published var blockedPosition: RatPosition?
    @Published var backtrackingFrom: RatPosition?
    @Published var pathPositions: [RatPosition] = []
    
    // MARK: - Step History
    @Published var steps: [PathStep] = []
    @Published var currentStepDescription: String = ""
    
    // MARK: - Solutions
    @Published var solutions: [String] = []
    @Published var currentSolutionIndex = 0
    @Published var totalAttempts = 0
    @Published var backtrackCount = 0
    
    // MARK: - Statistics
    @Published var movementCount = 0
    @Published var blockedCount = 0
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Animation Settings
    @Published var animationSpeed: Double = 1.0
    private let baseDelay: Double = 0.6
    
    private var autoRunTask: Task<Void, Never>?
    
    // MARK: - Step Processing Lock
    @Published var isProcessingStep: Bool = false
    
    // MARK: - Algorithm State
    private var visited: [[Bool]] = []
    private var currentPathString: String = ""
    private var algorithmStack: [(row: Int, col: Int, path: String)] = []
    
    // MARK: - Initialization
    init() {
        setupMaze()
    }
    
    // MARK: - Generate Maze
    private func generateMaze(size: Int) -> [[Int]] {
        // Create a simple solvable maze pattern
        var newMaze = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        // Ensure start and end are open
        newMaze[0][0] = 1
        newMaze[size - 1][size - 1] = 1
        
        // Create a simple path pattern
        for i in 0..<size {
            for j in 0..<size {
                // Create a pattern with some blocked cells
                if i == 0 || j == 0 || i == size - 1 || j == size - 1 {
                    newMaze[i][j] = 1
                } else if (i + j) % 3 != 0 {
                    newMaze[i][j] = 1
                }
            }
        }
        
        return newMaze
    }
    
    // MARK: - Setup
    func setupMaze() {
        maze = generateMaze(size: n)
        path = Array(repeating: Array(repeating: 0, count: n), count: n)
        visited = Array(repeating: Array(repeating: false, count: n), count: n)
        currentPosition = RatPosition(row: 0, col: 0)
        visitedCells = []
        pathPositions = []
        steps = []
        currentStep = 0
        isCompleted = false
        tryingPosition = nil
        blockedPosition = nil
        backtrackingFrom = nil
        currentStepDescription = ""
        totalAttempts = 0
        backtrackCount = 0
        movementCount = 0
        blockedCount = 0
        solutions = []
        currentSolutionIndex = 0
        currentPathString = ""
        algorithmStack = []
        
        // Pre-calculate all solutions
        calculateSolutions()
    }
    
    private func calculateSolutions() {
        solutions = []
        
        // Generate a solvable maze
        let generatedMaze = generateMaze(size: n)
        
        var tempVisited = Array(repeating: Array(repeating: false, count: n), count: n)
        
        func isSafe(_ x: Int, _ y: Int) -> Bool {
            return x >= 0 && x < n && y >= 0 && y < n &&
                   generatedMaze[x][y] == 1 && !tempVisited[x][y]
        }
        
        func solveUtil(_ x: Int, _ y: Int, _ pathStr: String) {
            if x == n - 1 && y == n - 1 {
                solutions.append(pathStr)
                return
            }
            
            tempVisited[x][y] = true
            
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
            
            tempVisited[x][y] = false
        }
        
        if generatedMaze[0][0] == 1 {
            solveUtil(0, 0, "")
        }
    }
    
    // MARK: - User Actions
    func start() {
        withAnimation(.easeInOut(duration: 0.3)) {
            setupMaze()
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
            currentStepDescription = "Starting Rat in Maze algorithm for \(n)×\(n) maze"
            
            // Initialize algorithm state
            algorithmStack = [(row: 0, col: 0, path: "")]
        }
    }
    
    func nextStep() {
        guard canNext && !isCompleted && !isAnimating && !isProcessingStep else { return }
        performNextStep()
    }
    
    func runComplete() {
        guard canRunComplete else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupMaze()
            isAnimating = true
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
            currentStepDescription = "Running complete backtracking visualization..."
            
            // Initialize algorithm state
            algorithmStack = [(row: 0, col: 0, path: "")]
        }
        
        autoRunTask = Task {
            await runAnimatedSolution()
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupMaze()
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm with Animation
    private func runAnimatedSolution() async {
        await solveWithAnimation(row: 0, col: 0, pathStr: "")
        
        await MainActor.run {
            if !isCompleted && solutions.isEmpty {
                currentStepDescription = "❌ No solution exists for this maze"
            } else if !isCompleted {
                currentStepDescription = "✅ All solutions explored"
            }
            isAnimating = false
            canReset = true
        }
    }
    
    private func solveWithAnimation(row: Int, col: Int, pathStr: String) async {
        guard !Task.isCancelled else { return }
        
        await MainActor.run {
            totalAttempts += 1
            currentPosition = RatPosition(row: row, col: col)
        }
        
        // Check if reached destination
        if row == n - 1 && col == n - 1 {
            await reachedDestination(row: row, col: col, pathStr: pathStr)
            return
        }
        
        // Show trying animation
        await tryPosition(row: row, col: col)
        
        // Mark as visited
        await MainActor.run {
            visited[row][col] = true
            path[row][col] = 1
            pathPositions.append(RatPosition(row: row, col: col))
            visitedCells.insert("\(row),\(col)")
        }
        
        await moveToPosition(row: row, col: col)
        
        // Try all four directions
        let directions: [(Int, Int, String)] = [(1, 0, "D"), (0, 1, "R"), (-1, 0, "U"), (0, -1, "L")]
        
        for (dr, dc, dir) in directions {
            guard !Task.isCancelled else { return }
            
            let newRow = row + dr
            let newCol = col + dc
            
            if await isSafePosition(row: newRow, col: newCol) {
                await solveWithAnimation(row: newRow, col: newCol, pathStr: pathStr + dir)
                
                if await MainActor.run(body: { isCompleted }) {
                    return
                }
            } else if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
                await showBlocked(row: newRow, col: newCol)
            }
        }
        
        // Backtrack
        await backtrack(row: row, col: col)
    }
    
    private func performNextStep() {
        isProcessingStep = true
        canNext = false
        
        Task {
            guard !algorithmStack.isEmpty else {
                await MainActor.run {
                    if !isCompleted && solutions.isEmpty {
                        currentStepDescription = "❌ No solution exists for this maze"
                    }
                    isProcessingStep = false
                    canNext = false
                    canReset = true
                }
                return
            }
            
            let current = algorithmStack.removeFirst()
            let row = current.row
            let col = current.col
            let pathStr = current.path
            
            await MainActor.run {
                totalAttempts += 1
                currentPosition = RatPosition(row: row, col: col)
            }
            
            // Check if reached destination
            if row == n - 1 && col == n - 1 {
                await reachedDestination(row: row, col: col, pathStr: pathStr)
                await MainActor.run {
                    isProcessingStep = false
                    canNext = false
                    canReset = true
                }
                return
            }
            
            // Show trying animation
            await tryPosition(row: row, col: col)
            
            // Mark as visited
            await MainActor.run {
                visited[row][col] = true
                path[row][col] = 1
                pathPositions.append(RatPosition(row: row, col: col))
                visitedCells.insert("\(row),\(col)")
            }
            
            await moveToPosition(row: row, col: col)
            
            // Try all four directions and add to stack (in reverse order for correct exploration)
            let directions: [(Int, Int, String)] = [(0, -1, "L"), (-1, 0, "U"), (0, 1, "R"), (1, 0, "D")]
            var addedToStack = false
            
            for (dr, dc, dir) in directions {
                let newRow = row + dr
                let newCol = col + dc
                
                if await isSafePosition(row: newRow, col: newCol) {
                    algorithmStack.insert((row: newRow, col: newCol, path: pathStr + dir), at: 0)
                    addedToStack = true
                } else if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
                    await showBlocked(row: newRow, col: newCol)
                }
            }
            
            // If no valid moves, backtrack
            if !addedToStack {
                await backtrack(row: row, col: col)
            }
            
            await MainActor.run {
                isProcessingStep = false
                canNext = !isCompleted && !algorithmStack.isEmpty
            }
        }
    }
    
    // MARK: - Animation Helpers
    private func tryPosition(row: Int, col: Int) async {
        await MainActor.run {
            tryingPosition = RatPosition(row: row, col: col)
            currentStepDescription = "🔍 Exploring position (\(row), \(col))"
            
            let step = PathStep(
                row: row,
                col: col,
                action: .trying,
                reason: "Checking if position is safe",
                direction: ""
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
        
        await MainActor.run {
            tryingPosition = nil
        }
    }
    
    private func isSafePosition(row: Int, col: Int) async -> Bool {
        return await MainActor.run {
            return row >= 0 && row < n && col >= 0 && col < n &&
                   maze[row][col] == 1 && !visited[row][col]
        }
    }
    
    private func moveToPosition(row: Int, col: Int) async {
        await MainActor.run {
            movementCount += 1
            currentStepDescription = "➡️ Moved to position (\(row), \(col))"
            
            let step = PathStep(
                row: row,
                col: col,
                action: .moved,
                reason: "Valid path - continuing exploration",
                direction: ""
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
    }
    
    private func showBlocked(row: Int, col: Int) async {
        await MainActor.run {
            blockedPosition = RatPosition(row: row, col: col)
            blockedCount += 1
            
            let reason = maze[row][col] == 0 ? "Wall/Blocked cell" : "Already visited"
            currentStepDescription = "🚫 Position (\(row), \(col)) is blocked: \(reason)"
            
            let step = PathStep(
                row: row,
                col: col,
                action: .blocked,
                reason: reason,
                direction: ""
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
        
        await MainActor.run {
            blockedPosition = nil
        }
    }
    
    private func backtrack(row: Int, col: Int) async {
        await MainActor.run {
            backtrackingFrom = RatPosition(row: row, col: col)
            backtrackCount += 1
            currentStepDescription = "⬅️ Backtracking from position (\(row), \(col))"
            
            let step = PathStep(
                row: row,
                col: col,
                action: .backtrack,
                reason: "Dead end - trying alternative path",
                direction: ""
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
        
        await MainActor.run {
            visited[row][col] = false
            path[row][col] = 0
            if let index = pathPositions.firstIndex(where: { $0.row == row && $0.col == col }) {
                pathPositions.remove(at: index)
            }
            visitedCells.remove("\(row),\(col)")
            backtrackingFrom = nil
        }
    }
    
    private func reachedDestination(row: Int, col: Int, pathStr: String) async {
        await MainActor.run {
            visited[row][col] = true
            path[row][col] = 1
            pathPositions.append(RatPosition(row: row, col: col))
            
            isCompleted = true
            canNext = false
            
            currentStepDescription = "🎉 Destination reached! Path: \(pathStr)"
            
            let step = PathStep(
                row: row,
                col: col,
                action: .success,
                reason: "Successfully reached destination at (\(n-1), \(n-1))",
                direction: pathStr
            )
            steps.append(step)
            currentStep = steps.count
            
            if !isAnimating {
                canReset = true
            }
        }
        
        await delay()
    }
    
    private func delay() async {
        let delayTime = baseDelay / animationSpeed
        try? await Task.sleep(nanoseconds: UInt64(delayTime * 1_000_000_000))
    }
    
    // MARK: - Solution Navigation
    func showNextSolution() {
        guard !solutions.isEmpty else { return }
        currentSolutionIndex = (currentSolutionIndex + 1) % solutions.count
        loadSolution(at: currentSolutionIndex)
    }
    
    func showPreviousSolution() {
        guard !solutions.isEmpty else { return }
        currentSolutionIndex = (currentSolutionIndex - 1 + solutions.count) % solutions.count
        loadSolution(at: currentSolutionIndex)
    }
    
    private func loadSolution(at index: Int) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            path = Array(repeating: Array(repeating: 0, count: n), count: n)
            pathPositions = []
            
            var x = 0, y = 0
            path[x][y] = 1
            pathPositions.append(RatPosition(row: x, col: y))
            
            for char in solutions[index] {
                switch char {
                case "D": x += 1
                case "R": y += 1
                case "U": x -= 1
                case "L": y -= 1
                default: break
                }
                if x >= 0 && x < n && y >= 0 && y < n {
                    path[x][y] = 1
                    pathPositions.append(RatPosition(row: x, col: y))
                }
            }
            
            currentPosition = RatPosition(row: x, col: y)
        }
    }
}
