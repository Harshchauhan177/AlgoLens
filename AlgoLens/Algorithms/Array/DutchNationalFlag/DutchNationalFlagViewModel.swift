//
//  DutchNationalFlagViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class DutchNationalFlagViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [2, 0, 1, 2, 1, 0, 1, 2, 0]
    @Published var low: Int = -1
    @Published var mid: Int = -1
    @Published var high: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "2,0,1,2,1,0,1,2,0"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var stepInfo: String = ""
    @Published var currentAction: String = ""
    
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
            array = [2, 0, 1, 2, 1, 0, 1, 2, 0]
            return
        }
        
        let components = trimmedArray.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var parsedArray: [Int] = []
        
        for component in components {
            guard let number = Int(component) else {
                inputError = "Invalid array format. Use comma-separated integers"
                return
            }
            guard number >= 0 && number <= 2 else {
                inputError = "Array must contain only 0, 1, or 2"
                return
            }
            parsedArray.append(number)
        }
        
        guard parsedArray.count >= 3 else {
            inputError = "Array must have at least 3 elements"
            return
        }
        
        guard parsedArray.count <= 15 else {
            inputError = "Array too large. Maximum 15 elements"
            return
        }
        
        array = parsedArray
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            low = 0
            mid = 0
            high = array.count - 1
            isRunning = true
            isCompleted = false
            stepInfo = "Starting Dutch National Flag sort"
            currentAction = "Initialize: low=0, mid=0, high=\(array.count - 1)"
            
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
            low = 0
            mid = 0
            high = array.count - 1
            isRunning = true
            isAutoRunning = true
            isCompleted = false
            stepInfo = "Running complete sort"
            currentAction = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while mid <= high && !isCompleted {
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
            low = -1
            mid = -1
            high = -1
            isRunning = false
            isCompleted = false
            isAutoRunning = false
            stepInfo = ""
            currentAction = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard mid <= high else {
            completeSort()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if array[mid] == 0 {
                array.swapAt(low, mid)
                currentAction = "Found 0: swap array[\(low)] ↔ array[\(mid)], move low and mid right"
                low += 1
                mid += 1
            } else if array[mid] == 1 {
                currentAction = "Found 1: already in correct region, move mid right"
                mid += 1
            } else {
                array.swapAt(mid, high)
                currentAction = "Found 2: swap array[\(mid)] ↔ array[\(high)], move high left"
                high -= 1
            }
            stepInfo = "low=\(low), mid=\(mid), high=\(high)"
            
            if mid > high {
                completeSort()
            }
        }
    }
    
    private func completeSort() {
        isCompleted = true
        canNext = false
        stepInfo = "Sorting complete!"
        currentAction = "All 0s, then 1s, then 2s arranged"
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Element State
    func elementState(at index: Int) -> ElementState {
        if !isRunning {
            return .unchecked
        }
        
        if isCompleted {
            if array[index] == 0 {
                return .zero
            } else if array[index] == 1 {
                return .one
            } else {
                return .two
            }
        }
        
        if index == mid {
            return .current
        } else if index == low || index == high {
            return .pointer
        } else if index < low {
            return .zero
        } else if index > high {
            return .two
        } else if index > low && index < mid {
            return .one
        }
        
        return .unsorted
    }
    
    func pointerLabel(at index: Int) -> String? {
        guard isRunning && !isCompleted else { return nil }
        
        var labels: [String] = []
        if low == index { labels.append("L") }
        if mid == index { labels.append("M") }
        if high == index { labels.append("H") }
        
        return labels.isEmpty ? nil : labels.joined(separator: " ")
    }
    
    enum ElementState {
        case unchecked
        case current
        case pointer
        case zero
        case one
        case two
        case unsorted
    }
}
