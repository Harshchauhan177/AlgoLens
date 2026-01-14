//
//  TwoPointerViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class TwoPointerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @Published var target: Int = 10
    @Published var leftPointer: Int = -1
    @Published var rightPointer: Int = -1
    @Published var foundPair: (Int, Int)? = nil
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "1,2,3,4,5,6,7,8,9"
    @Published var targetInput: String = "10"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var currentSum: Int = 0
    @Published var comparisonResult: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8
    
    // MARK: - Initialization
    init() {
        updateFromInputs()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedArray = arrayInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedArray.isEmpty else {
            array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
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
        
        guard parsedArray.count > 1 else {
            inputError = "Array must have at least 2 elements"
            return
        }
        
        guard parsedArray.count <= 15 else {
            inputError = "Array too large. Maximum 15 elements"
            return
        }
        
        guard let targetValue = Int(targetInput.trimmingCharacters(in: .whitespaces)) else {
            inputError = "Invalid target value"
            return
        }
        
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
            leftPointer = 0
            rightPointer = array.count - 1
            foundPair = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            currentSum = array[leftPointer] + array[rightPointer]
            
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
            leftPointer = 0
            rightPointer = array.count - 1
            foundPair = nil
            isCompleted = false
            comparisonResult = ""
            finalResult = ""
            currentSum = array[leftPointer] + array[rightPointer]
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while leftPointer < rightPointer && !isCompleted {
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
            leftPointer = -1
            rightPointer = -1
            foundPair = nil
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            currentSum = 0
            comparisonResult = ""
            finalResult = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard leftPointer < rightPointer else {
            completeSearchNotFound()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentSum = array[leftPointer] + array[rightPointer]
            
            if currentSum == target {
                foundPair = (leftPointer, rightPointer)
                isCompleted = true
                canNext = false
                comparisonResult = "✓ Found pair!"
                finalResult = "Success! Pair (\(array[leftPointer]), \(array[rightPointer])) sums to \(target)"
                
                if !isAutoRunning {
                    canReset = true
                }
            } else if currentSum < target {
                comparisonResult = "\(currentSum) < \(target), move left pointer right"
                leftPointer += 1
                
                if leftPointer >= rightPointer {
                    completeSearchNotFound()
                }
            } else {
                comparisonResult = "\(currentSum) > \(target), move right pointer left"
                rightPointer -= 1
                
                if leftPointer >= rightPointer {
                    completeSearchNotFound()
                }
            }
        }
    }
    
    private func completeSearchNotFound() {
        isCompleted = true
        canNext = false
        comparisonResult = ""
        finalResult = "No pair found that sums to \(target)"
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if let pair = foundPair, pair.0 == index || pair.1 == index {
            return .found
        } else if leftPointer == index || rightPointer == index {
            return .current
        } else if isSearching && index > leftPointer && index < rightPointer {
            return .inRange
        } else if isSearching && (index < leftPointer || index > rightPointer) {
            return .checked
        }
        return .unchecked
    }
    
    func pointerLabel(at index: Int) -> String? {
        guard isSearching else { return nil }
        
        if leftPointer == index && rightPointer == index {
            return "L R"
        } else if leftPointer == index {
            return "L"
        } else if rightPointer == index {
            return "R"
        }
        return nil
    }
    
    enum ElementState {
        case unchecked
        case current
        case inRange
        case checked
        case found
    }
}
