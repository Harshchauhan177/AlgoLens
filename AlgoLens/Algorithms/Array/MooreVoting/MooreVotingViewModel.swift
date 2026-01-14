//
//  MooreVotingViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class MooreVotingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var array: [Int] = [3, 3, 4, 2, 4, 4, 2, 4, 4]
    @Published var currentIndex: Int = -1
    @Published var candidate: Int? = nil
    @Published var count: Int = 0
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isVerifying: Bool = false
    @Published var verificationResult: String = ""
    
    // MARK: - Input Fields
    @Published var arrayInput: String = "3,3,4,2,4,4,2,4,4"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var stepInfo: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    @Published var canVerify: Bool = false
    
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
            array = [3, 3, 4, 2, 4, 4, 2, 4, 4]
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
        
        guard parsedArray.count <= 15 else {
            inputError = "Array too large. Maximum 15 elements"
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
            currentIndex = -1
            candidate = nil
            count = 0
            stepInfo = "Starting Moore's Voting Algorithm..."
            
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
            currentIndex = -1
            candidate = nil
            count = 0
            stepInfo = "Starting Moore's Voting Algorithm..."
            
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
                // Ensure isCompleted is set to true
                if !isCompleted {
                    isCompleted = true
                    finalResult = "Candidate found: \(candidate!). Click 'Verify' to confirm if it's the majority element."
                }
                isAutoRunning = false
                canReset = true
                canVerify = true
            }
        }
    }
    
    func verify() {
        guard let candidate = candidate else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isVerifying = true
            let occurrences = array.filter { $0 == candidate }.count
            let majorityThreshold = array.count / 2
            
            if occurrences > majorityThreshold {
                verificationResult = "✓ \(candidate) appears \(occurrences) times (> \(majorityThreshold)) - It is the majority element!"
            } else {
                verificationResult = "✗ \(candidate) appears \(occurrences) times (≤ \(majorityThreshold)) - No majority element exists"
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = -1
            candidate = nil
            count = 0
            isRunning = false
            isCompleted = false
            isAutoRunning = false
            isVerifying = false
            stepInfo = ""
            finalResult = ""
            verificationResult = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
            canVerify = false
        }
    }
    
    private func performStep() {
        guard currentIndex < array.count - 1 else {
            isCompleted = true
            canNext = false
            canVerify = true
            finalResult = "Candidate found: \(candidate!). Click 'Verify' to confirm if it's the majority element."
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex += 1
            let currentElement = array[currentIndex]
            
            // First element - initialize candidate
            if candidate == nil {
                candidate = currentElement
                count = 1
                stepInfo = "Initialize: candidate = \(candidate!), count = 1"
                return
            }
            
            if currentElement == candidate {
                count += 1
                stepInfo = "Match! \(currentElement) == \(candidate!) → count = \(count)"
            } else {
                count -= 1
                if count == 0 {
                    candidate = currentElement
                    count = 1
                    stepInfo = "Count reached 0! New candidate = \(candidate!), count = 1"
                } else {
                    stepInfo = "Different! \(currentElement) ≠ \(candidate!) → count = \(count)"
                }
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
    
    func isCandidate(at index: Int) -> Bool {
        guard let candidate = candidate else { return false }
        // Only show CAND badge on checked elements that match the current candidate
        if index >= currentIndex {
            return false  // Don't show badge on current or future elements
        }
        return array[index] == candidate
    }
    
    enum ElementState {
        case unchecked
        case current
        case checked
    }
}
