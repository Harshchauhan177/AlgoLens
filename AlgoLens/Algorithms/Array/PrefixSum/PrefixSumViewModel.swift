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
    @Published var array: [Int] = [1, 2, 3, 4, 5]
    @Published var prefixSum: [Int] = []
    @Published var currentIndex: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var arrayInput: String = "1,2,3,4,5"
    @Published var inputError: String?
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canReset: Bool = false
    
    func updateFromInputs() {
        inputError = nil
        let components = arrayInput.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard !components.isEmpty else { inputError = "Invalid input"; return }
        array = components
    }
    
    func start() {
        updateFromInputs()
        guard inputError == nil else { return }
        prefixSum = [array[0]]
        currentIndex = 0
        isRunning = true
        canStart = false
        canNext = true
    }
    
    func nextStep() {
        guard currentIndex < array.count - 1 else {
            isCompleted = true
            canNext = false
            return
        }
        currentIndex += 1
        prefixSum.append(prefixSum[currentIndex - 1] + array[currentIndex])
    }
    
    func reset() {
        prefixSum = []
        currentIndex = -1
        isRunning = false
        isCompleted = false
        canStart = true
        canNext = false
        canReset = false
    }
}
