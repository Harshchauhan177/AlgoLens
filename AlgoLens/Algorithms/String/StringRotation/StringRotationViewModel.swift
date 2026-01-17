//
//  StringRotationViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class StringRotationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var string1: String = "WATERBOTTLE"
    @Published var string2: String = "ERBOTTLEWAT"
    @Published var concatenated: String = ""
    @Published var currentIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isChecking: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isMatching: Bool = false
    
    // MARK: - Input Fields
    @Published var string1Input: String = "WATERBOTTLE"
    @Published var string2Input: String = "ERBOTTLEWAT"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var isRotation: Bool = false
    @Published var currentStep: Int = 0
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
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
        
        let trimmed1 = string1Input.trimmingCharacters(in: .whitespaces).uppercased()
        let trimmed2 = string2Input.trimmingCharacters(in: .whitespaces).uppercased()
        
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
            currentIndex = -1
            matchedIndices = []
            isCompleted = false
            isMatching = false
            isRotation = false
            comparisonResult = ""
            finalResult = ""
            currentStep = 0
            concatenated = ""
            
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
            currentIndex = -1
            matchedIndices = []
            isCompleted = false
            isMatching = false
            isRotation = false
            comparisonResult = ""
            finalResult = ""
            currentStep = 0
            concatenated = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while currentStep <= 4 && !isCompleted {
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
            currentIndex = -1
            matchedIndices = []
            isChecking = false
            isCompleted = false
            isAutoRunning = false
            isMatching = false
            isRotation = false
            comparisonResult = ""
            finalResult = ""
            currentStep = 0
            concatenated = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentStep {
            case 0:
                // Step 1: Check lengths
                comparisonResult = "Checking if both strings have equal length..."
                if string1.count != string2.count {
                    finalResult = "Lengths differ (\(string1.count) ≠ \(string2.count)). Not a rotation!"
                    isRotation = false
                    isCompleted = true
                    canNext = false
                    if !isAutoRunning {
                        canReset = true
                    }
                } else {
                    comparisonResult = "✓ Lengths match (\(string1.count) = \(string2.count))"
                    currentStep += 1
                }
                
            case 1:
                // Step 2: Create concatenation
                concatenated = string1 + string1
                comparisonResult = "Creating concatenated string: '\(string1)' + '\(string1)' = '\(concatenated)'"
                currentStep += 1
                
            case 2:
                // Step 3: Start searching for string2 in concatenated
                comparisonResult = "Searching for '\(string2)' in '\(concatenated)'..."
                currentIndex = 0
                currentStep += 1
                
            case 3:
                // Step 4: Perform substring search
                if currentIndex <= concatenated.count - string2.count {
                    let concatArray = Array(concatenated)
                    let string2Array = Array(string2)
                    
                    var matches = true
                    for i in 0..<string2Array.count {
                        if concatArray[currentIndex + i] != string2Array[i] {
                            matches = false
                            break
                        }
                    }
                    
                    if matches {
                        // Found match
                        for i in 0..<string2.count {
                            matchedIndices.append(currentIndex + i)
                        }
                        isMatching = true
                        comparisonResult = "🎯 Found '\(string2)' at position \(currentIndex) in concatenated string!"
                        isRotation = true
                        currentStep += 1
                    } else {
                        comparisonResult = "Checking position \(currentIndex)... no match, continue searching"
                        currentIndex += 1
                        
                        if currentIndex > concatenated.count - string2.count {
                            // Not found
                            isRotation = false
                            currentStep += 1
                        }
                    }
                } else {
                    isRotation = false
                    currentStep += 1
                }
                
            case 4:
                // Step 5: Complete
                completeCheck()
                
            default:
                break
            }
        }
    }
    
    private func completeCheck() {
        isCompleted = true
        canNext = false
        isMatching = false
        
        if isRotation {
            finalResult = "Success! '\(string2)' is a rotation of '\(string1)'"
        } else {
            finalResult = "'\(string2)' is NOT a rotation of '\(string1)'"
        }
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func characterState(at index: Int, forConcatenated: Bool = false) -> CharacterState {
        if forConcatenated {
            if matchedIndices.contains(index) {
                return .matched
            } else if isChecking && currentIndex >= 0 && index >= currentIndex && index < currentIndex + string2.count {
                if index == currentIndex && isMatching {
                    return .current
                }
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
