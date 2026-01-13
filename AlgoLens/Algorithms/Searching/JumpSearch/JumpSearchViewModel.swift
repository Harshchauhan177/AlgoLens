//
//  JumpSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI
import Combine

@MainActor
class JumpSearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
    @Published var target: Int = 13
    @Published var currentIndex: Int = -1
    @Published var previousJump: Int = -1
    @Published var jumpStep: Int = 0
    @Published var linearSearchStart: Int = -1
    @Published var foundIndex: Int? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isJumpingPhase: Bool = true
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "1,3,5,7,9,11,13,15,17,19"
    @Published var targetInput: String = "13"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var currentPhase: String = ""
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var stepDescription: String = ""
    
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
        
        // Parse array input
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers"
                return
            }
            parsedArray.append(number)
        }
        
        guard parsedArray.count > 0 else {
            inputError = "Array cannot be empty"
            return
        }
        
        guard parsedArray.count <= 12 else {
            inputError = "Array too large. Maximum 12 elements"
            return
        }
        
        // Parse target input
        guard let targetValue = Int(targetInput.trimmingCharacters(in: .whitespaces)) else {
            inputError = "Invalid target value. Enter a valid integer"
            return
        }
        
        // Sort the array for Jump Search
        array = parsedArray.sorted()
        target = targetValue
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            let n = array.count
            jumpStep = Int(sqrt(Double(n)))
            currentIndex = min(jumpStep - 1, n - 1)
            previousJump = 0
            linearSearchStart = -1
            foundIndex = nil
            isCompleted = false
            isJumpingPhase = true
            
            currentPhase = "Jumping Phase"
            stepDescription = "Jump size: √\(n) = \(jumpStep)"
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
        
        // Start the search
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            let n = array.count
            jumpStep = Int(sqrt(Double(n)))
            currentIndex = min(jumpStep - 1, n - 1)
            previousJump = 0
            linearSearchStart = -1
            foundIndex = nil
            isCompleted = false
            isJumpingPhase = true
            isAutoRunning = true
            
            currentPhase = "Jumping Phase"
            stepDescription = "Jump size: √\(n) = \(jumpStep)"
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        // Run auto-search
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
            currentIndex = -1
            previousJump = -1
            jumpStep = 0
            linearSearchStart = -1
            foundIndex = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            isJumpingPhase = true
            
            currentPhase = ""
            comparisonResult = ""
            finalResult = ""
            stepDescription = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isJumpingPhase {
                performJumpStep()
            } else {
                performLinearSearchStep()
            }
        }
    }
    
    private func performJumpStep() {
        guard currentIndex < array.count else {
            completeSearchNotFound()
            return
        }
        
        let currentValue = array[currentIndex]
        
        if currentValue == target {
            // Found during jumping phase
            foundIndex = currentIndex
            isCompleted = true
            canNext = false
            comparisonResult = "✓ Target found at index \(currentIndex)!"
            finalResult = "Success! Target \(target) found at index \(currentIndex)"
            if !isAutoRunning {
                canReset = true
            }
        } else if currentValue < target {
            // Jump forward
            comparisonResult = "\(currentValue) < \(target), jump forward"
            previousJump = currentIndex
            currentIndex = min(currentIndex + jumpStep, array.count - 1)
            
            if currentIndex >= array.count - 1 && array[currentIndex] < target {
                // Reached end and still less than target
                completeSearchNotFound()
            }
        } else {
            // Found the block, switch to linear search
            comparisonResult = "\(currentValue) > \(target), switch to linear search"
            linearSearchStart = previousJump + 1
            currentIndex = linearSearchStart
            isJumpingPhase = false
            currentPhase = "Linear Search Phase"
            stepDescription = "Searching block from index \(linearSearchStart)"
        }
    }
    
    private func performLinearSearchStep() {
        let blockEnd = min(previousJump + jumpStep, array.count - 1)
        
        guard currentIndex <= blockEnd else {
            completeSearchNotFound()
            return
        }
        
        let currentValue = array[currentIndex]
        
        if currentValue == target {
            // Found in linear search phase
            foundIndex = currentIndex
            isCompleted = true
            canNext = false
            comparisonResult = "✓ Target found at index \(currentIndex)!"
            finalResult = "Success! Target \(target) found at index \(currentIndex)"
            if !isAutoRunning {
                canReset = true
            }
        } else if currentValue < target {
            // Continue linear search
            comparisonResult = "\(currentValue) < \(target), check next"
            currentIndex += 1
            
            if currentIndex > blockEnd {
                completeSearchNotFound()
            }
        } else {
            // Value is greater, target not in array
            completeSearchNotFound()
        }
    }
    
    // MARK: - Helper Methods
    private func completeSearchNotFound() {
        isCompleted = true
        canNext = false
        comparisonResult = ""
        finalResult = "Target \(target) not found in the array"
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if let found = foundIndex, found == index {
            return .found
        } else if currentIndex == index && isSearching {
            return .current
        } else if isSearching && !isJumpingPhase && linearSearchStart >= 0 {
            let blockEnd = min(previousJump + jumpStep, array.count - 1)
            if index >= linearSearchStart && index <= blockEnd && index < currentIndex {
                return .checked
            } else if index >= linearSearchStart && index <= blockEnd {
                return .inBlock
            }
        } else if isSearching && isJumpingPhase {
            if index <= previousJump {
                return .jumped
            }
        }
        
        return .unchecked
    }
    
    func isJumpPoint(at index: Int) -> Bool {
        guard isSearching else { return false }
        
        if index == 0 {
            return true
        }
        
        let n = array.count
        let step = Int(sqrt(Double(n)))
        
        return (index + 1) % step == 0 || index == n - 1
    }
    
    enum ElementState {
        case unchecked  // Not yet visited
        case current    // Currently examining
        case jumped     // Already jumped over
        case inBlock    // In the block being linearly searched
        case checked    // Checked in linear search
        case found      // Target found
    }
}
