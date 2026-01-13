//
//  SelectionSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class SelectionSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var currentIndex: Int? = nil
    @Published var minIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "64,25,12,22,11"
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
    private var i: Int = 0
    private var j: Int = 0
    private var currentMinIndex: Int = 0
    private let autoRunDelay: Double = 0.5 // seconds between steps
    
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [64, 25, 12, 22, 11]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 64,25,12,22)"
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
            sortedIndices.removeAll()
            currentIndex = nil
            minIndex = nil
            currentStep = 0
            i = 0
            j = 1
            currentMinIndex = 0
            currentPass = 1
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
        
        // Set initial state
        currentIndex = 0
        minIndex = 0
        comparisonResult = "Starting pass 1: finding minimum from position 0"
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
            sortedIndices.removeAll()
            currentIndex = nil
            minIndex = nil
            currentStep = 0
            i = 0
            j = 1
            currentMinIndex = 0
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
            await performSelectionSort()
            
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
            currentIndex = nil
            minIndex = nil
            sortedIndices.removeAll()
            currentStep = 0
            i = 0
            j = 0
            currentMinIndex = 0
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
        
        // Check if we're starting a new pass
        if j >= n {
            // Swap and mark as sorted
            if currentMinIndex != i {
                withAnimation(.easeInOut(duration: 0.3)) {
                    array.swapAt(i, currentMinIndex)
                    comparisonResult = "⚡ Swapping \(array[currentMinIndex]) at position \(currentMinIndex) with position \(i)"
                }
            } else {
                comparisonResult = "✓ Element \(array[i]) is already in correct position"
            }
            
            sortedIndices.insert(i)
            i += 1
            
            if i >= n - 1 {
                // Sorting complete
                sortedIndices.insert(n - 1)
                completeSort()
                return
            }
            
            // Start new pass
            j = i + 1
            currentMinIndex = i
            currentPass = i + 1
            currentIndex = i
            minIndex = i
            comparisonResult = "Starting pass \(currentPass): finding minimum from position \(i)"
            return
        }
        
        // Compare current element with minimum
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = i
            
            if array[j] < array[currentMinIndex] {
                currentMinIndex = j
                minIndex = j
                comparisonResult = "🔍 \(array[j]) < \(array[currentMinIndex]), new minimum found at position \(j)"
            } else {
                comparisonResult = "✓ \(array[j]) ≥ \(array[currentMinIndex]), minimum remains at position \(currentMinIndex)"
            }
            
            currentStep += 1
            j += 1
        }
    }
    
    private func performSelectionSort() async {
        let n = array.count
        
        for pass in 0..<n-1 {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                currentPass = pass + 1
                currentIndex = pass
                minIndex = pass
                currentMinIndex = pass
                comparisonResult = "Starting pass \(currentPass): finding minimum from position \(pass)"
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
            
            // Find minimum element in unsorted portion
            for step in (pass + 1)..<n {
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    if array[step] < array[currentMinIndex] {
                        currentMinIndex = step
                        minIndex = step
                        comparisonResult = "🔍 \(array[step]) < \(array[currentMinIndex]), new minimum found at position \(step)"
                    } else {
                        comparisonResult = "✓ \(array[step]) ≥ \(array[currentMinIndex]), minimum remains at position \(currentMinIndex)"
                    }
                    currentStep += 1
                }
                
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
            }
            
            // Swap if needed
            await MainActor.run {
                if currentMinIndex != pass {
                    array.swapAt(pass, currentMinIndex)
                    comparisonResult = "⚡ Swapping \(array[currentMinIndex]) at position \(currentMinIndex) with position \(pass)"
                } else {
                    comparisonResult = "✓ Element \(array[pass]) is already in correct position"
                }
                sortedIndices.insert(pass)
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
        }
        
        await MainActor.run {
            sortedIndices.insert(n - 1)
            completeSort()
        }
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        currentIndex = nil
        minIndex = nil
        comparisonResult = ""
        finalResult = "✓ Array sorted successfully in \(currentStep) comparisons!"
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if sortedIndices.contains(index) {
            return .sorted
        } else if index == minIndex {
            return .minimum
        } else if index == currentIndex {
            return .current
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    enum ElementState {
        case unchecked
        case active
        case current
        case minimum
        case sorted
    }
}
