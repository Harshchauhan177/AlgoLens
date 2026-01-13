//
//  BubbleSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class BubbleSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var comparingIndices: (Int, Int)? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "64,34,25,12,22,11,90"
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
    private let autoRunDelay: Double = 0.5 // seconds between steps
    
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [64, 34, 25, 12, 22, 11, 90]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 64,34,25,12)"
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
            comparingIndices = nil
            currentStep = 0
            i = 0
            j = 0
            currentPass = 1
            isCompleted = false
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
            isAnimating = true
            isAutoRunning = true
            sortedIndices.removeAll()
            comparingIndices = nil
            currentStep = 0
            i = 0
            j = 0
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
            await performBubbleSort()
            
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
            comparingIndices = nil
            sortedIndices.removeAll()
            currentStep = 0
            i = 0
            j = 0
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
        
        // Check if current pass is complete
        if j >= n - i - 1 {
            sortedIndices.insert(n - i - 1)
            i += 1
            j = 0
            currentPass = i + 1
            
            if i >= n - 1 {
                // Sorting complete
                sortedIndices.insert(0)
                completeSort()
                return
            }
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            comparingIndices = (j, j + 1)
            
            if array[j] > array[j + 1] {
                comparisonResult = "⚡ \(array[j]) > \(array[j + 1]), swapping"
                array.swapAt(j, j + 1)
            } else {
                comparisonResult = "✓ \(array[j]) ≤ \(array[j + 1]), no swap needed"
            }
            
            currentStep += 1
            j += 1
        }
    }
    
    private func performBubbleSort() async {
        let n = array.count
        
        for pass in 0..<n-1 {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                currentPass = pass + 1
            }
            
            for step in 0..<n-pass-1 {
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    comparingIndices = (step, step + 1)
                    
                    if array[step] > array[step + 1] {
                        comparisonResult = "⚡ \(array[step]) > \(array[step + 1]), swapping"
                    } else {
                        comparisonResult = "✓ \(array[step]) ≤ \(array[step + 1]), no swap needed"
                    }
                }
                
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                
                await MainActor.run {
                    if array[step] > array[step + 1] {
                        array.swapAt(step, step + 1)
                    }
                    currentStep += 1
                }
                
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 0.3 * 1_000_000_000))
            }
            
            await MainActor.run {
                sortedIndices.insert(n - pass - 1)
            }
        }
        
        await MainActor.run {
            sortedIndices.insert(0)
            completeSort()
        }
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        comparingIndices = nil
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
        } else if let (i, j) = comparingIndices, index == i || index == j {
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
        case comparing
        case sorted
    }
}
