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
    @Published var array: [Int] = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
    @Published var currentSum: Int = 0
    @Published var maxSum: Int = Int.min
    @Published var currentIndex: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var arrayInput: String = "-2,1,-3,4,-1,2,1,-5,4"
    @Published var inputError: String?
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canReset: Bool = false
    @Published var stepInfo: String = ""
    
    func updateFromInputs() {
        inputError = nil
        let components = arrayInput.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard !components.isEmpty else { inputError = "Invalid input"; return }
        array = components
    }
    
    func start() {
        updateFromInputs()
        guard inputError == nil else { return }
        currentIndex = 0
        currentSum = array[0]
        maxSum = array[0]
        isRunning = true
        canStart = false
        canNext = true
        stepInfo = "Starting with first element: \(array[0])"
    }
    
    func nextStep() {
        guard currentIndex < array.count - 1 else {
            isCompleted = true
            canNext = false
            stepInfo = "Maximum subarray sum: \(maxSum)"
            return
        }
        currentIndex += 1
        currentSum = max(array[currentIndex], currentSum + array[currentIndex])
        maxSum = max(maxSum, currentSum)
        stepInfo = "Current sum: \(currentSum), Max sum: \(maxSum)"
    }
    
    func reset() {
        currentIndex = -1
        currentSum = 0
        maxSum = Int.min
        isRunning = false
        isCompleted = false
        canStart = true
        canNext = false
        stepInfo = ""
    }
}
