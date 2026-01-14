//
//  CountingSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class CountingSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var countArray: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var currentIndex: Int? = nil
    @Published var countingIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "4,2,2,8,3,3,1"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var currentPass: Int = 0
    @Published var totalPasses: Int = 0
    @Published var currentPhase: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Private State
    private var animationTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.6
    private var steps: [CountingSortStep] = []
    private var currentStepIndex: Int = 0
    
    struct CountingSortStep {
        let array: [Int]
        let countArray: [Int]
        let currentIndex: Int?
        let countingIndex: Int?
        let sortedIndices: Set<Int>
        let description: String
        let phase: String
    }
    
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [4, 2, 2, 8, 3, 3, 1]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 4,2,2,8)"
                return
            }
            
            guard number >= 0 else {
                inputError = "Counting sort requires non-negative integers"
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
        
        if let max = parsedArray.max(), max > 20 {
            inputError = "Maximum value should be ≤ 20 for better visualization"
            return
        }
        
        array = parsedArray
        totalPasses = parsedArray.count * 3
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnimating = true
            sortedIndices.removeAll()
            countArray.removeAll()
            currentIndex = nil
            countingIndex = nil
            currentStep = 0
            currentStepIndex = 0
            currentPass = 1
            currentPhase = "Initializing"
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
        
        steps = generateCountingSortSteps(array)
        comparisonResult = "Starting Counting Sort - counting occurrences"
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
            countArray.removeAll()
            currentIndex = nil
            countingIndex = nil
            currentStep = 0
            currentStepIndex = 0
            currentPass = 1
            currentPhase = "Initializing"
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        steps = generateCountingSortSteps(array)
        
        animationTask = Task {
            await performCountingSort()
            
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
            countArray.removeAll()
            currentIndex = nil
            countingIndex = nil
            sortedIndices.removeAll()
            currentStep = 0
            currentStepIndex = 0
            currentPass = 0
            currentPhase = ""
            isAnimating = false
            isCompleted = false
            isAutoRunning = false
            comparisonResult = ""
            finalResult = ""
            steps.removeAll()
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
            
            updateFromInputs()
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard currentStepIndex < steps.count else {
            completeSort()
            return
        }
        
        let step = steps[currentStepIndex]
        
        withAnimation(.easeInOut(duration: 0.3)) {
            array = step.array
            countArray = step.countArray
            currentIndex = step.currentIndex
            countingIndex = step.countingIndex
            sortedIndices = step.sortedIndices
            comparisonResult = step.description
            currentPhase = step.phase
            currentPass = currentStepIndex + 1
            currentStep += 1
        }
        
        currentStepIndex += 1
        
        if currentStepIndex >= steps.count {
            completeSort()
        }
    }
    
    private func performCountingSort() async {
        for (index, step) in steps.enumerated() {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                array = step.array
                countArray = step.countArray
                currentIndex = step.currentIndex
                countingIndex = step.countingIndex
                sortedIndices = step.sortedIndices
                comparisonResult = step.description
                currentPhase = step.phase
                currentPass = index + 1
                currentStep += 1
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
        }
        
        await MainActor.run {
            completeSort()
        }
    }
    
    private func generateCountingSortSteps(_ arr: [Int]) -> [CountingSortStep] {
        var allSteps: [CountingSortStep] = []
        var workingArray = arr
        
        guard let max = arr.max() else { return allSteps }
        
        // Phase 1: Initialize count array
        var count = Array(repeating: 0, count: max + 1)
        
        allSteps.append(CountingSortStep(
            array: workingArray,
            countArray: count,
            currentIndex: nil,
            countingIndex: nil,
            sortedIndices: Set<Int>(),
            description: "📊 Phase 1: Initialize count array of size \(max + 1)",
            phase: "Initializing"
        ))
        
        // Phase 2: Count occurrences
        allSteps.append(CountingSortStep(
            array: workingArray,
            countArray: count,
            currentIndex: nil,
            countingIndex: nil,
            sortedIndices: Set<Int>(),
            description: "🔢 Phase 2: Counting occurrences of each element",
            phase: "Counting"
        ))
        
        for (index, num) in workingArray.enumerated() {
            allSteps.append(CountingSortStep(
                array: workingArray,
                countArray: count,
                currentIndex: index,
                countingIndex: num,
                sortedIndices: Set<Int>(),
                description: "⚡ Found \(num) at index \(index), incrementing count[\(num)]",
                phase: "Counting"
            ))
            
            count[num] += 1
            
            allSteps.append(CountingSortStep(
                array: workingArray,
                countArray: count,
                currentIndex: index,
                countingIndex: num,
                sortedIndices: Set<Int>(),
                description: "✓ count[\(num)] = \(count[num])",
                phase: "Counting"
            ))
        }
        
        // Phase 3: Cumulative count
        allSteps.append(CountingSortStep(
            array: workingArray,
            countArray: count,
            currentIndex: nil,
            countingIndex: nil,
            sortedIndices: Set<Int>(),
            description: "🔄 Phase 3: Computing cumulative counts",
            phase: "Cumulative"
        ))
        
        for i in 1...max {
            let oldValue = count[i]
            count[i] += count[i - 1]
            
            allSteps.append(CountingSortStep(
                array: workingArray,
                countArray: count,
                currentIndex: nil,
                countingIndex: i,
                sortedIndices: Set<Int>(),
                description: "⚡ count[\(i)] = \(oldValue) + count[\(i-1)] = \(count[i])",
                phase: "Cumulative"
            ))
        }
        
        // Phase 4: Build output array
        allSteps.append(CountingSortStep(
            array: workingArray,
            countArray: count,
            currentIndex: nil,
            countingIndex: nil,
            sortedIndices: Set<Int>(),
            description: "🏗️ Phase 4: Building sorted output array",
            phase: "Building Output"
        ))
        
        var output = Array(repeating: 0, count: workingArray.count)
        var currentSorted = Set<Int>()
        
        for i in stride(from: workingArray.count - 1, through: 0, by: -1) {
            let value = workingArray[i]
            let position = count[value] - 1
            
            allSteps.append(CountingSortStep(
                array: output,
                countArray: count,
                currentIndex: i,
                countingIndex: value,
                sortedIndices: currentSorted,
                description: "⚡ Element \(value) from position \(i) goes to position \(position)",
                phase: "Building Output"
            ))
            
            output[position] = value
            count[value] -= 1
            currentSorted.insert(position)
            
            allSteps.append(CountingSortStep(
                array: output,
                countArray: count,
                currentIndex: position,
                countingIndex: value,
                sortedIndices: currentSorted,
                description: "✓ Placed \(value) at position \(position)",
                phase: "Building Output"
            ))
        }
        
        return allSteps
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        currentIndex = nil
        countingIndex = nil
        comparisonResult = ""
        currentPhase = "Complete"
        finalResult = "✓ Array sorted successfully using Counting Sort in \(currentStep) operations!"
        
        sortedIndices = Set(0..<array.count)
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if sortedIndices.contains(index) {
            return .sorted
        } else if index == currentIndex {
            return .current
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    func countElementState(at index: Int) -> Bool {
        return index == countingIndex
    }
    
    enum ElementState {
        case unchecked
        case active
        case current
        case sorted
    }
}
