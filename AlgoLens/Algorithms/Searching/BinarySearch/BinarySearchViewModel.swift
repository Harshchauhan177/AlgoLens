//
//  BinarySearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 06/01/26.
//

import SwiftUI
import Combine

@MainActor
class BinarySearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [2, 5, 8, 12, 16, 23, 38, 45, 56, 67]
    @Published var target: Int = 23
    @Published var lowPointer: Int = -1
    @Published var midPointer: Int = -1
    @Published var highPointer: Int = -1
    @Published var foundIndex: Int? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "3,5,7,9,15,18,22"
    @Published var targetInput: String = "18"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var lowValue: Int?
    @Published var midValue: Int?
    @Published var highValue: Int?
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8 // seconds between steps (same as Linear Search)
    
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
            array = [2, 5, 8, 12, 16, 23, 38, 45, 56, 67] // Default
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 15,3,9,22)"
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
        
        // IMPORTANT: Sort the array for Binary Search
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
            lowPointer = 0
            highPointer = array.count - 1
            midPointer = (lowPointer + highPointer) / 2
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
            
            updateCurrentValues()
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
            lowPointer = 0
            highPointer = array.count - 1
            midPointer = (lowPointer + highPointer) / 2
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
            
            updateCurrentValues()
        }
        
        // Run auto-search
        autoRunTask = Task {
            while lowPointer <= highPointer && !isCompleted {
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
            lowPointer = -1
            midPointer = -1
            highPointer = -1
            foundIndex = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            lowValue = nil
            midValue = nil
            highValue = nil
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
        guard lowPointer <= highPointer else {
            // Search space exhausted
            completeSearchNotFound()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            let midValue = array[midPointer]
            
            // Check if mid element matches target
            if midValue == target {
                // Target found!
                foundIndex = midPointer
                isCompleted = true
                canNext = false
                comparisonResult = "✓ Match found!"
                finalResult = "Success! Target \(target) found at index \(midPointer)"
                
                if !isAutoRunning {
                    canReset = true
                }
            } else if midValue < target {
                // Target is in right half
                comparisonResult = "✗ \(midValue) < \(target), search right half"
                
                // Move low pointer to mid + 1
                lowPointer = midPointer + 1
                
                if lowPointer > highPointer {
                    completeSearchNotFound()
                } else {
                    midPointer = (lowPointer + highPointer) / 2
                    updateCurrentValues()
                }
            } else {
                // Target is in left half
                comparisonResult = "✗ \(midValue) > \(target), search left half"
                
                // Move high pointer to mid - 1
                highPointer = midPointer - 1
                
                if lowPointer > highPointer {
                    completeSearchNotFound()
                } else {
                    midPointer = (lowPointer + highPointer) / 2
                    updateCurrentValues()
                }
            }
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
    
    private func updateCurrentValues() {
        if lowPointer >= 0 && lowPointer < array.count {
            lowValue = array[lowPointer]
        } else {
            lowValue = nil
        }
        
        if midPointer >= 0 && midPointer < array.count {
            midValue = array[midPointer]
        } else {
            midValue = nil
        }
        
        if highPointer >= 0 && highPointer < array.count {
            highValue = array[highPointer]
        } else {
            highValue = nil
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if let found = foundIndex, found == index {
            return .found
        } else if midPointer == index && isSearching {
            return .current
        } else if isSearching && lowPointer >= 0 && highPointer >= 0 {
            if index >= lowPointer && index <= highPointer {
                return .inRange
            } else {
                return .checked
            }
        } else {
            return .unchecked
        }
    }
    
    func pointerLabel(at index: Int) -> String? {
        guard isSearching else { return nil }
        
        var labels: [String] = []
        
        if lowPointer == index {
            labels.append("L")
        }
        if midPointer == index {
            labels.append("M")
        }
        if highPointer == index {
            labels.append("H")
        }
        
        return labels.isEmpty ? nil : labels.joined(separator: " ")
    }
    
    enum ElementState {
        case unchecked  // Not yet in search
        case current    // Current mid element
        case inRange    // In active search range
        case checked    // Outside search range (eliminated)
        case found      // Target found
    }
}
