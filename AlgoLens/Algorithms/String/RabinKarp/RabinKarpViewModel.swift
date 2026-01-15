//
//  RabinKarpViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class RabinKarpViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var text: String = "GEEKSFORGEEKS"
    @Published var pattern: String = "GEEK"
    @Published var currentTextIndex: Int = -1
    @Published var currentPatternIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isMatching: Bool = false
    
    // MARK: - Input Fields
    @Published var textInput: String = "GEEKSFORGEEKS"
    @Published var patternInput: String = "GEEK"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var foundPositions: [Int] = []
    
    // MARK: - Hash Information
    @Published var patternHash: Int = 0
    @Published var currentTextHash: Int = 0
    @Published var hashMatch: Bool = false
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Algorithm Constants
    private let prime = 101
    private let base = 256
    private var highestPower: Int = 1
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8
    
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
    
    // MARK: - Hash Calculation
    private func calculateHash(_ str: String) -> Int {
        var hash = 0
        for char in str {
            hash = (hash * base + Int(char.asciiValue ?? 0)) % prime
        }
        return hash
    }
    
    private func recalculateHash(oldHash: Int, oldChar: Character, newChar: Character, patternLength: Int) -> Int {
        var newHash = oldHash
        newHash = (newHash - Int(oldChar.asciiValue ?? 0) * highestPower) % prime
        if newHash < 0 { newHash += prime }
        newHash = (newHash * base + Int(newChar.asciiValue ?? 0)) % prime
        return newHash
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        // Calculate highest power for rolling hash
        highestPower = 1
        for _ in 0..<(pattern.count - 1) {
            highestPower = (highestPower * base) % prime
        }
        
        // Calculate initial hashes
        patternHash = calculateHash(pattern)
        let firstWindow = String(text.prefix(pattern.count))
        currentTextHash = calculateHash(firstWindow)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            currentTextIndex = 0
            currentPatternIndex = -1
            matchedIndices = []
            foundPositions = []
            isCompleted = false
            isMatching = false
            hashMatch = false
            comparisonResult = "Pattern hash: \(patternHash), Window hash: \(currentTextHash)"
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
        
        // Calculate highest power for rolling hash
        highestPower = 1
        for _ in 0..<(pattern.count - 1) {
            highestPower = (highestPower * base) % prime
        }
        
        // Calculate initial hashes
        patternHash = calculateHash(pattern)
        let firstWindow = String(text.prefix(pattern.count))
        currentTextHash = calculateHash(firstWindow)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            isAutoRunning = true
            currentTextIndex = 0
            currentPatternIndex = -1
            matchedIndices = []
            foundPositions = []
            isCompleted = false
            isMatching = false
            hashMatch = false
            comparisonResult = "Pattern hash: \(patternHash), Window hash: \(currentTextHash)"
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
            hashMatch = false
            comparisonResult = ""
            finalResult = ""
            patternHash = 0
            currentTextHash = 0
            
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
            // Check if hashes match
            if currentTextHash == patternHash {
                hashMatch = true
                comparisonResult = "✓ Hash match! Verifying characters..."
                
                // Verify character by character
                var isFullMatch = true
                for i in 0..<patternArray.count {
                    if textArray[currentTextIndex + i] != patternArray[i] {
                        isFullMatch = false
                        break
                    }
                }
                
                if isFullMatch {
                    foundPositions.append(currentTextIndex)
                    for i in 0..<patternArray.count {
                        if !matchedIndices.contains(currentTextIndex + i) {
                            matchedIndices.append(currentTextIndex + i)
                        }
                    }
                    isMatching = true
                    comparisonResult = "🎯 Pattern found at index \(currentTextIndex)! Hash: \(currentTextHash)"
                } else {
                    comparisonResult = "✗ Hash collision! Characters don't match"
                }
            } else {
                hashMatch = false
                isMatching = false
                comparisonResult = "Hash mismatch: Pattern(\(patternHash)) ≠ Window(\(currentTextHash))"
            }
            
            // Move to next position
            currentTextIndex += 1
            
            // Calculate rolling hash for next window
            if currentTextIndex <= text.count - pattern.count {
                let oldChar = textArray[currentTextIndex - 1]
                let newCharIndex = currentTextIndex + pattern.count - 1
                let newChar = textArray[newCharIndex]
                
                currentTextHash = recalculateHash(
                    oldHash: currentTextHash,
                    oldChar: oldChar,
                    newChar: newChar,
                    patternLength: pattern.count
                )
                
                if !isMatching {
                    comparisonResult += " → Rolling hash to \(currentTextHash)"
                }
            } else {
                completeSearch()
            }
            
            hashMatch = false
        }
    }
    
    private func completeSearch() {
        isCompleted = true
        canNext = false
        isMatching = false
        hashMatch = false
        
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
        } else if isSearching && index >= currentTextIndex - 1 && index < currentTextIndex - 1 + pattern.count && currentTextIndex > 0 {
            if hashMatch {
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
