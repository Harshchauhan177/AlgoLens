//
//  SlidingWindowViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class SlidingWindowViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [2, 1, 5, 1, 3, 2]
    @Published var windowSize: Int = 3
    @Published var windowStart: Int = -1
    @Published var windowEnd: Int = -1
    @Published var currentSum: Int = 0
    @Published var maxSum: Int = 0
    @Published var maxWindowStart: Int = -1
    @Published var maxWindowEnd: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "2,1,5,1,3,2"
    @Published var windowSizeInput: String = "3"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var stepInfo: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8
    
    init() {
        updateFromInputs()
    }
    
    func updateFromInputs() {
        inputError = nil
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [2, 1, 5, 1, 3, 2]
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
        
        guard parsedArray.count <= 12 else {
            inputError = "Array too large. Maximum 12 elements"
            return
        }
        
        guard let size = Int(windowSizeInput.trimmingCharacters(in: .whitespaces)), size > 0 else {
            inputError = "Invalid window size"
            return
        }
        
        guard size <= parsedArray.count else {
            inputError = "Window size must be <= array length"
            return
        }
        
        array = parsedArray
        windowSize = size
    }
    
    func start() {
        guard canStart else { return }
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isRunning = true
            windowStart = 0
            windowEnd = windowSize - 1
            currentSum = Array(array[0..<windowSize]).reduce(0, +)
            maxSum = currentSum
            maxWindowStart = windowStart
            maxWindowEnd = windowEnd
            stepInfo = "Initial window: [\(windowStart)..\(windowEnd)], sum = \(currentSum)"
            
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
            windowStart = 0
            windowEnd = windowSize - 1
            currentSum = Array(array[0..<windowSize]).reduce(0, +)
            maxSum = currentSum
            maxWindowStart = windowStart
            maxWindowEnd = windowEnd
            stepInfo = "Initial window: [\(windowStart)..\(windowEnd)], sum = \(currentSum)"
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while windowEnd < array.count - 1 && !isCompleted {
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                guard !Task.isCancelled else { return }
                await MainActor.run { performStep() }
                if isCompleted { break }
            }
            await MainActor.run {
                // Ensure isCompleted is set to true
                if !isCompleted {
                    isCompleted = true
                    finalResult = "Maximum sum: \(maxSum) at window [\(maxWindowStart)..\(maxWindowEnd)]"
                }
                isAutoRunning = false
                canReset = true
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            windowStart = -1
            windowEnd = -1
            currentSum = 0
            maxSum = 0
            maxWindowStart = -1
            maxWindowEnd = -1
            isRunning = false
            isCompleted = false
            isAutoRunning = false
            stepInfo = ""
            finalResult = ""
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    private func performStep() {
        if windowEnd >= array.count - 1 {
            isCompleted = true
            canNext = false
            finalResult = "Maximum sum: \(maxSum) at window [\(maxWindowStart)..\(maxWindowEnd)]"
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Slide the window: remove leftmost element, add rightmost element
            let removedElement = array[windowStart]
            windowStart += 1
            windowEnd += 1
            let addedElement = array[windowEnd]
            
            currentSum = currentSum - removedElement + addedElement
            
            if currentSum > maxSum {
                maxSum = currentSum
                maxWindowStart = windowStart
                maxWindowEnd = windowEnd
                stepInfo = "New maximum! Window [\(windowStart)..\(windowEnd)], sum = \(currentSum)"
            } else {
                stepInfo = "Window [\(windowStart)..\(windowEnd)], sum = \(currentSum)"
            }
        }
    }
    
    func elementState(at index: Int) -> ElementState {
        if isRunning && index >= windowStart && index <= windowEnd {
            if index >= maxWindowStart && index <= maxWindowEnd && currentSum == maxSum {
                return .maxWindow
            }
            return .inWindow
        } else if isRunning && index < windowStart {
            return .checked
        }
        return .unchecked
    }
    
    func isInMaxWindow(at index: Int) -> Bool {
        return index >= maxWindowStart && index <= maxWindowEnd
    }
    
    enum ElementState {
        case unchecked
        case inWindow
        case maxWindow
        case checked
    }
}
