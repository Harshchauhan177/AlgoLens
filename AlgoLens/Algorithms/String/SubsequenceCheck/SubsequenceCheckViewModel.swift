//
//  SubsequenceCheckViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class SubsequenceCheckViewModel: ObservableObject {
    @Published var string1Input: String = "ahbgdc"
    @Published var string2Input: String = "abc"
    @Published var isSubsequence: Bool = false
    @Published var isChecking: Bool = false
    @Published var isCompleted: Bool = false
    
    var canCheck: Bool { !isChecking && !isCompleted && !string1Input.isEmpty && !string2Input.isEmpty }
    var canReset: Bool { isChecking || isCompleted }
    
    func check() {
        isChecking = true
        isSubsequence = checkSubsequence(string2Input, string1Input)
        isCompleted = true
    }
    
    private func checkSubsequence(_ s: String, _ t: String) -> Bool {
        var sIndex = s.startIndex
        var tIndex = t.startIndex
        
        while sIndex < s.endIndex && tIndex < t.endIndex {
            if s[sIndex] == t[tIndex] {
                sIndex = s.index(after: sIndex)
            }
            tIndex = t.index(after: tIndex)
        }
        
        return sIndex == s.endIndex
    }
    
    func reset() {
        isSubsequence = false
        isChecking = false
        isCompleted = false
    }
}
