//
//  MooreVotingViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class MooreVotingViewModel: ObservableObject {
    @Published var array: [Int] = [2, 2, 1, 1, 1, 2, 2]
    @Published var candidate: Int = 0
    @Published var count: Int = 0
    @Published var currentIndex: Int = -1
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var arrayInput: String = "2,2,1,1,1,2,2"
    @Published var inputError: String?
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var stepInfo: String = ""
    
    func updateFromInputs() {
        let components = arrayInput.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard !components.isEmpty else { inputError = "Invalid input"; return }
        array = components
    }
    
    func start() {
        updateFromInputs()
        currentIndex = 0
        candidate = array[0]
        count = 1
        isRunning = true
        canStart = false
        canNext = true
        stepInfo = "Candidate: \(candidate), Count: \(count)"
    }
    
    func nextStep() {
        guard currentIndex < array.count - 1 else {
            isCompleted = true
            canNext = false
            stepInfo = "Majority element: \(candidate)"
            return
        }
        currentIndex += 1
        if array[currentIndex] == candidate {
            count += 1
        } else {
            count -= 1
            if count == 0 {
                candidate = array[currentIndex]
                count = 1
            }
        }
        stepInfo = "Candidate: \(candidate), Count: \(count)"
    }
    
    func reset() {
        currentIndex = -1
        candidate = 0
        count = 0
        isRunning = false
        isCompleted = false
        canStart = true
        canNext = false
        stepInfo = ""
    }
}
