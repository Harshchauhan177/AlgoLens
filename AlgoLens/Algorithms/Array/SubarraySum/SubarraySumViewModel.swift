//
//  SubarraySumViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class SubarraySumViewModel: ObservableObject {
    @Published var array: [Int] = [1, 2, 3, 4, 5]
    @Published var targetSum: Int = 9
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var arrayInput: String = "1,2,3,4,5"
    @Published var targetInput: String = "9"
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var resultInfo: String = ""
    
    func start() {
        isRunning = true
        canStart = false
        var sum = 0
        var prefixSums: [Int: Int] = [0: -1]
        
        for (i, num) in array.enumerated() {
            sum += num
            if let startIndex = prefixSums[sum - targetSum] {
                resultInfo = "Subarray found: indices \(startIndex + 1) to \(i)"
                isCompleted = true
                return
            }
            prefixSums[sum] = i
        }
        resultInfo = "No subarray found with sum \(targetSum)"
        isCompleted = true
    }
    
    func reset() {
        isRunning = false
        isCompleted = false
        canStart = true
        canNext = false
        resultInfo = ""
    }
}
