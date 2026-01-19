//
//  NQueensViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

// MARK: - Data Models

struct QueenPosition: Identifiable, Equatable {
    let id = UUID()
    let row: Int
    let col: Int
}

struct ThreatLine: Identifiable, Equatable {
    let id = UUID()
    let from: QueenPosition
    let to: (row: Int, col: Int)
    let type: ThreatType
    
    enum ThreatType {
        case horizontal, vertical, diagonalUp, diagonalDown
    }
    
    // Manual Equatable conformance since tuples don't auto-conform
    static func == (lhs: ThreatLine, rhs: ThreatLine) -> Bool {
        lhs.from == rhs.from &&
        lhs.to.row == rhs.to.row &&
        lhs.to.col == rhs.to.col &&
        lhs.type == rhs.type
    }
}

struct BacktrackStep: Identifiable {
    let id = UUID()
    let row: Int
    let col: Int
    let action: ActionType
    let reason: String
    
    enum ActionType {
        case trying, placed, conflict, backtrack, success
    }
}

struct CallStackFrame: Identifiable, Equatable {
    let id = UUID()
    let row: Int
    let isActive: Bool
}

// MARK: - ViewModel

@MainActor
class NQueensViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var board: [[Int]] = []
    @Published var n = 4
    @Published var queens: [QueenPosition] = []
    @Published var currentStep = 0
    @Published var isAnimating = false
    @Published var isCompleted = false
    
    // MARK: - Input
    @Published var boardSizeInput: String = "4"
    @Published var inputError: String?
    
    // MARK: - Visualization State
    @Published var tryingPosition: QueenPosition?
    @Published var conflictPosition: QueenPosition?
    @Published var backtrackingFrom: QueenPosition?
    @Published var currentRow: Int = 0
    @Published var currentCol: Int = 0
    @Published var threatLines: [ThreatLine] = []
    @Published var conflictLines: [ThreatLine] = []
    
    // MARK: - Step History
    @Published var steps: [BacktrackStep] = []
    @Published var currentStepDescription: String = ""
    @Published var callStack: [CallStackFrame] = []
    
    // MARK: - Solutions
    @Published var solutions: [[[Int]]] = []
    @Published var currentSolutionIndex = 0
    @Published var totalAttempts = 0
    @Published var backtrackCount = 0
    
    // MARK: - Statistics
    @Published var placementCount = 0
    @Published var conflictCount = 0
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Animation Settings
    @Published var animationSpeed: Double = 1.0
    private let baseDelay: Double = 0.8
    
    private var autoRunTask: Task<Void, Never>?
    
    // MARK: - Step Processing Lock
    @Published var isProcessingStep: Bool = false
    
    // MARK: - Initialization
    init() {
        setupBoard()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedInput = boardSizeInput.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedInput.isEmpty else {
            inputError = "Board size cannot be empty"
            solutions = [] // Clear solutions when input is invalid
            return
        }
        
        guard let size = Int(trimmedInput) else {
            inputError = "Please enter a valid number"
            solutions = [] // Clear solutions when input is invalid
            return
        }
        
        guard size >= 4 else {
            inputError = "Minimum size is 4×4"
            solutions = [] // Clear solutions when input is invalid
            return
        }
        
        guard size <= 8 else {
            inputError = "Maximum size is 8×8"
            solutions = [] // Clear solutions when input is invalid
            return
        }
        
        // Update board size and recalculate solutions immediately
        n = size
        calculateSolutionsForSize(size)
    }
    
    // MARK: - Calculate solutions for a specific board size
    private func calculateSolutionsForSize(_ boardSize: Int) {
        solutions = []
        var tempBoard = Array(repeating: Array(repeating: 0, count: boardSize), count: boardSize)
        
        func isSafe(_ row: Int, _ col: Int) -> Bool {
            // Check column
            for i in 0..<row {
                if tempBoard[i][col] == 1 { return false }
            }
            
            // Check upper-left diagonal
            var i = row - 1, j = col - 1
            while i >= 0 && j >= 0 {
                if tempBoard[i][j] == 1 { return false }
                i -= 1
                j -= 1
            }
            
            // Check upper-right diagonal
            i = row - 1
            j = col + 1
            while i >= 0 && j < boardSize {
                if tempBoard[i][j] == 1 { return false }
                i -= 1
                j += 1
            }
            
            return true
        }
        
        func solveUtil(_ row: Int) {
            if row >= boardSize {
                solutions.append(tempBoard)
                return
            }
            
            for col in 0..<boardSize {
                if isSafe(row, col) {
                    tempBoard[row][col] = 1
                    solveUtil(row + 1)
                    tempBoard[row][col] = 0
                }
            }
        }
        
        solveUtil(0)
    }
    
    // MARK: - Setup
    func setupBoard() {
        board = Array(repeating: Array(repeating: 0, count: n), count: n)
        queens = []
        steps = []
        callStack = []
        currentStep = 0
        currentRow = 0
        currentCol = 0
        isCompleted = false
        tryingPosition = nil
        conflictPosition = nil
        backtrackingFrom = nil
        threatLines = []
        conflictLines = []
        currentStepDescription = ""
        totalAttempts = 0
        backtrackCount = 0
        placementCount = 0
        conflictCount = 0
        solutions = []
        currentSolutionIndex = 0
        
        // Pre-calculate all solutions
        calculateSolutions()
    }
    
    private func calculateSolutions() {
        calculateSolutionsForSize(n)
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupBoard()
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
            currentStepDescription = "Starting N-Queens algorithm for \(n)×\(n) board"
        }
    }
    
    func nextStep() {
        guard canNext && !isCompleted && !isAnimating && !isProcessingStep else { return }
        performNextStep()
    }
    
    func runComplete() {
        guard canRunComplete else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupBoard()
            isAnimating = true
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
            currentStepDescription = "Running complete backtracking visualization..."
        }
        
        autoRunTask = Task {
            await runAnimatedSolution()
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupBoard()
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm with Animation
    private func runAnimatedSolution() async {
        await solveWithAnimation(row: 0)
        
        await MainActor.run {
            if !isCompleted {
                completeAlgorithm()
            }
            isAnimating = false
            canReset = true
        }
    }
    
    private func solveWithAnimation(row: Int) async {
        guard !Task.isCancelled else { return }
        
        // Add to call stack
        await MainActor.run {
            callStack.append(CallStackFrame(row: row, isActive: true))
            currentRow = row
        }
        
        // Base case - all queens placed
        if row >= n {
            await MainActor.run {
                completeAlgorithm()
            }
            return
        }
        
        // Try each column in this row
        for col in 0..<n {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                currentCol = col
                totalAttempts += 1
            }
            
            // Show trying animation
            await tryPosition(row: row, col: col)
            
            if await isSafePosition(row: row, col: col) {
                // Place queen
                await placeQueen(row: row, col: col)
                
                // Recurse to next row
                await solveWithAnimation(row: row + 1)
                
                // If solution found, stop
                if await MainActor.run(body: { isCompleted }) {
                    return
                }
                
                // Backtrack - remove queen
                await removeQueen(row: row, col: col)
            } else {
                // Show conflict
                await showConflict(row: row, col: col)
            }
        }
        
        // Remove from call stack (backtracking from this row)
        await MainActor.run {
            if !callStack.isEmpty {
                callStack.removeLast()
            }
            if row > 0 && !isCompleted {
                backtrackCount += 1
                currentStepDescription = "⬅️ Backtracking from Row \(row) - No valid position found"
            }
        }
        
        await delay()
    }
    
    private func performNextStep() {
        // Disable the button while processing
        isProcessingStep = true
        canNext = false
        
        Task {
            // Check completion first
            if queens.count == n {
                await MainActor.run {
                    completeAlgorithm()
                    isProcessingStep = false
                }
                return
            }
            
            // Validate currentRow is within bounds
            guard currentRow >= 0 && currentRow < n else {
                await MainActor.run {
                    print("⚠️ Invalid currentRow: \(currentRow), resetting to 0")
                    currentRow = 0
                    currentCol = 0
                    isProcessingStep = false
                    canNext = !isCompleted
                }
                return
            }
            
            // Validate currentCol is within bounds
            guard currentCol >= 0 && currentCol <= n else {
                await MainActor.run {
                    print("⚠️ Invalid currentCol: \(currentCol), clamping to valid range")
                    currentCol = min(max(0, currentCol), n)
                    isProcessingStep = false
                    canNext = !isCompleted
                }
                return
            }
            
            // Try next position in current row
            if currentCol < n {
                // Validate indices before proceeding
                guard currentRow < n && currentCol < n else {
                    await MainActor.run {
                        print("⚠️ Index validation failed: row=\(currentRow), col=\(currentCol), n=\(n)")
                        completeAlgorithm()
                        isProcessingStep = false
                    }
                    return
                }
                
                await tryPosition(row: currentRow, col: currentCol)
                
                if await isSafePosition(row: currentRow, col: currentCol) {
                    // Place queen and move to next row
                    await placeQueen(row: currentRow, col: currentCol)
                    
                    await MainActor.run {
                        currentRow += 1
                        currentCol = 0
                        
                        // Check if we've completed all rows
                        if currentRow >= n {
                            completeAlgorithm()
                        }
                        
                        // Re-enable button after animation completes
                        isProcessingStep = false
                        canNext = !isCompleted
                    }
                } else {
                    // Conflict detected, try next column
                    await showConflict(row: currentRow, col: currentCol)
                    
                    await MainActor.run {
                        currentCol += 1
                        
                        // If we've tried all columns in this row, need to backtrack
                        if currentCol >= n {
                            performBacktrackStep()
                        } else {
                            // Re-enable button after animation completes
                            isProcessingStep = false
                            canNext = !isCompleted
                        }
                    }
                }
            } else {
                // Already at end of row, need to backtrack
                await MainActor.run {
                    performBacktrackStep()
                }
            }
        }
    }
    
    private func performBacktrackStep() {
        // Check if we can backtrack
        guard !queens.isEmpty else {
            // No more queens to backtrack, no solution possible
            currentStepDescription = "❌ No solution exists for this configuration"
            canNext = false
            canReset = true
            isProcessingStep = false
            return
        }
        
        // Get the last placed queen
        guard let lastQueen = queens.last else {
            isProcessingStep = false
            canNext = !isCompleted
            return
        }
        
        // Remove the queen and try next column in previous row
        Task {
            await removeQueen(row: lastQueen.row, col: lastQueen.col)
            
            await MainActor.run {
                currentRow = lastQueen.row
                currentCol = lastQueen.col + 1
                backtrackCount += 1
                
                // Validate the new state
                if currentCol >= n {
                    // Need to backtrack further
                    if !queens.isEmpty {
                        performBacktrackStep()
                    } else {
                        // No solution exists
                        currentStepDescription = "❌ No solution exists - tried all possibilities"
                        canNext = false
                        canReset = true
                        isProcessingStep = false
                    }
                } else {
                    // Re-enable button after backtracking animation completes
                    isProcessingStep = false
                    canNext = !isCompleted
                }
            }
        }
    }
    
    // MARK: - Animation Helpers
    private func tryPosition(row: Int, col: Int) async {
        await MainActor.run {
            tryingPosition = QueenPosition(row: row, col: col)
            currentStepDescription = "🔍 Trying to place queen at Row \(row), Column \(col)"
            
            let step = BacktrackStep(
                row: row,
                col: col,
                action: .trying,
                reason: "Checking if position is safe"
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
            // Check for conflicts with existing queens
            for queen in queens {
                // Same column
                if queen.col == col {
                    return false
                }
                
                // Same diagonal
                if abs(queen.row - row) == abs(queen.col - col) {
                    return false
                }
            }
            return true
        }
    }
    
    private func placeQueen(row: Int, col: Int) async {
        await MainActor.run {
            let queen = QueenPosition(row: row, col: col)
            queens.append(queen)
            board[row][col] = 1
            placementCount += 1
            
            // Update threat lines
            updateThreatLines()
            
            currentStepDescription = "✅ Queen placed at Row \(row), Column \(col)"
            
            let step = BacktrackStep(
                row: row,
                col: col,
                action: .placed,
                reason: "Position is safe - no conflicts"
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
    }
    
    private func showConflict(row: Int, col: Int) async {
        await MainActor.run {
            conflictPosition = QueenPosition(row: row, col: col)
            conflictCount += 1
            
            // Find and show conflict lines
            for queen in queens {
                if queen.col == col || abs(queen.row - row) == abs(queen.col - col) {
                    let line = ThreatLine(
                        from: queen,
                        to: (row, col),
                        type: queen.col == col ? .vertical : 
                              (queen.row < row && queen.col < col) || (queen.row > row && queen.col > col) ? .diagonalDown : .diagonalUp
                    )
                    conflictLines.append(line)
                }
            }
            
            let reason = getConflictReason(row: row, col: col)
            currentStepDescription = "❌ Conflict at Row \(row), Column \(col): \(reason)"
            
            let step = BacktrackStep(
                row: row,
                col: col,
                action: .conflict,
                reason: reason
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
        
        await MainActor.run {
            conflictPosition = nil
            conflictLines = []
        }
    }
    
    private func removeQueen(row: Int, col: Int) async {
        await MainActor.run {
            backtrackingFrom = QueenPosition(row: row, col: col)
            currentStepDescription = "⬅️ Backtracking: Removing queen from Row \(row), Column \(col)"
            
            let step = BacktrackStep(
                row: row,
                col: col,
                action: .backtrack,
                reason: "No solution found with this placement"
            )
            steps.append(step)
            currentStep = steps.count
        }
        
        await delay()
        
        await MainActor.run {
            if let index = queens.firstIndex(where: { $0.row == row && $0.col == col }) {
                queens.remove(at: index)
            }
            board[row][col] = 0
            backtrackingFrom = nil
            updateThreatLines()
        }
    }
    
    private func updateThreatLines() {
        threatLines = []
        for queen in queens {
            // Add lines for all threatened positions
            for r in 0..<n {
                for c in 0..<n {
                    if r == queen.row || c == queen.col || 
                       abs(r - queen.row) == abs(c - queen.col) {
                        if r != queen.row || c != queen.col {
                            let type: ThreatLine.ThreatType
                            if r == queen.row {
                                type = .horizontal
                            } else if c == queen.col {
                                type = .vertical
                            } else if (r - queen.row) * (c - queen.col) > 0 {
                                type = .diagonalDown
                            } else {
                                type = .diagonalUp
                            }
                            
                            // Only add if not duplicate
                            let exists = threatLines.contains { 
                                $0.from == queen && $0.to.row == r && $0.to.col == c 
                            }
                            if !exists {
                                threatLines.append(ThreatLine(from: queen, to: (r, c), type: type))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getConflictReason(row: Int, col: Int) -> String {
        for queen in queens {
            if queen.col == col {
                return "Same column as queen at Row \(queen.row)"
            }
            if abs(queen.row - row) == abs(queen.col - col) {
                return "Diagonal attack from queen at Row \(queen.row), Column \(queen.col)"
            }
        }
        return "Position conflicts with existing queen"
    }
    
    private func completeAlgorithm() {
        isCompleted = true
        canNext = false
        
        currentStepDescription = "🎉 Solution found! All \(n) queens placed successfully"
        
        let step = BacktrackStep(
            row: -1,
            col: -1,
            action: .success,
            reason: "Successfully placed all \(n) queens on the board"
        )
        steps.append(step)
        currentStep = steps.count
        
        if !isAnimating {
            canReset = true
        }
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
            board = solutions[index]
            queens = []
            
            for row in 0..<n {
                for col in 0..<n {
                    if board[row][col] == 1 {
                        queens.append(QueenPosition(row: row, col: col))
                    }
                }
            }
            
            updateThreatLines()
        }
    }
}
