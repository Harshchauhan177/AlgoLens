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
    // MARK: - Published Properties
    @Published var board: [[Character]] = []
    @Published var word = "ABCCED"
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var found = false
    @Published var path: [(Int, Int)] = []
    @Published var currentCell: (Int, Int)? = nil
    @Published var visitedCells: Set<String> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var wordInput: String = "ABCCED"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var stepDescription: String = ""
    @Published var finalResult: String = ""
    @Published var currentDepth: Int = 0
    @Published var totalBacktracks: Int = 0
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Private State
    private var animationTask: Task<Void, Never>?
    private var steps: [SearchStep] = []
    private var currentStepIndex: Int = 0
    private let autoRunDelay: Double = 0.6
    
    struct SearchStep {
        let row: Int
        let col: Int
        let index: Int
        let isBacktrack: Bool
        let description: String
        let currentPath: [(Int, Int)]
        let visited: Set<String>
    }
    
    init() {
        setupBoard()
    }
    
    // MARK: - Setup
    func setupBoard() {
        board = [
            ["A","B","C","E"],
            ["S","F","C","S"],
            ["A","D","E","E"]
        ]
        word = wordInput
        found = false
        path = []
        currentStep = 0
        visitedCells = []
        currentCell = nil
        isCompleted = false
        stepDescription = ""
        finalResult = ""
        currentDepth = 0
        totalBacktracks = 0
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmed = wordInput.trimmingCharacters(in: .whitespaces).uppercased()
        guard !trimmed.isEmpty else {
            inputError = "Word cannot be empty"
            return
        }
        
        guard trimmed.count <= 15 else {
            inputError = "Word too long. Maximum 15 characters"
            return
        }
        
        guard trimmed.allSatisfy({ $0.isLetter }) else {
            inputError = "Word must contain only letters"
            return
        }
        
        wordInput = trimmed
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupBoard()
            word = wordInput
            isAnimating = true
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
        
        // Generate all steps
        generateSteps()
        
        if steps.isEmpty {
            completeSearch(found: false)
        } else {
            stepDescription = "Starting search for '\(word)'"
        }
    }
    
    func nextStep() {
        guard canNext && !isCompleted && !isAutoRunning else { return }
        performStep()
    }
    
    func runComplete() {
        guard canRunComplete else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupBoard()
            word = wordInput
            isAnimating = true
            isAutoRunning = true
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        generateSteps()
        
        animationTask = Task {
            await performCompleteSearch()
            
            await MainActor.run {
                isAutoRunning = false
                isAnimating = false
                canReset = true
            }
        }
    }
    
    func reset() {
        animationTask?.cancel()
        animationTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupBoard()
            steps = []
            currentStepIndex = 0
            isAnimating = false
            isCompleted = false
            isAutoRunning = false
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func generateSteps() {
        steps = []
        let rows = board.count
        let cols = board[0].count
        let chars = Array(word)
        var visited = Set<String>()
        var backtrackCount = 0
        
        func dfs(_ row: Int, _ col: Int, _ index: Int, _ currentPath: [(Int, Int)]) -> Bool {
            if index == chars.count {
                steps.append(SearchStep(
                    row: row,
                    col: col,
                    index: index,
                    isBacktrack: false,
                    description: "✓ Word '\(word)' found! Complete path discovered.",
                    currentPath: currentPath,
                    visited: visited
                ))
                return true
            }
            
            if row < 0 || row >= rows || col < 0 || col >= cols {
                return false
            }
            
            let key = "\(row),\(col)"
            
            if visited.contains(key) {
                steps.append(SearchStep(
                    row: row,
                    col: col,
                    index: index,
                    isBacktrack: false,
                    description: "⚠️ Cell (\(row), \(col)) already visited, skipping",
                    currentPath: currentPath,
                    visited: visited
                ))
                return false
            }
            
            if board[row][col] != chars[index] {
                steps.append(SearchStep(
                    row: row,
                    col: col,
                    index: index,
                    isBacktrack: false,
                    description: "✗ '\(board[row][col])' ≠ '\(chars[index])' at depth \(index)",
                    currentPath: currentPath,
                    visited: visited
                ))
                return false
            }
            
            visited.insert(key)
            var newPath = currentPath
            newPath.append((row, col))
            
            steps.append(SearchStep(
                row: row,
                col: col,
                index: index,
                isBacktrack: false,
                description: "✓ Found '\(chars[index])' at (\(row), \(col)), depth \(index + 1)/\(chars.count)",
                currentPath: newPath,
                visited: visited
            ))
            
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
            for (dr, dc) in directions {
                if dfs(row + dr, col + dc, index + 1, newPath) {
                    return true
                }
            }
            
            visited.remove(key)
            backtrackCount += 1
            steps.append(SearchStep(
                row: row,
                col: col,
                index: index,
                isBacktrack: true,
                description: "↩️ Backtracking from (\(row), \(col)), no path found",
                currentPath: currentPath,
                visited: visited
            ))
            
            return false
        }
        
        for row in 0..<rows {
            for col in 0..<cols {
                if dfs(row, col, 0, []) {
                    totalBacktracks = backtrackCount
                    return
                }
            }
        }
        
        totalBacktracks = backtrackCount
    }
    
    private func performStep() {
        guard currentStepIndex < steps.count else {
            completeSearch(found: !path.isEmpty)
            return
        }
        
        let step = steps[currentStepIndex]
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentCell = (step.row, step.col)
            path = step.currentPath
            visitedCells = step.visited
            stepDescription = step.description
            currentDepth = step.index
            currentStep += 1
            
            if step.currentPath.count == Array(word).count {
                found = true
            }
        }
        
        currentStepIndex += 1
        
        if currentStepIndex >= steps.count {
            completeSearch(found: found)
        }
    }
    
    private func performCompleteSearch() async {
        for (index, step) in steps.enumerated() {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                currentCell = (step.row, step.col)
                path = step.currentPath
                visitedCells = step.visited
                stepDescription = step.description
                currentDepth = step.index
                currentStep = index + 1
                currentStepIndex = index + 1
                
                if step.currentPath.count == Array(word).count {
                    found = true
                }
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
        }
        
        await MainActor.run {
            completeSearch(found: found)
        }
    }
    
    private func completeSearch(found: Bool) {
        self.found = found
        isCompleted = true
        canNext = false
        currentCell = nil
        stepDescription = ""
        
        if found {
            finalResult = "✓ Word '\(word)' found in \(currentStep) steps with \(totalBacktracks) backtracks!"
        } else {
            finalResult = "✗ Word '\(word)' not found after exploring \(currentStep) possibilities"
        }
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Cell State
    func cellState(row: Int, col: Int) -> CellState {
        let key = "\(row),\(col)"
        
        if let current = currentCell, current.0 == row && current.1 == col {
            return .current
        } else if path.contains(where: { $0.0 == row && $0.1 == col }) {
            return .inPath
        } else if visitedCells.contains(key) {
            return .visited
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    enum CellState {
        case unchecked
        case active
        case visited
        case current
        case inPath
    }
}
