//
//  QuickSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class QuickSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var pivotIndex: Int? = nil
    @Published var comparingIndices: (Int, Int)? = nil
    @Published var partitionIndices: Set<Int> = []
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "10,7,8,9,1,5"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var currentPass: Int = 0
    @Published var totalPasses: Int = 0
    @Published var currentDepth: Int = 0
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Private State
    private var animationTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.6
    private var steps: [QuickSortStep] = []
    private var currentStepIndex: Int = 0
    
    struct QuickSortStep {
        let array: [Int]
        let pivotIndex: Int?
        let comparingIndices: (Int, Int)?
        let partitionIndices: Set<Int>
        let sortedIndices: Set<Int>
        let description: String
        let depth: Int
    }
    
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [10, 7, 8, 9, 1, 5]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 10,7,8,9)"
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
        // Approximate number of operations
        if parsedArray.count > 1 {
            totalPasses = parsedArray.count * Int(ceil(log2(Double(parsedArray.count))))
        } else {
            totalPasses = 0
        }
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnimating = true
            sortedIndices.removeAll()
            partitionIndices.removeAll()
            comparingIndices = nil
            pivotIndex = nil
            currentStep = 0
            currentStepIndex = 0
            currentPass = 1
            currentDepth = 0
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
        
        // Generate all steps
        steps = generateQuickSortSteps(array)
        comparisonResult = "Starting Quick Sort - selecting pivot and partitioning"
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
            partitionIndices.removeAll()
            comparingIndices = nil
            pivotIndex = nil
            currentStep = 0
            currentStepIndex = 0
            currentPass = 1
            currentDepth = 0
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        steps = generateQuickSortSteps(array)
        
        animationTask = Task {
            await performQuickSort()
            
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
            partitionIndices.removeAll()
            comparingIndices = nil
            pivotIndex = nil
            sortedIndices.removeAll()
            currentStep = 0
            currentStepIndex = 0
            currentPass = 0
            currentDepth = 0
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
            pivotIndex = step.pivotIndex
            comparingIndices = step.comparingIndices
            partitionIndices = step.partitionIndices
            sortedIndices = step.sortedIndices
            comparisonResult = step.description
            currentDepth = step.depth
            currentPass = currentStepIndex + 1
            currentStep += 1
        }
        
        currentStepIndex += 1
        
        if currentStepIndex >= steps.count {
            completeSort()
        }
    }
    
    private func performQuickSort() async {
        for (index, step) in steps.enumerated() {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                array = step.array
                pivotIndex = step.pivotIndex
                comparingIndices = step.comparingIndices
                partitionIndices = step.partitionIndices
                sortedIndices = step.sortedIndices
                comparisonResult = step.description
                currentDepth = step.depth
                currentPass = index + 1
                currentStep += 1
            }
            
            try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
        }
        
        await MainActor.run {
            completeSort()
        }
    }
    
    private func generateQuickSortSteps(_ arr: [Int]) -> [QuickSortStep] {
        var allSteps: [QuickSortStep] = []
        var workingArray = arr
        _ = generateStepsRecursive(&workingArray, low: 0, high: arr.count - 1, depth: 0, steps: &allSteps, sorted: Set<Int>())
        return allSteps
    }
    
    private func generateStepsRecursive(_ arr: inout [Int], low: Int, high: Int, depth: Int, steps: inout [QuickSortStep], sorted: Set<Int>) -> Set<Int> {
        var currentSorted = sorted
        
        guard low < high else {
            if low == high {
                currentSorted.insert(low)
                steps.append(QuickSortStep(
                    array: arr,
                    pivotIndex: nil,
                    comparingIndices: nil,
                    partitionIndices: Set([low]),
                    sortedIndices: currentSorted,
                    description: "✓ Single element at index \(low) is already sorted",
                    depth: depth
                ))
            }
            return currentSorted
        }
        
        let pivotIdx = high
        steps.append(QuickSortStep(
            array: arr,
            pivotIndex: pivotIdx,
            comparingIndices: nil,
            partitionIndices: Set(low...high),
            sortedIndices: currentSorted,
            description: "🎯 Selected pivot: \(arr[pivotIdx]) at index \(pivotIdx)",
            depth: depth
        ))
        
        let pivot = arr[high]
        var i = low - 1
        
        for j in low..<high {
            steps.append(QuickSortStep(
                array: arr,
                pivotIndex: pivotIdx,
                comparingIndices: (j, pivotIdx),
                partitionIndices: Set(low...high),
                sortedIndices: currentSorted,
                description: "⚡ Comparing \(arr[j]) with pivot \(pivot)",
                depth: depth
            ))
            
            if arr[j] < pivot {
                i += 1
                if i != j {
                    arr.swapAt(i, j)
                    steps.append(QuickSortStep(
                        array: arr,
                        pivotIndex: pivotIdx,
                        comparingIndices: (i, j),
                        partitionIndices: Set(low...high),
                        sortedIndices: currentSorted,
                        description: "🔄 Swapping \(arr[i]) and \(arr[j])",
                        depth: depth
                    ))
                }
            }
        }
        
        arr.swapAt(i + 1, high)
        let partitionIdx = i + 1
        
        steps.append(QuickSortStep(
            array: arr,
            pivotIndex: partitionIdx,
            comparingIndices: nil,
            partitionIndices: Set(low...high),
            sortedIndices: currentSorted,
            description: "🔄 Placing pivot \(pivot) at final position \(partitionIdx)",
            depth: depth
        ))
        
        currentSorted.insert(partitionIdx)
        
        steps.append(QuickSortStep(
            array: arr,
            pivotIndex: nil,
            comparingIndices: nil,
            partitionIndices: Set([partitionIdx]),
            sortedIndices: currentSorted,
            description: "✓ Pivot \(pivot) is now in its final sorted position",
            depth: depth
        ))
        
        // Recurse left
        if low < partitionIdx - 1 {
            currentSorted = generateStepsRecursive(&arr, low: low, high: partitionIdx - 1, depth: depth + 1, steps: &steps, sorted: currentSorted)
        }
        
        // Recurse right
        if partitionIdx + 1 < high {
            currentSorted = generateStepsRecursive(&arr, low: partitionIdx + 1, high: high, depth: depth + 1, steps: &steps, sorted: currentSorted)
        }
        
        return currentSorted
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        partitionIndices.removeAll()
        comparingIndices = nil
        pivotIndex = nil
        comparisonResult = ""
        finalResult = "✓ Array sorted successfully using Quick Sort in \(currentStep) operations!"
        
        // Mark all as sorted
        sortedIndices = Set(0..<array.count)
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if sortedIndices.contains(index) {
            return .sorted
        } else if index == pivotIndex {
            return .pivot
        } else if let (i, j) = comparingIndices, index == i || index == j {
            return .comparing
        } else if partitionIndices.contains(index) {
            return .partitioning
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    enum ElementState {
        case unchecked
        case active
        case pivot
        case partitioning
        case comparing
        case sorted
    }
}
