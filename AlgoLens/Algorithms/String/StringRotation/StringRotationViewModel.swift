//
//  StringRotationViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class StringRotationViewModel: ObservableObject {
    @Published var string1Input: String = "waterbottle"
    @Published var string2Input: String = "erbottlewat"
    @Published var isRotation: Bool = false
    @Published var isChecking: Bool = false
    @Published var isCompleted: Bool = false
    
    var canCheck: Bool { !isChecking && !isCompleted && !string1Input.isEmpty && !string2Input.isEmpty }
    var canReset: Bool { isChecking || isCompleted }
    
    func check() {
        isChecking = true
        isRotation = checkRotation(string1Input, string2Input)
        isCompleted = true
    }
    
    private func checkRotation(_ s1: String, _ s2: String) -> Bool {
        guard s1.count == s2.count && !s1.isEmpty else { return false }
        let concatenated = s1 + s1
        return concatenated.contains(s2)
    }
    
    func reset() {
        isRotation = false
        isChecking = false
        isCompleted = false
    }
}
