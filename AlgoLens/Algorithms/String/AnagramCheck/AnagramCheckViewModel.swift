//
//  AnagramCheckViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class AnagramCheckViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var string1: String = "listen"
    @Published var string2: String = "silent"
    @Published var currentString1Index: Int = -1
    @Published var currentString2Index: Int = -1
    @Published var charCountMap: [Character: Int] = [:]
    @Published var processedChars1: Set<Int> = []
    @Published var processedChars2: Set<Int> = []
    @Published var currentChar: Character?
    @Published var isChecking: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isAnagram: Bool = false
    @Published var currentPhase: Phase = .idle
    
    // MARK: - Input Fields
    @Published var string1Input: String = "listen"
    @Published var string2Input: String = "silent"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var stepDescription: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8
    
    enum Phase {
        case idle
        case checkingLength
        case countingString1
        case verifyingString2
        case completed
    }
    
    // MARK: - Initialization
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmed1 = string1Input.trimmingCharacters(in: .whitespaces)
        let trimmed2 = string2Input.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed1.isEmpty else {
            inputError = "First string cannot be empty"
            return
        }
        
        guard !trimmed2.isEmpty else {
            inputError = "Second string cannot be empty"
            return
        }
        
        guard trimmed1.count <= 20 else {
            inputError = "First string too long. Maximum 20 characters"
            return
        }
        
        guard trimmed2.count <= 20 else {
            inputError = "Second string too long. Maximum 20 characters"
            return
        }
        
        string1 = trimmed1
        string2 = trimmed2
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isChecking = true
            currentString1Index = -1
            currentString2Index = -1
            charCountMap = [:]
            processedChars1 = []
            processedChars2 = []
            currentChar = nil
            isCompleted = false
            isAnagram = false
            currentPhase = .checkingLength
            stepDescription = ""
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
            currentString1Index = -1
            currentString2Index = -1
            charCountMap = [:]
            processedChars1 = []
            processedChars2 = []
            currentChar = nil
            isCompleted = false
            isAnagram = false
            currentPhase = .checkingLength
            stepDescription = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while !isCompleted {
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
            currentString1Index = -1
            currentString2Index = -1
            charCountMap = [:]
            processedChars1 = []
            processedChars2 = []
            currentChar = nil
            isChecking = false
            isCompleted = false
            isAutoRunning = false
            isAnagram = false
            currentPhase = .idle
            stepDescription = ""
            finalResult = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentPhase {
            case .idle:
                break
                
            case .checkingLength:
                if string1.count != string2.count {
                    stepDescription = "❌ Length mismatch: '\(string1)' has \(string1.count) chars, '\(string2)' has \(string2.count) chars"
                    completeCheck(isAnagram: false)
                } else {
                    stepDescription = "✓ Length check passed: Both strings have \(string1.count) characters"
                    currentPhase = .countingString1
                    currentString1Index = 0
                }
                
            case .countingString1:
                let chars = Array(string1)
                if currentString1Index < chars.count {
                    let char = chars[currentString1Index]
                    currentChar = char
                    charCountMap[char, default: 0] += 1
                    processedChars1.insert(currentString1Index)
                    
                    stepDescription = "📝 Counting '\(char)' from first string - count is now \(charCountMap[char]!)"
                    
                    currentString1Index += 1
                } else {
                    stepDescription = "✓ Finished counting all characters in first string"
                    currentPhase = .verifyingString2
                    currentString2Index = 0
                    currentChar = nil
                }
                
            case .verifyingString2:
                let chars = Array(string2)
                if currentString2Index < chars.count {
                    let char = chars[currentString2Index]
                    currentChar = char
                    
                    if let count = charCountMap[char], count > 0 {
                        charCountMap[char] = count - 1
                        processedChars2.insert(currentString2Index)
                        stepDescription = "✓ Found '\(char)' in second string - count decremented to \(charCountMap[char]!)"
                        currentString2Index += 1
                    } else {
                        stepDescription = "❌ Character '\(char)' not found or count exhausted - Not an anagram!"
                        completeCheck(isAnagram: false)
                    }
                } else {
                    stepDescription = "✓ All characters verified successfully!"
                    completeCheck(isAnagram: true)
                }
                
            case .completed:
                break
            }
        }
    }
    
    private func completeCheck(isAnagram: Bool) {
        self.isAnagram = isAnagram
        isCompleted = true
        canNext = false
        currentPhase = .completed
        
        if isAnagram {
            finalResult = "🎉 Success! '\(string1)' and '\(string2)' are anagrams"
        } else {
            finalResult = "❌ '\(string1)' and '\(string2)' are NOT anagrams"
        }
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Character State
    func characterState1(at index: Int) -> CharacterState {
        if processedChars1.contains(index) {
            if index == currentString1Index - 1 && currentPhase == .countingString1 {
                return .current
            }
            return .processed
        } else if index == currentString1Index && currentPhase == .countingString1 {
            return .current
        }
        return .normal
    }
    
    func characterState2(at index: Int) -> CharacterState {
        if processedChars2.contains(index) {
            if index == currentString2Index - 1 && currentPhase == .verifyingString2 {
                return .verified
            }
            return .verified
        } else if index == currentString2Index && currentPhase == .verifyingString2 {
            if let char = currentChar, let count = charCountMap[char], count > 0 {
                return .current
            } else {
                return .mismatch
            }
        }
        return .normal
    }
    
    enum CharacterState {
        case normal
        case current
        case processed
        case verified
        case mismatch
    }
}
