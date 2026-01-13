//
//  MergeSortViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI
import Combine

@MainActor
class MergeSortViewModel: ObservableObject {
    @Published var array: [Int] = []
    @Published var isAnimating = false
    @Published var currentStep = 0
    @Published var mergingIndices: Set<Int> = []
    @Published var sortedIndices: Set<Int> = []
    @Published var speed: Double = 1.0
    
    private var animationTask: Task<Void, Never>?
    
    init() {
        resetArray()
    }
    
    func resetArray() {
        array = [38, 27, 43, 3, 9, 82, 10]
        sortedIndices.removeAll()
        mergingIndices.removeAll()
        currentStep = 0
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task {
            array = await performMergeSort(array)
            sortedIndices = Set(0..<array.count)
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        animationTask?.cancel()
        isAnimating = false
    }
    
    private func performMergeSort(_ arr: [Int]) async -> [Int] {
        guard arr.count > 1 else { return arr }
        guard !Task.isCancelled else { return arr }
        
        let mid = arr.count / 2
        let left = await performMergeSort(Array(arr[..<mid]))
        let right = await performMergeSort(Array(arr[mid...]))
        
        return await merge(left, right)
    }
    
    private func merge(_ left: [Int], _ right: [Int]) async -> [Int] {
        var result = [Int]()
        var i = 0, j = 0
        
        while i < left.count && j < right.count {
            guard !Task.isCancelled else { return result }
            
            try? await Task.sleep(nanoseconds: UInt64(400_000_000 / speed))
            
            if left[i] <= right[j] {
                result.append(left[i])
                i += 1
            } else {
                result.append(right[j])
                j += 1
            }
            
            currentStep += 1
        }
        
        result.append(contentsOf: left[i...])
        result.append(contentsOf: right[j...])
        
        return result
    }
}
