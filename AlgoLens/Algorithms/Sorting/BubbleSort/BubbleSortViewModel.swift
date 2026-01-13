//
//  BubbleSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class BubbleSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var comparingIndices: (Int, Int)? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [64, 34, 25, 12, 22, 11, 90]
        sortedIndices.removeAll()
        comparingIndices = nil
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            await performBubbleSort()
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performBubbleSort() async {
        let n = array.count
        
        for i in 0..<n-1 {
            guard !Task.isCancelled else { return }
            
            for j in 0..<n-i-1 {
                guard !Task.isCancelled else { return }
                
                comparingIndices = (j, j+1)
                try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
                
                if array[j] > array[j+1] {
                    array.swapAt(j, j+1)
                    try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
                }
                
                currentStep += 1
            }
            
            sortedIndices.insert(n-i-1)
        }
        
        sortedIndices.insert(0)
        comparingIndices = nil
    }
}
