//
//  MergeSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class MergeSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var mergingIndices: Set<Int> = []
    @Published var comparingIndices: (Int, Int)? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "38,27,43,3,9,82,10"
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
    private var steps: [MergeStep] = []
    private var currentStepIndex: Int = 0
    
    struct MergeStep {
        let array: [Int]
        let mergingIndices: Set<Int>
        let comparingIndices: (Int, Int)?
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
            array = [38, 27, 43, 3, 9, 82, 10]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 38,27,43,3)"
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
        // Calculate approximate number of passes (merge operations)
        if parsedArray.count > 1 {
            totalPasses = Int(ceil(log2(Double(parsedArray.count)))) * parsedArray.count
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
            mergingIndices.removeAll()
            comparingIndices = nil
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
        steps = generateMergeSortSteps(array)
        comparisonResult = "Starting Merge Sort - dividing array into subarrays"
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
            mergingIndices.removeAll()
            comparingIndices = nil
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
        
        steps = generateMergeSortSteps(array)
        
        animationTask = Task {
            await performMergeSort()
            
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
            mergingIndices.removeAll()
            comparingIndices = nil
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
            mergingIndices = step.mergingIndices
            comparingIndices = step.comparingIndices
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
    
    private func performMergeSort() async {
        for (index, step) in steps.enumerated() {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                array = step.array
                mergingIndices = step.mergingIndices
                comparingIndices = step.comparingIndices
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
    
    private func generateMergeSortSteps(_ arr: [Int]) -> [MergeStep] {
        var allSteps: [MergeStep] = []
        _ = generateStepsRecursive(arr, startIndex: 0, depth: 0, steps: &allSteps)
        return allSteps
    }
    
    private func generateStepsRecursive(_ arr: [Int], startIndex: Int, depth: Int, steps: inout [MergeStep]) -> [Int] {
        guard arr.count > 1 else {
            steps.append(MergeStep(
                array: array,
                mergingIndices: Set([startIndex]),
                comparingIndices: nil,
                description: "✓ Base case: single element [\(arr[0])] is sorted",
                depth: depth
            ))
            return arr
        }
        
        let mid = arr.count / 2
        let leftIndices = Set(startIndex..<(startIndex + mid))
        let rightIndices = Set((startIndex + mid)..<(startIndex + arr.count))
        
        steps.append(MergeStep(
            array: array,
            mergingIndices: leftIndices.union(rightIndices),
            comparingIndices: nil,
            description: "🔀 Dividing array into left[\(Array(arr[..<mid]).map(String.init).joined(separator: ","))] and right[\(Array(arr[mid...]).map(String.init).joined(separator: ","))]",
            depth: depth
        ))
        
        let left = generateStepsRecursive(Array(arr[..<mid]), startIndex: startIndex, depth: depth + 1, steps: &steps)
        let right = generateStepsRecursive(Array(arr[mid...]), startIndex: startIndex + mid, depth: depth + 1, steps: &steps)
        
        return mergeWithSteps(left, right, startIndex: startIndex, depth: depth, steps: &steps)
    }
    
    private func mergeWithSteps(_ left: [Int], _ right: [Int], startIndex: Int, depth: Int, steps: inout [MergeStep]) -> [Int] {
        var result = [Int]()
        var i = 0, j = 0
        var tempArray = array
        var currentIndex = startIndex
        
        steps.append(MergeStep(
            array: array,
            mergingIndices: Set(startIndex..<(startIndex + left.count + right.count)),
            comparingIndices: nil,
            description: "🔗 Merging [\(left.map(String.init).joined(separator: ","))] and [\(right.map(String.init).joined(separator: ","))]",
            depth: depth
        ))
        
        while i < left.count && j < right.count {
            if left[i] <= right[j] {
                result.append(left[i])
                tempArray[currentIndex] = left[i]
                
                steps.append(MergeStep(
                    array: tempArray,
                    mergingIndices: Set(startIndex..<(startIndex + left.count + right.count)),
                    comparingIndices: (currentIndex, currentIndex),
                    description: "⚡ Comparing \(left[i]) ≤ \(right[j]), taking \(left[i]) from left",
                    depth: depth
                ))
                
                i += 1
            } else {
                result.append(right[j])
                tempArray[currentIndex] = right[j]
                
                steps.append(MergeStep(
                    array: tempArray,
                    mergingIndices: Set(startIndex..<(startIndex + left.count + right.count)),
                    comparingIndices: (currentIndex, currentIndex),
                    description: "⚡ Comparing \(left[i]) > \(right[j]), taking \(right[j]) from right",
                    depth: depth
                ))
                
                j += 1
            }
            currentIndex += 1
        }
        
        while i < left.count {
            result.append(left[i])
            tempArray[currentIndex] = left[i]
            steps.append(MergeStep(
                array: tempArray,
                mergingIndices: Set(startIndex..<(startIndex + left.count + right.count)),
                comparingIndices: (currentIndex, currentIndex),
                description: "✓ Adding remaining element \(left[i]) from left",
                depth: depth
            ))
            i += 1
            currentIndex += 1
        }
        
        while j < right.count {
            result.append(right[j])
            tempArray[currentIndex] = right[j]
            steps.append(MergeStep(
                array: tempArray,
                mergingIndices: Set(startIndex..<(startIndex + left.count + right.count)),
                comparingIndices: (currentIndex, currentIndex),
                description: "✓ Adding remaining element \(right[j]) from right",
                depth: depth
            ))
            j += 1
            currentIndex += 1
        }
        
        // Update the main array reference
        for (idx, val) in result.enumerated() {
            array[startIndex + idx] = val
        }
        
        return result
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        mergingIndices.removeAll()
        comparingIndices = nil
        comparisonResult = ""
        finalResult = "✓ Array sorted successfully using Merge Sort in \(currentStep) operations!"
        
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
        } else if let (i, j) = comparingIndices, index == i || index == j {
            return .comparing
        } else if mergingIndices.contains(index) {
            return .merging
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    enum ElementState {
        case unchecked
        case active
        case merging
        case comparing
        case sorted
    }
}
