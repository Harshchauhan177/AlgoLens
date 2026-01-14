//
//  PrefixSumViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class PrefixSumViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [1, 2, 3, 4, 5]
    @Published var prefixSum: [Int] = []
    @Published var currentIndex: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Range Query
    @Published var queryLeft: Int = -1
    @Published var queryRight: Int = -1
    @Published var queryResult: Int = 0
    @Published var showQueryResult: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "1,2,3,4,5"
    @Published var inputError: String?
    @Published var queryLeftInput: String = ""
    @Published var queryRightInput: String = ""
    
    // MARK: - Step Information
    @Published var stepInfo: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    @Published var canQuery: Bool = false
    
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
            array = [1, 2, 3, 4, 5]
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
        
        guard parsedArray.count <= 10 else {
            inputError = "Array too large. Maximum 10 elements"
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
            prefixSum = [array[0]]
            stepInfo = "prefix[0] = \(array[0])"
            
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
            prefixSum = [array[0]]
            stepInfo = "prefix[0] = \(array[0])"
            
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
                canQuery = true
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            prefixSum = []
            currentIndex = -1
            isRunning = false
            isCompleted = false
            isAutoRunning = false
            stepInfo = ""
            finalResult = ""
            queryLeft = -1
            queryRight = -1
            queryResult = 0
            showQueryResult = false
            queryLeftInput = ""
            queryRightInput = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
            canQuery = false
        }
    }
    
    func executeQuery() {
        guard let left = Int(queryLeftInput.trimmingCharacters(in: .whitespaces)),
              let right = Int(queryRightInput.trimmingCharacters(in: .whitespaces)),
              left >= 0, right < array.count, left <= right else {
            inputError = "Invalid query range"
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            queryLeft = left
            queryRight = right
            
            // Calculate range sum using prefix sum array
            if left == 0 {
                queryResult = prefixSum[right]
            } else {
                queryResult = prefixSum[right] - prefixSum[left - 1]
            }
            
            showQueryResult = true
            inputError = nil
        }
    }
    
    private func performStep() {
        guard currentIndex < array.count - 1 else {
            isCompleted = true
            canNext = false
            canQuery = true
            finalResult = "Prefix sum array built! Ready for O(1) range queries."
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex += 1
            let newPrefixSum = prefixSum[currentIndex - 1] + array[currentIndex]
            prefixSum.append(newPrefixSum)
            stepInfo = "prefix[\(currentIndex)] = prefix[\(currentIndex - 1)] + arr[\(currentIndex)] = \(prefixSum[currentIndex - 1]) + \(array[currentIndex]) = \(newPrefixSum)"
        }
    }
    
    func elementState(at index: Int) -> ElementState {
        if currentIndex == index {
            return .current
        } else if index < currentIndex {
            return .completed
        }
        return .unchecked
    }
    
    func prefixElementState(at index: Int) -> ElementState {
        if index < prefixSum.count {
            if currentIndex == index {
                return .current
            } else {
                return .completed
            }
        }
        return .unchecked
    }
    
    func isInQueryRange(at index: Int) -> Bool {
        return showQueryResult && index >= queryLeft && index <= queryRight
    }
    
    enum ElementState {
        case unchecked
        case current
        case completed
    }
}
