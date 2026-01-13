//
//  InsertionSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class InsertionSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var keyIndex: Int? = nil
    @Published var comparingIndex: Int? = nil
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [12, 11, 13, 5, 6]
        sortedIndices = [0]
        keyIndex = nil
        comparingIndex = nil
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            await performInsertionSort()
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performInsertionSort() async {
        let n = array.count
        
        for i in 1..<n {
            guard !Task.isCancelled else { return }
            
            let key = array[i]
            keyIndex = i
            try? await Task.sleep(nanoseconds: UInt64(600_000_000 / speed))
            
            var j = i - 1
            
            while j >= 0 && array[j] > key {
                guard !Task.isCancelled else { return }
                
                comparingIndex = j
                try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
                
                array[j + 1] = array[j]
                j -= 1
                
                try? await Task.sleep(nanoseconds: UInt64(300_000_000 / speed))
            }
            
            array[j + 1] = key
            sortedIndices.insert(i)
            try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
            
            currentStep += 1
        }
        
        keyIndex = nil
        comparingIndex = nil
    }
}
