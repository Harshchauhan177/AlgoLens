//
//  InterpolationSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI
import Combine

@MainActor
class InterpolationSearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [2, 5, 10, 15, 20, 25, 30, 35, 40, 45]
    @Published var target: Int = 25
    @Published var lowPointer: Int = -1
    @Published var posPointer: Int = -1
    @Published var highPointer: Int = -1
    @Published var foundIndex: Int? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "2,5,10,15,20,25,30,35,40"
    @Published var targetInput: String = "25"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var lowValue: Int?
    @Published var posValue: Int?
    @Published var highValue: Int?
    @Published var interpolationFormula: String = ""
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 1.0 // seconds between steps
    
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
            array = [2, 5, 10, 15, 20, 25, 30, 35, 40, 45] // Default
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 10,20,30,40)"
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
        
        // IMPORTANT: Sort the array for Interpolation Search
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
            posPointer = -1
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            interpolationFormula = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
            
            updateCurrentValues()
            calculateInterpolationPosition()
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
            posPointer = -1
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            interpolationFormula = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
            
            updateCurrentValues()
            calculateInterpolationPosition()
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
            posPointer = -1
            highPointer = -1
            foundIndex = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            lowValue = nil
            posValue = nil
            highValue = nil
            comparisonResult = ""
            finalResult = ""
            interpolationFormula = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard lowPointer <= highPointer else {
            completeSearchNotFound()
            return
        }
        
        // Check if target is within bounds
        guard target >= array[lowPointer] && target <= array[highPointer] else {
            completeSearchNotFound()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            let posValue = array[posPointer]
            
            // Check if pos element matches target
            if posValue == target {
                // Target found!
                foundIndex = posPointer
                isCompleted = true
                canNext = false
                comparisonResult = "✓ Match found!"
                finalResult = "Success! Target \(target) found at index \(posPointer)"
                
                if !isAutoRunning {
                    canReset = true
                }
            } else if posValue < target {
                // Target is in right portion
                comparisonResult = "✗ \(posValue) < \(target), search right portion"
                
                // Move low pointer to pos + 1
                lowPointer = posPointer + 1
                
                if lowPointer > highPointer || target < array[lowPointer] || target > array[highPointer] {
                    completeSearchNotFound()
                } else {
                    calculateInterpolationPosition()
                    updateCurrentValues()
                }
            } else {
                // Target is in left portion
                comparisonResult = "✗ \(posValue) > \(target), search left portion"
                
                // Move high pointer to pos - 1
                highPointer = posPointer - 1
                
                if lowPointer > highPointer || target < array[lowPointer] || target > array[highPointer] {
                    completeSearchNotFound()
                } else {
                    calculateInterpolationPosition()
                    updateCurrentValues()
                }
            }
        }
    }
    
    // MARK: - Interpolation Calculation
    private func calculateInterpolationPosition() {
        guard lowPointer >= 0 && highPointer < array.count && lowPointer <= highPointer else {
            return
        }
        
        let lowVal = array[lowPointer]
        let highVal = array[highPointer]
        
        // Avoid division by zero
        guard highVal != lowVal else {
            posPointer = lowPointer
            interpolationFormula = "pos = \(lowPointer) (single element)"
            return
        }
        
        // Interpolation formula: pos = low + ((target - arr[low]) * (high - low)) / (arr[high] - arr[low])
        let numerator = (target - lowVal) * (highPointer - lowPointer)
        let denominator = highVal - lowVal
        let calculatedPos = lowPointer + (numerator / denominator)
        
        // Clamp position to valid range
        posPointer = max(lowPointer, min(calculatedPos, highPointer))
        
        interpolationFormula = "pos = \(lowPointer) + ((\(target) - \(lowVal)) × (\(highPointer) - \(lowPointer))) / (\(highVal) - \(lowVal)) = \(posPointer)"
    }
    
    // MARK: - Helper Methods
    private func completeSearchNotFound() {
        isCompleted = true
        canNext = false
        comparisonResult = ""
        finalResult = "Target \(target) not found in the array"
        interpolationFormula = ""
        
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
        
        if posPointer >= 0 && posPointer < array.count {
            posValue = array[posPointer]
        } else {
            posValue = nil
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
        } else if posPointer == index && isSearching {
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
        if posPointer == index {
            labels.append("P")
        }
        if highPointer == index {
            labels.append("H")
        }
        
        return labels.isEmpty ? nil : labels.joined(separator: " ")
    }
    
    enum ElementState {
        case unchecked  // Not yet in search
        case current    // Current pos element
        case inRange    // In active search range
        case checked    // Outside search range (eliminated)
        case found      // Target found
    }
}
