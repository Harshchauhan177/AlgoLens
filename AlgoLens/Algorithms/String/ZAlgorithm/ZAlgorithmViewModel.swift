//
//  ZAlgorithmViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class ZAlgorithmViewModel: ObservableObject {
    @Published var textInput: String = "AABAACAADAABAAABAA"
    @Published var patternInput: String = "AABA"
    @Published var text: String = "AABAACAADAABAAABAA"
    @Published var pattern: String = "AABA"
    @Published var currentIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isMatching: Bool = false
    
    var canStart: Bool { !isSearching && !isCompleted && !text.isEmpty && !pattern.isEmpty }
    var canNext: Bool { isSearching && !isCompleted }
    var canReset: Bool { isSearching || isCompleted }
    
    func start() {
        text = textInput
        pattern = patternInput
        isSearching = true
        currentIndex = 0
        matchedIndices = []
    }
    
    func nextStep() {
        guard currentIndex < text.count else { isCompleted = true; return }
        let combined = pattern + "$" + text
        // Simplified Z-array simulation
        if currentIndex <= text.count - pattern.count {
            let startIdx = text.index(text.startIndex, offsetBy: currentIndex)
            let endIdx = text.index(startIdx, offsetBy: pattern.count)
            if String(text[startIdx..<endIdx]) == pattern {
                matchedIndices.append(contentsOf: currentIndex..<(currentIndex + pattern.count))
            }
        }
        currentIndex += 1
        if currentIndex > text.count - pattern.count { isCompleted = true }
    }
    
    func reset() {
        currentIndex = -1
        matchedIndices = []
        isSearching = false
        isCompleted = false
        isMatching = false
    }
}
