//
//  SubsequenceCheckViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class SubsequenceCheckViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var mainString: String = "ahbgdc"
    @Published var subsequence: String = "abc"
    @Published var mainStringIndex: Int = -1
    @Published var subsequenceIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isChecking: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isMatching: Bool = false
    
    // MARK: - Input Fields
    @Published var mainStringInput: String = "ahbgdc"
    @Published var subsequenceInput: String = "abc"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var isSubsequence: Bool = false
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.6
    
    // MARK: - Initialization
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedMain = mainStringInput.trimmingCharacters(in: .whitespaces)
        let trimmedSub = subsequenceInput.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedMain.isEmpty else {
            inputError = "Main string cannot be empty"
            return
        }
        
        guard !trimmedSub.isEmpty else {
            inputError = "Subsequence cannot be empty"
            return
        }
        
        guard trimmedMain.count <= 30 else {
            inputError = "Main string too long. Maximum 30 characters"
            return
        }
        
        guard trimmedSub.count <= 15 else {
            inputError = "Subsequence too long. Maximum 15 characters"
            return
        }
        
        guard trimmedSub.count <= trimmedMain.count else {
            inputError = "Subsequence cannot be longer than main string"
            return
        }
        
        mainString = trimmedMain
        subsequence = trimmedSub
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isChecking = true
            mainStringIndex = 0
            subsequenceIndex = 0
            matchedIndices = []
            isCompleted = false
            isMatching = false
            isSubsequence = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
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
            isChecking = true
            isAutoRunning = true
            mainStringIndex = 0
            subsequenceIndex = 0
            matchedIndices = []
            isCompleted = false
            isMatching = false
            isSubsequence = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while mainStringIndex < mainString.count && subsequenceIndex < subsequence.count && !isCompleted {
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    performStep()
                }
                
                if isCompleted {
                    break
                }
            }
            
            await MainActor.run {
                if !isCompleted {
                    completeCheck()
                }
                isAutoRunning = false
                canReset = true
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            mainStringIndex = -1
            subsequenceIndex = -1
            matchedIndices = []
            isChecking = false
            isCompleted = false
            isAutoRunning = false
            isMatching = false
            isSubsequence = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        let mainArray = Array(mainString)
        let subArray = Array(subsequence)
        
        guard mainStringIndex < mainArray.count && subsequenceIndex < subArray.count else {
            completeCheck()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            let mainChar = mainArray[mainStringIndex]
            let subChar = subArray[subsequenceIndex]
            
            if mainChar == subChar {
                // Match found
                isMatching = true
                matchedIndices.append(mainStringIndex)
                comparisonResult = "✓ '\(mainChar)' matches '\(subChar)' at position \(mainStringIndex)"
                subsequenceIndex += 1
                
                // Check if entire subsequence matched
                if subsequenceIndex == subArray.count {
                    completeCheck()
                    return
                }
            } else {
                // No match
                isMatching = false
                comparisonResult = "✗ '\(mainChar)' ≠ '\(subChar)', continue searching"
            }
            
            mainStringIndex += 1
            
            // Check if we've exhausted the main string
            if mainStringIndex >= mainArray.count {
                completeCheck()
            }
        }
    }
    
    private func completeCheck() {
        isCompleted = true
        canNext = false
        isMatching = false
        
        let subArray = Array(subsequence)
        isSubsequence = (subsequenceIndex == subArray.count)
        
        if isSubsequence {
            finalResult = "✅ Success! '\(subsequence)' is a valid subsequence of '\(mainString)'"
        } else {
            finalResult = "❌ '\(subsequence)' is NOT a subsequence of '\(mainString)'"
            comparisonResult = "Could not find all characters in order"
        }
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func mainStringCharacterState(at index: Int) -> CharacterState {
        if matchedIndices.contains(index) {
            return .matched
        } else if isChecking && index == mainStringIndex {
            return .current
        } else if isChecking && index < mainStringIndex {
            return .visited
        }
        return .normal
    }
    
    func subsequenceCharacterState(at index: Int) -> CharacterState {
        if index < subsequenceIndex && isChecking {
            return .matched
        } else if index == subsequenceIndex && isChecking && !isCompleted {
            return .current
        }
        return .normal
    }
    
    enum CharacterState {
        case normal
        case current
        case visited
        case matched
    }
}
