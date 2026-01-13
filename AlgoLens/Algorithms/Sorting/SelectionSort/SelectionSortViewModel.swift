//
//  SelectionSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class SelectionSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var currentIndex: Int? = nil
    @Published var minIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [64, 25, 12, 22, 11]
        sortedIndices.removeAll()
        currentIndex = nil
        minIndex = nil
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            await performSelectionSort()
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performSelectionSort() async {
        let n = array.count
        
        for i in 0..<n-1 {
            guard !Task.isCancelled else { return }
            
            currentIndex = i
            minIndex = i
            try? await Task.sleep(nanoseconds: UInt64(600_000_000 / speed))
            
            for j in i+1..<n {
                guard !Task.isCancelled else { return }
                
                if array[j] < array[minIndex!] {
                    minIndex = j
                    try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
                }
            }
            
            if minIndex != i {
                array.swapAt(i, minIndex!)
                try? await Task.sleep(nanoseconds: UInt64(600_000_000 / speed))
            }
            
            sortedIndices.insert(i)
            currentStep += 1
        }
        
        sortedIndices.insert(n-1)
        currentIndex = nil
        minIndex = nil
    }
}
