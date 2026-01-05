//
//  LinearSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI
import Combine

@MainActor
class LinearSearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [4, 7, 1, 9, 3, 6]
    @Published var target: Int = 9
    @Published var currentIndex: Int = -1
    @Published var foundIndex: Int? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "4,7,1,9,3,6"
    @Published var targetInput: String = "9"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var currentValue: Int?
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8 // seconds between steps
    
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
            array = [4, 7, 1, 9, 3, 6] // Default
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 4,7,1,9)"
                return
            }
            parsedArray.append(number)
        }
        
        guard parsedArray.count > 0 else {
            inputError = "Array cannot be empty"
            return
        }
        
        guard parsedArray.count <= 10 else {
            inputError = "Array too large. Maximum 10 elements"
            return
        }
        
        // Parse target input
        guard let targetValue = Int(targetInput.trimmingCharacters(in: .whitespaces)) else {
            inputError = "Invalid target value. Enter a valid integer"
            return
        }
        
        // Update if valid
        array = parsedArray
        target = targetValue
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            currentIndex = 0
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
            
            updateCurrentValue()
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
            isAutoRunning = true
            currentIndex = 0
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
            
            updateCurrentValue()
        }
        
        // Run auto-search
        autoRunTask = Task {
            while currentIndex < array.count && !isCompleted {
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
        // Cancel auto-run if active
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = -1
            foundIndex = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            currentValue = nil
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
        guard currentIndex < array.count else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            let currentElement = array[currentIndex]
            
            // Check if current element matches target
            if currentElement == target {
                // Target found!
                foundIndex = currentIndex
                isCompleted = true
                canNext = false
                comparisonResult = "✓ Match found!"
                finalResult = "Success! Target \(target) found at index \(currentIndex)"
                
                if !isAutoRunning {
                    canReset = true
                }
            } else {
                // Element does not match
                comparisonResult = "✗ \(currentElement) ≠ \(target), continue searching"
                
                // Move to next index
                currentIndex += 1
                
                if currentIndex >= array.count {
                    // Search completed without finding
                    isCompleted = true
                    canNext = false
                    currentValue = nil
                    comparisonResult = ""
                    finalResult = "Target \(target) not found in the array"
                    
                    if !isAutoRunning {
                        canReset = true
                    }
                } else {
                    // Continue to next element
                    updateCurrentValue()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func updateCurrentValue() {
        if currentIndex >= 0 && currentIndex < array.count {
            currentValue = array[currentIndex]
        } else {
            currentValue = nil
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if let found = foundIndex, found == index {
            return .found
        } else if currentIndex == index && isSearching {
            return .current
        } else if currentIndex > index && isSearching {
            return .checked
        } else {
            return .unchecked
        }
    }
    
    enum ElementState {
        case unchecked
        case current
        case checked
        case found
    }
}
