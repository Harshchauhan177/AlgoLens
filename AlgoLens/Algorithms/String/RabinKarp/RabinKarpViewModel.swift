//
//  RabinKarpViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class RabinKarpViewModel: ObservableObject {
    @Published var textInput: String = "GEEKSFORGEEKS"
    @Published var patternInput: String = "GEEK"
    @Published var text: String = "GEEKSFORGEEKS"
    @Published var pattern: String = "GEEK"
    @Published var currentIndex: Int = -1
    @Published var matchedIndices: [Int] = []
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isMatching: Bool = false
    
    var canStart: Bool { !isSearching && !isCompleted && !text.isEmpty && !pattern.isEmpty }
    var canNext: Bool { isSearching && !isCompleted }
    var canReset: Bool { isSearching || isCompleted }
    
    private let prime = 101
    private var patternHash: Int = 0
    private var textHash: Int = 0
    
    func start() {
        text = textInput
        pattern = patternInput
        isSearching = true
        currentIndex = 0
        matchedIndices = []
        patternHash = calculateHash(pattern)
        textHash = calculateHash(String(text.prefix(pattern.count)))
    }
    
    private func calculateHash(_ str: String) -> Int {
        var hash = 0
        for char in str {
            hash = (hash * 256 + Int(char.asciiValue ?? 0)) % prime
        }
        return hash
    }
    
    func nextStep() {
        guard currentIndex <= text.count - pattern.count else {
            isCompleted = true
            return
        }
        
        if textHash == patternHash {
            let startIdx = text.index(text.startIndex, offsetBy: currentIndex)
            let endIdx = text.index(startIdx, offsetBy: pattern.count)
            if String(text[startIdx..<endIdx]) == pattern {
                matchedIndices.append(contentsOf: currentIndex..<(currentIndex + pattern.count))
                isMatching = true
            }
        }
        
        currentIndex += 1
        if currentIndex <= text.count - pattern.count {
            // Rolling hash
            let oldChar = text[text.index(text.startIndex, offsetBy: currentIndex - 1)]
            let newChar = text[text.index(text.startIndex, offsetBy: currentIndex + pattern.count - 1)]
            textHash = ((textHash - Int(oldChar.asciiValue ?? 0) * Int(pow(256.0, Double(pattern.count - 1)))) * 256 + Int(newChar.asciiValue ?? 0)) % prime
            if textHash < 0 { textHash += prime }
        } else {
            isCompleted = true
        }
        isMatching = false
    }
    
    func reset() {
        currentIndex = -1
        matchedIndices = []
        isSearching = false
        isCompleted = false
        isMatching = false
    }
}
