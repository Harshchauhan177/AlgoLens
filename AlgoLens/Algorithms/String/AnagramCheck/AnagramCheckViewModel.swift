//
//  AnagramCheckViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class AnagramCheckViewModel: ObservableObject {
    @Published var string1Input: String = "listen"
    @Published var string2Input: String = "silent"
    @Published var isAnagram: Bool = false
    @Published var isChecking: Bool = false
    @Published var isCompleted: Bool = false
    
    var canCheck: Bool { !isChecking && !isCompleted && !string1Input.isEmpty && !string2Input.isEmpty }
    var canReset: Bool { isChecking || isCompleted }
    
    func check() {
        isChecking = true
        isAnagram = checkAnagram(string1Input, string2Input)
        isCompleted = true
    }
    
    private func checkAnagram(_ s1: String, _ s2: String) -> Bool {
        let str1 = s1.lowercased().filter { $0.isLetter }
        let str2 = s2.lowercased().filter { $0.isLetter }
        
        guard str1.count == str2.count else { return false }
        
        var charCount = [Character: Int]()
        for char in str1 { charCount[char, default: 0] += 1 }
        for char in str2 {
            guard let count = charCount[char], count > 0 else { return false }
            charCount[char] = count - 1
        }
        return true
    }
    
    func reset() {
        isAnagram = false
        isChecking = false
        isCompleted = false
    }
}
