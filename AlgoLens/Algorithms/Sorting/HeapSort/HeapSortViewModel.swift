//
//  HeapSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class HeapSortViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var heapifyingIndices: Set<Int> = []
    @Published var comparingIndices: (Int, Int)? = nil
    @Published var rootIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "12,11,13,5,6,7"
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
    private var steps: [HeapSortStep] = []
    private var currentStepIndex: Int = 0
    
    struct HeapSortStep {
        let array: [Int]
        let heapifyingIndices: Set<Int>
        let comparingIndices: (Int, Int)?
        let rootIndex: Int?
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
            array = [12, 11, 13, 5, 6, 7]
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
        // Approximate number of operations
        if parsedArray.count > 1 {
            totalPasses = parsedArray.count * 2
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
            heapifyingIndices.removeAll()
            comparingIndices = nil
            rootIndex = nil
            currentStep = 0
            currentStepIndex = 0
            currentPass = 1
            currentPhase = "Building Heap"
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
        
        // Generate all steps
        steps = generateHeapSortSteps(array)
        comparisonResult = "Starting Heap Sort - building max heap"
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
            heapifyingIndices.removeAll()
            comparingIndices = nil
            rootIndex = nil
            currentStep = 0
            currentStepIndex = 0
            currentPass = 1
            currentPhase = "Building Heap"
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        steps = generateHeapSortSteps(array)
        
        animationTask = Task {
            await performHeapSort()
            
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
            heapifyingIndices.removeAll()
            comparingIndices = nil
            rootIndex = nil
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
            heapifyingIndices = step.heapifyingIndices
            comparingIndices = step.comparingIndices
            rootIndex = step.rootIndex
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
    
    private func performHeapSort() async {
        for (index, step) in steps.enumerated() {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                array = step.array
                heapifyingIndices = step.heapifyingIndices
                comparingIndices = step.comparingIndices
                rootIndex = step.rootIndex
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
    
    private func generateHeapSortSteps(_ arr: [Int]) -> [HeapSortStep] {
        var allSteps: [HeapSortStep] = []
        var workingArray = arr
        let n = workingArray.count
        
        // Phase 1: Build max heap
        allSteps.append(HeapSortStep(
            array: workingArray,
            heapifyingIndices: Set<Int>(),
            comparingIndices: nil,
            rootIndex: nil,
            sortedIndices: Set<Int>(),
            description: "🏗️ Phase 1: Building max heap from unsorted array",
            phase: "Building Heap"
        ))
        
        for i in stride(from: n/2 - 1, through: 0, by: -1) {
            heapifySteps(&workingArray, n: n, i: i, steps: &allSteps, sorted: Set<Int>(), phase: "Building Heap")
        }
        
        allSteps.append(HeapSortStep(
            array: workingArray,
            heapifyingIndices: Set<Int>(),
            comparingIndices: nil,
            rootIndex: 0,
            sortedIndices: Set<Int>(),
            description: "✓ Max heap built! Root contains largest element: \(workingArray[0])",
            phase: "Heap Built"
        ))
        
        // Phase 2: Extract elements from heap
        var currentSorted = Set<Int>()
        
        for i in stride(from: n-1, through: 1, by: -1) {
            allSteps.append(HeapSortStep(
                array: workingArray,
                heapifyingIndices: Set([0, i]),
                comparingIndices: (0, i),
                rootIndex: 0,
                sortedIndices: currentSorted,
                description: "🔄 Swapping root \(workingArray[0]) with last element \(workingArray[i])",
                phase: "Extracting"
            ))
            
            workingArray.swapAt(0, i)
            currentSorted.insert(i)
            
            allSteps.append(HeapSortStep(
                array: workingArray,
                heapifyingIndices: Set([i]),
                comparingIndices: nil,
                rootIndex: nil,
                sortedIndices: currentSorted,
                description: "✓ Element \(workingArray[i]) in final position",
                phase: "Extracting"
            ))
            
            heapifySteps(&workingArray, n: i, i: 0, steps: &allSteps, sorted: currentSorted, phase: "Extracting")
        }
        
        currentSorted.insert(0)
        
        return allSteps
    }
    
    private func heapifySteps(_ arr: inout [Int], n: Int, i: Int, steps: inout [HeapSortStep], sorted: Set<Int>, phase: String) {
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        let indices = Set([i, left, right].filter { $0 < n })
        
        steps.append(HeapSortStep(
            array: arr,
            heapifyingIndices: indices,
            comparingIndices: nil,
            rootIndex: i,
            sortedIndices: sorted,
            description: "🔍 Heapifying subtree rooted at index \(i) (value: \(arr[i]))",
            phase: phase
        ))
        
        if left < n {
            steps.append(HeapSortStep(
                array: arr,
                heapifyingIndices: indices,
                comparingIndices: (i, left),
                rootIndex: i,
                sortedIndices: sorted,
                description: "⚡ Comparing parent \(arr[i]) with left child \(arr[left])",
                phase: phase
            ))
            
            if arr[left] > arr[largest] {
                largest = left
            }
        }
        
        if right < n {
            steps.append(HeapSortStep(
                array: arr,
                heapifyingIndices: indices,
                comparingIndices: (largest, right),
                rootIndex: i,
                sortedIndices: sorted,
                description: "⚡ Comparing current largest \(arr[largest]) with right child \(arr[right])",
                phase: phase
            ))
            
            if arr[right] > arr[largest] {
                largest = right
            }
        }
        
        if largest != i {
            steps.append(HeapSortStep(
                array: arr,
                heapifyingIndices: indices,
                comparingIndices: (i, largest),
                rootIndex: i,
                sortedIndices: sorted,
                description: "🔄 Swapping \(arr[i]) with larger child \(arr[largest])",
                phase: phase
            ))
            
            arr.swapAt(i, largest)
            
            heapifySteps(&arr, n: n, i: largest, steps: &steps, sorted: sorted, phase: phase)
        } else {
            steps.append(HeapSortStep(
                array: arr,
                heapifyingIndices: Set([i]),
                comparingIndices: nil,
                rootIndex: nil,
                sortedIndices: sorted,
                description: "✓ Heap property satisfied at index \(i)",
                phase: phase
            ))
        }
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        heapifyingIndices.removeAll()
        comparingIndices = nil
        rootIndex = nil
        comparisonResult = ""
        currentPhase = "Complete"
        finalResult = "✓ Array sorted successfully using Heap Sort in \(currentStep) operations!"
        
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
        } else if index == rootIndex {
            return .root
        } else if let (i, j) = comparingIndices, index == i || index == j {
            return .comparing
        } else if heapifyingIndices.contains(index) {
            return .heapifying
        } else if isAnimating {
            return .active
        } else {
            return .unchecked
        }
    }
    
    enum ElementState {
        case unchecked
        case active
        case root
        case heapifying
        case comparing
        case sorted
    }
}
