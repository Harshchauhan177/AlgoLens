//
//  InsertionSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class InsertionSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var keyIndex: Int? = nil
    @Published var comparingIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "12,11,13,5,6"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var currentPass: Int = 0
    @Published var totalPasses: Int = 0
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Private State
    private var animationTask: Task<Void, Never>?
    private var i: Int = 1
    private var j: Int = 0
    private var key: Int = 0
    private let autoRunDelay: Double = 0.5 // seconds between steps
    
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [12, 11, 13, 5, 6]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 12,11,13,5)"
                return
            }
            parsedArray.append(number)
        }
        
        guard parsedArray.count > 0 else {
            inputError = "Array cannot be empty"
            return
        }
        
        guard parsedArray.count <= 15 else {
            inputError = "Array too large. Maximum 15 elements"
            return
        }
        
        array = parsedArray
        totalPasses = max(0, array.count - 1)
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnimating = true
            sortedIndices = [0]
            keyIndex = nil
            comparingIndex = nil
            currentStep = 0
            i = 1
            j = 0
            key = 0
            currentPass = 1
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
        
        if array.count > 0 {
            comparisonResult = "Starting pass 1: inserting element at position 1"
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
            isAnimating = true
            isAutoRunning = true
            sortedIndices = [0]
            keyIndex = nil
            comparingIndex = nil
            currentStep = 0
            i = 1
            j = 0
            key = 0
            currentPass = 1
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        animationTask = Task {
            await performInsertionSort()
            
            await MainActor.run {
                isAutoRunning = false
                isAnimating = false
                canReset = true
            }
        }
    }
    
    func reset() {
        animationTask?.cancel()
        animationTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            keyIndex = nil
            comparingIndex = nil
            sortedIndices.removeAll()
            currentStep = 0
            i = 1
            j = 0
            key = 0
            currentPass = 0
            isAnimating = false
            isCompleted = false
            isAutoRunning = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
            
            updateFromInputs()
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        let n = array.count
        
        // Check if we need to start a new pass
        if i < n && j < 0 {
            // Place the key in its correct position
            withAnimation(.easeInOut(duration: 0.3)) {
                array[j + 1] = key
                sortedIndices.insert(i)
                keyIndex = nil
                comparingIndex = nil
                comparisonResult = "✓ Inserted \(key) at position \(j + 1)"
            }
            
            i += 1
            
            if i >= n {
                // Sorting complete
                completeSort()
                return
            }
            
            // Start new pass
            key = array[i]
            j = i - 1
            currentPass = i
            keyIndex = i
            comparisonResult = "Starting pass \(currentPass): inserting element \(key) from position \(i)"
            return
        }
        
        if i >= n {
            completeSort()
            return
        }
        
        // First step of a pass - save the key
        if j == 0 && keyIndex == nil {
            key = array[i]
            j = i - 1
            keyIndex = i
            comparisonResult = "🔑 Key = \(key) at position \(i)"
            return
        }
        
        // Perform comparison and shift if needed
        if j >= 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                comparingIndex = j
                
                if array[j] > key {
                    array[j + 1] = array[j]
                    comparisonResult = "⚡ \(array[j]) > \(key), shifting right"
                    j -= 1
                } else {
                    // Found the correct position
                    array[j + 1] = key
                    sortedIndices.insert(i)
                    keyIndex = nil
                    comparingIndex = nil
                    comparisonResult = "✓ \(array[j]) ≤ \(key), inserted \(key) at position \(j + 1)"
                    
                    i += 1
                    
                    if i >= n {
                        completeSort()
                        return
                    }
                    
                    // Start new pass
                    key = array[i]
                    j = i - 1
                    currentPass = i
                    keyIndex = i
                }
                
                currentStep += 1
            }
        } else {
            // Reached beginning of array
            withAnimation(.easeInOut(duration: 0.3)) {
                array[0] = key
                sortedIndices.insert(i)
                keyIndex = nil
                comparingIndex = nil
                comparisonResult = "✓ Inserted \(key) at position 0"
            }
            
            i += 1
            
            if i >= n {
                completeSort()
                return
            }
            
            // Start new pass
            key = array[i]
            j = i - 1
            currentPass = i
            keyIndex = i
            comparisonResult = "Starting pass \(currentPass): inserting element \(key) from position \(i)"
        }
    }
    
    private func performInsertionSort() async {
        let n = array.count
        
        for pass in 1..<n {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                currentPass = pass
                keyIndex = pass
                key = array[pass]
                comparisonResult = "🔑 Key = \(key) at position \(pass)"
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
            
            var j = pass - 1
            
            while j >= 0 {
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    comparingIndex = j
                }
                
                let shouldShift = array[j] > key
                
                await MainActor.run {
                    if shouldShift {
                        comparisonResult = "⚡ \(array[j]) > \(key), shifting right"
                    } else {
                        comparisonResult = "✓ \(array[j]) ≤ \(key), position found"
                    }
                }
                
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                
                if !shouldShift {
                    break
                }
                
                await MainActor.run {
                    array[j + 1] = array[j]
                    currentStep += 1
                }
                
                j -= 1
                
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 0.3 * 1_000_000_000))
            }
            
            await MainActor.run {
                array[j + 1] = key
                sortedIndices.insert(pass)
                comparingIndex = nil
                comparisonResult = "✓ Inserted \(key) at position \(j + 1)"
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
        }
        
        await MainActor.run {
            completeSort()
        }
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        keyIndex = nil
        comparingIndex = nil
        comparisonResult = ""
        finalResult = "✓ Array sorted successfully in \(currentStep) operations!"
        
        // Mark all as sorted
        for index in 0..<array.count {
            sortedIndices.insert(index)
        }
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if sortedIndices.contains(index) {
            return .sorted
        } else if index == keyIndex {
            return .key
        } else if index == comparingIndex {
            return .comparing
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    enum ElementState {
        case unchecked
        case active
        case key
        case comparing
        case sorted
    }
}
