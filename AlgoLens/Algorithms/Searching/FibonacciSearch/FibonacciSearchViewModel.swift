//
//  FibonacciSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI
import Combine

@MainActor
class FibonacciSearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [2, 5, 8, 12, 16, 23, 38, 45, 56, 67]
    @Published var target: Int = 23
    @Published var fibM2: Int = 0  // (m-2)'th Fibonacci number
    @Published var fibM1: Int = 1  // (m-1)'th Fibonacci number
    @Published var fibM: Int = 1   // m'th Fibonacci number
    @Published var offset: Int = -1
    @Published var currentIndex: Int = -1
    @Published var foundIndex: Int? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "3,5,7,9,15,18,22"
    @Published var targetInput: String = "18"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var currentValue: Int?
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    @Published var fibonacciInfo: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Algorithm State
    private var searchPhase: SearchPhase = .initial
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 1.0
    
    // MARK: - Initialization
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        // Parse array input
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [2, 5, 8, 12, 16, 23, 38, 45, 56, 67]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers (e.g., 15,3,9,22)"
                return
            }
            parsedArray.append(number)
        }
        
        guard parsedArray.count > 0 else {
            inputError = "Array cannot be empty"
            return
        }
        
        guard parsedArray.count <= 10 else {
            inputError = "Array too large. Maximum 10 elements"
            return
        }
        
        // Parse target input
        guard let targetValue = Int(targetInput.trimmingCharacters(in: .whitespaces)) else {
            inputError = "Invalid target value. Enter a valid integer"
            return
        }
        
        // Sort the array for Fibonacci Search
        array = parsedArray.sorted()
        target = targetValue
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            searchPhase = .initial
            
            // Initialize Fibonacci numbers
            initializeFibonacci()
            
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
            isSearching = true
            isAutoRunning = true
            foundIndex = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            searchPhase = .initial
            
            initializeFibonacci()
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while !isCompleted {
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    performStep()
                }
                
                if isCompleted {
                    break
                }
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
            fibM2 = 0
            fibM1 = 1
            fibM = 1
            offset = -1
            currentIndex = -1
            foundIndex = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            currentValue = nil
            comparisonResult = ""
            finalResult = ""
            fibonacciInfo = ""
            searchPhase = .initial
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func initializeFibonacci() {
        let n = array.count
        
        fibM2 = 0
        fibM1 = 1
        fibM = fibM2 + fibM1
        
        // Find smallest Fibonacci number >= n
        while fibM < n {
            fibM2 = fibM1
            fibM1 = fibM
            fibM = fibM2 + fibM1
        }
        
        offset = -1
        currentIndex = -1
        
        fibonacciInfo = "Fibonacci: F(m-2)=\(fibM2), F(m-1)=\(fibM1), F(m)=\(fibM)"
        searchPhase = .searching
    }
    
    private func performStep() {
        let n = array.count
        
        guard fibM > 1 else {
            // Final check for remaining elements
            handleFinalCheck()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Calculate index to check
            let i = min(offset + fibM2, n - 1)
            currentIndex = i
            currentValue = array[i]
            
            fibonacciInfo = "Fibonacci: F(m-2)=\(fibM2), F(m-1)=\(fibM1), F(m)=\(fibM)"
            
            if array[i] < target {
                // Move one Fibonacci down
                fibM = fibM1
                fibM1 = fibM2
                fibM2 = fibM - fibM1
                offset = i
                comparisonResult = "✗ \(array[i]) < \(target), move right"
            } else if array[i] > target {
                // Move two Fibonacci down
                fibM = fibM2
                fibM1 = fibM1 - fibM2
                fibM2 = fibM - fibM1
                comparisonResult = "✗ \(array[i]) > \(target), move left"
            } else {
                // Element found
                foundIndex = i
                isCompleted = true
                canNext = false
                comparisonResult = "✓ Match found!"
                finalResult = "Success! Target \(target) found at index \(i)"
                
                if !isAutoRunning {
                    canReset = true
                }
            }
        }
    }
    
    private func handleFinalCheck() {
        let n = array.count
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Check if fibM1 is 1 and element at offset+1 is target
            if fibM1 == 1 && offset + 1 < n {
                currentIndex = offset + 1
                currentValue = array[offset + 1]
                
                if array[offset + 1] == target {
                    foundIndex = offset + 1
                    comparisonResult = "✓ Match found!"
                    finalResult = "Success! Target \(target) found at index \(offset + 1)"
                } else {
                    comparisonResult = ""
                    finalResult = "Target \(target) not found in the array"
                }
            } else {
                comparisonResult = ""
                finalResult = "Target \(target) not found in the array"
            }
            
            isCompleted = true
            canNext = false
            
            if !isAutoRunning {
                canReset = true
            }
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if let found = foundIndex, found == index {
            return .found
        } else if currentIndex == index && isSearching {
            return .current
        } else if isSearching && offset >= 0 && index <= offset {
            return .checked
        } else {
            return .unchecked
        }
    }
    
    func pointerLabel(at index: Int) -> String? {
        guard isSearching else { return nil }
        
        if currentIndex == index {
            return "Check"
        }
        if offset == index && offset >= 0 {
            return "Offset"
        }
        
        return nil
    }
    
    enum ElementState {
        case unchecked
        case current
        case checked
        case found
    }
    
    enum SearchPhase {
        case initial
        case searching
    }
}
