//
//  QuickSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class QuickSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var pivotIndex: Int? = nil
    @Published var comparingIndices: Set<Int> = []
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [10, 7, 8, 9, 1, 5]
        sortedIndices.removeAll()
        comparingIndices.removeAll()
        pivotIndex = nil
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            await performQuickSort(low: 0, high: array.count - 1)
            sortedIndices = Set(0..<array.count)
            pivotIndex = nil
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performQuickSort(low: Int, high: Int) async {
        guard low < high && !Task.isCancelled else { return }
        
        let pi = await partition(low: low, high: high)
        
        await performQuickSort(low: low, high: pi - 1)
        await performQuickSort(low: pi + 1, high: high)
    }
    
    private func partition(low: Int, high: Int) async -> Int {
        pivotIndex = high
        try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
        
        let pivot = array[high]
        var i = low - 1
        
        for j in low..<high {
            guard !Task.isCancelled else { return i + 1 }
            
            comparingIndices = [j]
            try? await Task.sleep(nanoseconds: UInt64(300_000_000 / speed))
            
            if array[j] < pivot {
                i += 1
                array.swapAt(i, j)
                try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
            }
            
            currentStep += 1
        }
        
        array.swapAt(i + 1, high)
        sortedIndices.insert(i + 1)
        try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
        
        pivotIndex = nil
        comparingIndices.removeAll()
        
        return i + 1
    }
}
