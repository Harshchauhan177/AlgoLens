//
//  ExponentialSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI
import Combine

@MainActor
class ExponentialSearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [1, 2, 3, 4, 5, 7, 9, 11, 13, 15, 17, 19]
    @Published var target: Int = 11
    @Published var currentIndex: Int = -1
    @Published var boundStart: Int = -1
    @Published var boundEnd: Int = -1
    @Published var lowPointer: Int = -1
    @Published var midPointer: Int = -1
    @Published var highPointer: Int = -1
    @Published var foundIndex: Int? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isExponentialPhase: Bool = true
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "1,2,3,4,5,7,9,11,13,15,17,19"
    @Published var targetInput: String = "11"
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
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [1, 2, 3, 4, 5, 7, 9, 11, 13, 15, 17, 19]
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
        
        guard let targetValue = Int(targetInput.trimmingCharacters(in: .whitespaces)) else {
            inputError = "Invalid target value. Enter a valid integer"
            return
        }
        
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
            isExponentialPhase = true
            currentIndex = 0
            boundStart = -1
            boundEnd = -1
            lowPointer = -1
            midPointer = -1
            highPointer = -1
            foundIndex = nil
            isCompleted = false
            
            currentPhase = "Exponential Phase"
            stepDescription = "Checking if first element matches target"
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
            isExponentialPhase = true
            isAutoRunning = true
            currentIndex = 0
            boundStart = -1
            boundEnd = -1
            lowPointer = -1
            midPointer = -1
            highPointer = -1
            foundIndex = nil
            isCompleted = false
            
            currentPhase = "Exponential Phase"
            stepDescription = "Checking if first element matches target"
            comparisonResult = ""
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
            currentIndex = -1
            boundStart = -1
            boundEnd = -1
            lowPointer = -1
            midPointer = -1
            highPointer = -1
            foundIndex = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            isExponentialPhase = true
            
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
            if isExponentialPhase {
                performExponentialStep()
            } else {
                performBinarySearchStep()
            }
        }
    }
    
    private func performExponentialStep() {
        // Check first element
        if currentIndex == 0 {
            if array[0] == target {
                foundIndex = 0
                isCompleted = true
                canNext = false
                comparisonResult = "✓ Target found at index 0!"
                finalResult = "Success! Target \(target) found at index 0"
                if !isAutoRunning {
                    canReset = true
                }
                return
            } else {
                comparisonResult = "\(array[0]) ≠ \(target), start exponential jumps"
                currentIndex = 1
                stepDescription = "Starting exponential doubling from index 1"
                return
            }
        }
        
        // Exponential doubling
        guard currentIndex < array.count else {
            // Reached end, set range and switch to binary search
            boundStart = currentIndex / 2
            boundEnd = array.count - 1
            switchToBinarySearch()
            return
        }
        
        let currentValue = array[currentIndex]
        
        if currentValue == target {
            foundIndex = currentIndex
            isCompleted = true
            canNext = false
            comparisonResult = "✓ Target found at index \(currentIndex)!"
            finalResult = "Success! Target \(target) found at index \(currentIndex)"
            if !isAutoRunning {
                canReset = true
            }
        } else if currentValue < target {
            comparisonResult = "\(currentValue) < \(target), double index"
            stepDescription = "Doubling: \(currentIndex) → \(currentIndex * 2)"
            currentIndex = currentIndex * 2
        } else {
            // Found range, switch to binary search
            boundStart = currentIndex / 2
            boundEnd = min(currentIndex, array.count - 1)
            switchToBinarySearch()
        }
    }
    
    private func switchToBinarySearch() {
        isExponentialPhase = false
        currentPhase = "Binary Search Phase"
        lowPointer = boundStart
        highPointer = boundEnd
        midPointer = (lowPointer + highPointer) / 2
        comparisonResult = "Range found: [\(boundStart), \(boundEnd)]"
        stepDescription = "Performing binary search in identified range"
    }
    
    private func performBinarySearchStep() {
        guard lowPointer <= highPointer else {
            completeSearchNotFound()
            return
        }
        
        let midValue = array[midPointer]
        
        if midValue == target {
            foundIndex = midPointer
            isCompleted = true
            canNext = false
            comparisonResult = "✓ Match found!"
            finalResult = "Success! Target \(target) found at index \(midPointer)"
            if !isAutoRunning {
                canReset = true
            }
        } else if midValue < target {
            comparisonResult = "\(midValue) < \(target), search right half"
            lowPointer = midPointer + 1
            
            if lowPointer > highPointer {
                completeSearchNotFound()
            } else {
                midPointer = (lowPointer + highPointer) / 2
            }
        } else {
            comparisonResult = "\(midValue) > \(target), search left half"
            highPointer = midPointer - 1
            
            if lowPointer > highPointer {
                completeSearchNotFound()
            } else {
                midPointer = (lowPointer + highPointer) / 2
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
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if let found = foundIndex, found == index {
            return .found
        } else if isExponentialPhase && currentIndex == index {
            return .current
        } else if !isExponentialPhase {
            // Binary search phase
            if midPointer == index {
                return .current
            } else if boundStart >= 0 && boundEnd >= 0 {
                if index >= lowPointer && index <= highPointer {
                    return .inRange
                } else if index >= boundStart && index <= boundEnd {
                    return .checked
                }
            }
        } else if isExponentialPhase && index > 0 && index < currentIndex {
            return .jumped
        }
        
        return .unchecked
    }
    
    func isExponentialPoint(at index: Int) -> Bool {
        guard isSearching else { return false }
        
        if index == 0 {
            return true
        }
        
        // Check if index is power of 2
        return index > 0 && (index & (index - 1)) == 0
    }
    
    func pointerLabel(at index: Int) -> String? {
        guard !isExponentialPhase && isSearching else { return nil }
        
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
        case unchecked  // Not yet visited
        case current    // Currently examining
        case jumped     // Already jumped over (exponential phase)
        case inRange    // In active binary search range
        case checked    // Outside binary search range
        case found      // Target found
    }
}
