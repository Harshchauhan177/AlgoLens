//
//  SubarraySumViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class SubarraySumViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [1, 2, 3, 7, 5]
    @Published var targetSum: Int = 12
    @Published var currentIndex: Int = -1
    @Published var foundStart: Int = -1
    @Published var foundEnd: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "1,2,3,7,5"
    @Published var targetInput: String = "12"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var currentSum: Int = 0
    @Published var prefixSums: [Int: Int] = [:]
    @Published var stepInfo: String = ""
    @Published var currentAction: String = ""
    
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
            array = [1, 2, 3, 7, 5]
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
        
        guard parsedArray.count >= 2 else {
            inputError = "Array must have at least 2 elements"
            return
        }
        
        guard parsedArray.count <= 15 else {
            inputError = "Array too large. Maximum 15 elements"
            return
        }
        
        guard let targetValue = Int(targetInput.trimmingCharacters(in: .whitespaces)) else {
            inputError = "Invalid target value"
            return
        }
        
        array = parsedArray
        targetSum = targetValue
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isRunning = true
            currentIndex = 0
            currentSum = 0
            prefixSums = [0: -1]
            foundStart = -1
            foundEnd = -1
            isCompleted = false
            stepInfo = "Starting subarray sum search"
            currentAction = "Initialize: prefix_sums[0] = -1"
            
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
            isRunning = true
            isAutoRunning = true
            currentIndex = 0
            currentSum = 0
            prefixSums = [0: -1]
            foundStart = -1
            foundEnd = -1
            isCompleted = false
            stepInfo = "Running complete search"
            currentAction = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
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
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = -1
            currentSum = 0
            prefixSums = [:]
            foundStart = -1
            foundEnd = -1
            isRunning = false
            isCompleted = false
            isAutoRunning = false
            stepInfo = ""
            currentAction = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard currentIndex < array.count else {
            completeSearchNotFound()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentSum += array[currentIndex]
            let difference = currentSum - targetSum
            
            currentAction = "Index \(currentIndex): sum += \(array[currentIndex]) = \(currentSum)"
            
            if let startIndex = prefixSums[difference] {
                foundStart = startIndex + 1
                foundEnd = currentIndex
                isCompleted = true
                canNext = false
                
                let subarrayValues = array[foundStart...foundEnd].map { String($0) }.joined(separator: ", ")
                stepInfo = "✓ Subarray found!"
                currentAction = "Found: [\(subarrayValues)] from index \(foundStart) to \(foundEnd)"
                
                if !isAutoRunning {
                    canReset = true
                }
            } else {
                prefixSums[currentSum] = currentIndex
                stepInfo = "Checking difference: \(currentSum) - \(targetSum) = \(difference)"
                currentAction += " → Store prefix_sums[\(currentSum)] = \(currentIndex)"
                
                currentIndex += 1
                
                if currentIndex >= array.count {
                    completeSearchNotFound()
                }
            }
        }
    }
    
    private func completeSearchNotFound() {
        isCompleted = true
        canNext = false
        stepInfo = "Search complete"
        currentAction = "No subarray found with sum \(targetSum)"
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if !isRunning {
            return .unchecked
        }
        
        if foundStart != -1 && index >= foundStart && index <= foundEnd {
            return .found
        } else if index == currentIndex {
            return .current
        } else if index < currentIndex {
            return .checked
        }
        
        return .unchecked
    }
    
    func showPointer(at index: Int) -> Bool {
        return isRunning && !isCompleted && index == currentIndex
    }
    
    enum ElementState {
        case unchecked
        case current
        case checked
        case found
    }
}
