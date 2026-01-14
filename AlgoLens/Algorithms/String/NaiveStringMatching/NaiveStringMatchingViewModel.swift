//
//  NaiveStringMatchingViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class NaiveStringMatchingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var text: String = "ABABDABACDABABCABAB"
    @Published var pattern: String = "ABABCABAB"
    @Published var currentTextIndex: Int = -1
    @Published var currentPatternIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isMatching: Bool = false
    
    // MARK: - Input Fields
    @Published var textInput: String = "ABABDABACDABABCABAB"
    @Published var patternInput: String = "ABABCABAB"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var foundPositions: [Int] = []
    
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
        
        let trimmedText = textInput.trimmingCharacters(in: .whitespaces)
        let trimmedPattern = patternInput.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedText.isEmpty else {
            inputError = "Text cannot be empty"
            return
        }
        
        guard !trimmedPattern.isEmpty else {
            inputError = "Pattern cannot be empty"
            return
        }
        
        guard trimmedText.count <= 30 else {
            inputError = "Text too long. Maximum 30 characters"
            return
        }
        
        guard trimmedPattern.count <= 15 else {
            inputError = "Pattern too long. Maximum 15 characters"
            return
        }
        
        guard trimmedPattern.count <= trimmedText.count else {
            inputError = "Pattern cannot be longer than text"
            return
        }
        
        text = trimmedText
        pattern = trimmedPattern
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            currentTextIndex = 0
            currentPatternIndex = 0
            matchedIndices = []
            foundPositions = []
            isCompleted = false
            isMatching = false
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
            isSearching = true
            isAutoRunning = true
            currentTextIndex = 0
            currentPatternIndex = 0
            matchedIndices = []
            foundPositions = []
            isCompleted = false
            isMatching = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while currentTextIndex <= text.count - pattern.count && !isCompleted {
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
                isAutoRunning = false
                canReset = true
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTextIndex = -1
            currentPatternIndex = -1
            matchedIndices = []
            foundPositions = []
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            isMatching = false
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
        let textArray = Array(text)
        let patternArray = Array(pattern)
        
        guard currentTextIndex <= text.count - pattern.count else {
            completeSearch()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentPatternIndex < patternArray.count {
                let textChar = textArray[currentTextIndex + currentPatternIndex]
                let patternChar = patternArray[currentPatternIndex]
                
                if textChar == patternChar {
                    // Match continues
                    isMatching = true
                    comparisonResult = "✓ '\(textChar)' matches '\(patternChar)' at position \(currentTextIndex + currentPatternIndex)"
                    currentPatternIndex += 1
                    
                    // Check if full pattern matched
                    if currentPatternIndex == patternArray.count {
                        foundPositions.append(currentTextIndex)
                        for i in 0..<patternArray.count {
                            if !matchedIndices.contains(currentTextIndex + i) {
                                matchedIndices.append(currentTextIndex + i)
                            }
                        }
                        comparisonResult = "🎯 Pattern found at index \(currentTextIndex)!"
                        
                        // Move to next position
                        currentTextIndex += 1
                        currentPatternIndex = 0
                        isMatching = false
                    }
                } else {
                    // Mismatch
                    isMatching = false
                    comparisonResult = "✗ '\(textChar)' ≠ '\(patternChar)', shift pattern to next position"
                    currentTextIndex += 1
                    currentPatternIndex = 0
                }
            }
            
            // Check if search is complete
            if currentTextIndex > text.count - pattern.count {
                completeSearch()
            }
        }
    }
    
    private func completeSearch() {
        isCompleted = true
        canNext = false
        isMatching = false
        
        if foundPositions.isEmpty {
            finalResult = "Pattern '\(pattern)' not found in text"
            comparisonResult = ""
        } else if foundPositions.count == 1 {
            finalResult = "Success! Pattern found at position \(foundPositions[0])"
        } else {
            let positions = foundPositions.map { String($0) }.joined(separator: ", ")
            finalResult = "Success! Pattern found at \(foundPositions.count) positions: [\(positions)]"
        }
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func characterState(at index: Int) -> CharacterState {
        if matchedIndices.contains(index) {
            return .matched
        } else if isSearching && index >= currentTextIndex && index < currentTextIndex + pattern.count {
            if index == currentTextIndex + currentPatternIndex && isMatching {
                return .current
            } else if index < currentTextIndex + currentPatternIndex {
                return .matching
            }
            return .comparing
        }
        return .normal
    }
    
    enum CharacterState {
        case normal
        case comparing
        case current
        case matching
        case matched
    }
}
