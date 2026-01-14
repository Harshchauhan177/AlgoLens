//
//  DutchNationalFlagViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class DutchNationalFlagViewModel: ObservableObject {
    @Published var array: [Int] = [2, 0, 1, 2, 1, 0, 1, 2, 0]
    @Published var low: Int = 0
    @Published var mid: Int = 0
    @Published var high: Int = 0
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var arrayInput: String = "2,0,1,2,1,0,1,2,0"
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var stepInfo: String = ""
    
    func start() {
        low = 0
        mid = 0
        high = array.count - 1
        isRunning = true
        canStart = false
        canNext = true
        stepInfo = "Sorting 0s, 1s, and 2s"
    }
    
    func nextStep() {
        guard mid <= high else {
            isCompleted = true
            canNext = false
            stepInfo = "Array sorted!"
            return
        }
        
        if array[mid] == 0 {
            array.swapAt(low, mid)
            low += 1
            mid += 1
        } else if array[mid] == 1 {
            mid += 1
        } else {
            array.swapAt(mid, high)
            high -= 1
        }
        stepInfo = "Low: \(low), Mid: \(mid), High: \(high)"
    }
    
    func reset() {
        array = [2, 0, 1, 2, 1, 0, 1, 2, 0]
        low = 0
        mid = 0
        high = 0
        isRunning = false
        isCompleted = false
        canStart = true
        canNext = false
        stepInfo = ""
    }
}
