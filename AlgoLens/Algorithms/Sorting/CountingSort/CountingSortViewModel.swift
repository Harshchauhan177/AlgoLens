//
//  CountingSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class CountingSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var countArray: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var currentIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [4, 2, 2, 8, 3, 3, 1]
        countArray = []
        sortedIndices.removeAll()
        currentIndex = nil
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            await performCountingSort()
            sortedIndices = Set(0..<array.count)
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performCountingSort() async {
        guard let max = array.max() else { return }
        
        // Initialize count array
        countArray = Array(repeating: 0, count: max + 1)
        try? await Task.sleep(nanoseconds: UInt64(600_000_000 / speed))
        
        // Count occurrences
        for (index, num) in array.enumerated() {
            guard !Task.isCancelled else { return }
            currentIndex = index
            countArray[num] += 1
            try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
            currentStep += 1
        }
        
        // Cumulative count
        for i in 1...max {
            guard !Task.isCancelled else { return }
            countArray[i] += countArray[i - 1]
            try? await Task.sleep(nanoseconds: UInt64(300_000_000 / speed))
        }
        
        // Build output array
        var output = Array(repeating: 0, count: array.count)
        for i in stride(from: array.count - 1, through: 0, by: -1) {
            guard !Task.isCancelled else { return }
            currentIndex = i
            output[countArray[array[i]] - 1] = array[i]
            countArray[array[i]] -= 1
            try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
            currentStep += 1
        }
        
        array = output
        currentIndex = nil
    }
}
