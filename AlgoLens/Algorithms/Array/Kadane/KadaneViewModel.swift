//
//  KadaneViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class KadaneViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
    @Published var currentIndex: Int = -1
    @Published var currentSum: Int = 0
    @Published var maxSum: Int = Int.min
    @Published var maxStartIndex: Int = 0
    @Published var maxEndIndex: Int = 0
    @Published var tempStartIndex: Int = 0
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "-2,1,-3,4,-1,2,1,-5,4"
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
    private let autoRunDelay: Double = 0.9
    
    init() {
        updateFromInputs()
    }
    
    func updateFromInputs() {
        inputError = nil
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
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
        
        guard !parsedArray.isEmpty else {
            inputError = "Array cannot be empty"
            return
        }
        
        guard parsedArray.count <= 12 else {
            inputError = "Array too large. Maximum 12 elements"
            return
        }
        
        array = parsedArray
    }
    
    func start() {
        guard canStart else { return }
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isRunning = true
            currentIndex = 0
            currentSum = array[0]
            maxSum = array[0]
            maxStartIndex = 0
            maxEndIndex = 0
            tempStartIndex = 0
            stepInfo = "Initialize: currentSum = \(currentSum), maxSum = \(maxSum)"
            
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
            currentSum = array[0]
            maxSum = array[0]
            maxStartIndex = 0
            maxEndIndex = 0
            tempStartIndex = 0
            stepInfo = "Initialize: currentSum = \(currentSum), maxSum = \(maxSum)"
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while currentIndex < array.count - 1 && !isCompleted {
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                guard !Task.isCancelled else { return }
                await MainActor.run { performStep() }
                if isCompleted { break }
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
            maxSum = Int.min
            maxStartIndex = 0
            maxEndIndex = 0
            tempStartIndex = 0
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
        guard currentIndex < array.count - 1 else {
            isCompleted = true
            canNext = false
            let subarrayElements = Array(array[maxStartIndex...maxEndIndex])
            finalResult = "Maximum subarray sum: \(maxSum) from [\(subarrayElements.map { String($0) }.joined(separator: ", "))]"
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex += 1
            let currentElement = array[currentIndex]
            
            // Kadane's key decision: extend current subarray or start new one
            if currentSum + currentElement > currentElement {
                currentSum += currentElement
                stepInfo = "Extend: currentSum = \(currentSum - currentElement) + \(currentElement) = \(currentSum)"
            } else {
                currentSum = currentElement
                tempStartIndex = currentIndex
                stepInfo = "Restart: currentSum = \(currentElement) (starting new subarray)"
            }
            
            // Update maximum if current is better
            if currentSum > maxSum {
                maxSum = currentSum
                maxStartIndex = tempStartIndex
                maxEndIndex = currentIndex
                stepInfo += " → New max: \(maxSum)!"
            }
        }
    }
    
    func elementState(at index: Int) -> ElementState {
        if !isRunning {
            return .unchecked
        }
        
        if index == currentIndex {
            return .current
        } else if index > currentIndex {
            return .unchecked
        } else {
            return .checked
        }
    }
    
    func isInMaxSubarray(at index: Int) -> Bool {
        return isRunning && index >= maxStartIndex && index <= maxEndIndex
    }
    
    func isInCurrentSubarray(at index: Int) -> Bool {
        return isRunning && index >= tempStartIndex && index <= currentIndex
    }
    
    enum ElementState {
        case unchecked
        case current
        case checked
    }
}
