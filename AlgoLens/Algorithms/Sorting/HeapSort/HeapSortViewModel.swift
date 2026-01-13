//
//  HeapSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class HeapSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var heapifyingIndices: Set<Int> = []
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [12, 11, 13, 5, 6, 7]
        sortedIndices.removeAll()
        heapifyingIndices.removeAll()
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            await performHeapSort()
            sortedIndices = Set(0..<array.count)
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performHeapSort() async {
        let n = array.count
        
        // Build max heap
        for i in stride(from: n/2 - 1, through: 0, by: -1) {
            guard !Task.isCancelled else { return }
            await heapify(n: n, i: i)
        }
        
        // Extract elements from heap
        for i in stride(from: n-1, through: 1, by: -1) {
            guard !Task.isCancelled else { return }
            
            array.swapAt(0, i)
            sortedIndices.insert(i)
            try? await Task.sleep(nanoseconds: UInt64(500_000_000 / speed))
            
            await heapify(n: i, i: 0)
        }
        
        sortedIndices.insert(0)
    }
    
    private func heapify(n: Int, i: Int) async {
        guard !Task.isCancelled else { return }
        
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        heapifyingIndices = Set([i, left, right].filter { $0 < n })
        try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
        
        if left < n && array[left] > array[largest] {
            largest = left
        }
        
        if right < n && array[right] > array[largest] {
            largest = right
        }
        
        if largest != i {
            array.swapAt(i, largest)
            try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
            await heapify(n: n, i: largest)
        }
        
        heapifyingIndices.removeAll()
        currentStep += 1
    }
}
