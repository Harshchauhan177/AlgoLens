//
//  NaiveStringMatchingViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class NaiveStringMatchingViewModel: ObservableObject {
    @Published var textInput: String = "ABABDABACDABABCABAB"
    @Published var patternInput: String = "ABABCABAB"
    @Published var text: String = "ABABDABACDABABCABAB"
    @Published var pattern: String = "ABABCABAB"
    
    @Published var currentTextIndex: Int = -1
    @Published var currentPatternIndex: Int = -1
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
        currentTextIndex = 0
        currentPatternIndex = 0
        matchedIndices = []
    }
    
    func nextStep() {
        guard currentTextIndex < text.count else {
            isCompleted = true
            return
        }
        
        let textArray = Array(text)
        let patternArray = Array(pattern)
        
        if currentPatternIndex < patternArray.count &&
           textArray[currentTextIndex + currentPatternIndex] == patternArray[currentPatternIndex] {
            currentPatternIndex += 1
            isMatching = true
            
            if currentPatternIndex == patternArray.count {
                matchedIndices.append(contentsOf: currentTextIndex..<(currentTextIndex + patternArray.count))
                currentTextIndex += 1
                currentPatternIndex = 0
                isMatching = false
            }
        } else {
            currentTextIndex += 1
            currentPatternIndex = 0
            isMatching = false
        }
        
        if currentTextIndex > text.count - pattern.count {
            isCompleted = true
        }
    }
    
    func reset() {
        currentTextIndex = -1
        currentPatternIndex = -1
        matchedIndices = []
        isSearching = false
        isCompleted = false
        isMatching = false
    }
}
