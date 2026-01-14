//
//  KMPViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class KMPViewModel: ObservableObject {
    @Published var textInput: String = "ABABDABACDABABCABAB"
    @Published var patternInput: String = "ABABCABAB"
    @Published var text: String = "ABABDABACDABABCABAB"
    @Published var pattern: String = "ABABCABAB"
    
    @Published var currentTextIndex: Int = -1
    @Published var currentPatternIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var lps: [Int] = []
    
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
        currentTextIndex = 0
        currentPatternIndex = 0
        matchedIndices = []
        computeLPSArray()
    }
    
    private func computeLPSArray() {
        let patternArray = Array(pattern)
        lps = Array(repeating: 0, count: patternArray.count)
        var length = 0
        var i = 1
        
        while i < patternArray.count {
            if patternArray[i] == patternArray[length] {
                length += 1
                lps[i] = length
                i += 1
            } else {
                if length != 0 {
                    length = lps[length - 1]
                } else {
                    lps[i] = 0
                    i += 1
                }
            }
        }
    }
    
    func nextStep() {
        let textArray = Array(text)
        let patternArray = Array(pattern)
        
        guard currentTextIndex < textArray.count else {
            isCompleted = true
            return
        }
        
        if patternArray[currentPatternIndex] == textArray[currentTextIndex] {
            currentPatternIndex += 1
            currentTextIndex += 1
            isMatching = true
        }
        
        if currentPatternIndex == patternArray.count {
            matchedIndices.append(contentsOf: (currentTextIndex - currentPatternIndex)..<currentTextIndex)
            currentPatternIndex = lps[currentPatternIndex - 1]
            isMatching = false
        } else if currentTextIndex < textArray.count && patternArray[currentPatternIndex] != textArray[currentTextIndex] {
            if currentPatternIndex != 0 {
                currentPatternIndex = lps[currentPatternIndex - 1]
            } else {
                currentTextIndex += 1
            }
            isMatching = false
        }
        
        if currentTextIndex >= textArray.count {
            isCompleted = true
        }
    }
    
    func reset() {
        currentTextIndex = -1
        currentPatternIndex = -1
        matchedIndices = []
        lps = []
        isSearching = false
        isCompleted = false
        isMatching = false
    }
}
