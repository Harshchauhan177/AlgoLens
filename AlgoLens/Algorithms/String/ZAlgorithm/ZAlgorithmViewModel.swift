//
//  ZAlgorithmViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class ZAlgorithmViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var text: String = "AABAACAADAABAAABAA"
    @Published var pattern: String = "AABA"
    @Published var currentTextIndex: Int = -1
    @Published var currentPatternIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isMatching: Bool = false
    
    // MARK: - Input Fields
    @Published var textInput: String = "AABAACAADAABAAABAA"
    @Published var patternInput: String = "AABA"
    @Published var inputError: String?
    
    // MARK: - Z-Algorithm Specific
    @Published var zArray: [Int] = []
    @Published var combinedString: String = ""
    @Published var currentZIndex: Int = -1
    @Published var leftBound: Int = 0
    @Published var rightBound: Int = 0
    
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
            combinedString = pattern + "$" + text
            zArray = Array(repeating: 0, count: combinedString.count)
            currentZIndex = 1
            currentTextIndex = 0
            currentPatternIndex = 0
            matchedIndices = []
            foundPositions = []
            isCompleted = false
            isMatching = false
            leftBound = 0
            rightBound = 0
            comparisonResult = "Starting Z-Algorithm: Combined string = '\(combinedString)'"
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
            combinedString = pattern + "$" + text
            zArray = Array(repeating: 0, count: combinedString.count)
            currentZIndex = 1
            currentTextIndex = 0
            currentPatternIndex = 0
            matchedIndices = []
            foundPositions = []
            isCompleted = false
            isMatching = false
            leftBound = 0
            rightBound = 0
            comparisonResult = "Starting Z-Algorithm: Combined string = '\(combinedString)'"
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while currentZIndex < combinedString.count && !isCompleted {
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
            currentZIndex = -1
            matchedIndices = []
            foundPositions = []
            zArray = []
            combinedString = ""
            leftBound = 0
            rightBound = 0
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
    
    // MARK: - Core Z-Algorithm Logic
    private func performStep() {
        let combined = Array(combinedString)
        let patternLen = pattern.count
        
        guard currentZIndex < combined.count else {
            findMatches()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentZIndex > rightBound {
                // Case 1: Outside Z-box, compute from scratch
                leftBound = currentZIndex
                rightBound = currentZIndex
                
                comparisonResult = "Outside Z-box at position \(currentZIndex), computing from scratch..."
                
                while rightBound < combined.count && combined[rightBound] == combined[rightBound - leftBound] {
                    rightBound += 1
                }
                
                zArray[currentZIndex] = rightBound - leftBound
                rightBound -= 1
                
                if zArray[currentZIndex] > 0 {
                    comparisonResult = "✓ Z[\(currentZIndex)] = \(zArray[currentZIndex]) (matched \(zArray[currentZIndex]) characters)"
                } else {
                    comparisonResult = "✗ Z[\(currentZIndex)] = 0 (no match)"
                }
                
            } else {
                // Case 2: Inside Z-box, use previously computed values
                let k = currentZIndex - leftBound
                
                if zArray[k] < rightBound - currentZIndex + 1 {
                    // Can directly copy
                    zArray[currentZIndex] = zArray[k]
                    comparisonResult = "Inside Z-box: Z[\(currentZIndex)] = Z[\(k)] = \(zArray[k]) (copied value)"
                } else {
                    // Need to extend
                    leftBound = currentZIndex
                    var newRight = rightBound + 1
                    
                    while newRight < combined.count && combined[newRight] == combined[newRight - leftBound] {
                        newRight += 1
                    }
                    
                    zArray[currentZIndex] = newRight - leftBound
                    rightBound = newRight - 1
                    
                    comparisonResult = "Extended match: Z[\(currentZIndex)] = \(zArray[currentZIndex])"
                }
            }
            
            // Check if this position matches the pattern
            if currentZIndex > patternLen && zArray[currentZIndex] == patternLen {
                let matchPos = currentZIndex - patternLen - 1
                if !foundPositions.contains(matchPos) {
                    foundPositions.append(matchPos)
                    for i in 0..<patternLen {
                        if !matchedIndices.contains(matchPos + i) {
                            matchedIndices.append(matchPos + i)
                        }
                    }
                    comparisonResult += " → 🎯 Pattern found at index \(matchPos)!"
                }
            }
            
            currentZIndex += 1
            
            // Check if algorithm is complete
            if currentZIndex >= combined.count {
                findMatches()
            }
        }
    }
    
    private func findMatches() {
        isCompleted = true
        canNext = false
        isMatching = false
        
        if foundPositions.isEmpty {
            finalResult = "Pattern '\(pattern)' not found in text"
            comparisonResult = ""
        } else if foundPositions.count == 1 {
            finalResult = "Success! Pattern found at position \(foundPositions[0])"
        } else {
            let positions = foundPositions.sorted().map { String($0) }.joined(separator: ", ")
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
        } else if isSearching && currentZIndex >= 0 {
            let patternLen = pattern.count
            if index >= currentTextIndex && index < currentTextIndex + patternLen {
                return .comparing
            }
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
