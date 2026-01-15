//
//  LongestPalindromicSubstringViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class LongestPalindromicSubstringViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var stringInput: String = "babad"
    @Published var currentIndex: Int = -1
    @Published var currentLeft: Int = -1
    @Published var currentRight: Int = -1
    @Published var expandingIndices: [Int] = []
    @Published var longestPalindrome: String = ""
    @Published var longestStart: Int = -1
    @Published var longestEnd: Int = -1
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    @Published var isAutoRunning: Bool = false
    @Published var isExpanding: Bool = false
    
    // MARK: - Input Fields
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var stepDescription: String = ""
    @Published var finalResult: String = ""
    @Published var currentPalindromeLength: Int = 0
    @Published var maxPalindromeLength: Int = 0
    @Published var isCheckingOdd: Bool = true
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8
    
    // MARK: - Algorithm State
    private var text: String = "babad"
    private var chars: [Character] = []
    private var startPosition: Int = 0
    private var maxLen: Int = 1
    private var checkingEvenLength: Bool = false
    
    // MARK: - Initialization
    init() {
        updateFromInput()
    }
    
    // MARK: - Input Validation
    func updateFromInput() {
        inputError = nil
        
        let trimmed = stringInput.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            inputError = "String cannot be empty"
            return
        }
        
        guard trimmed.count <= 30 else {
            inputError = "String too long. Maximum 30 characters"
            return
        }
        
        text = trimmed
        chars = Array(text)
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInput()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            currentIndex = 0
            currentLeft = -1
            currentRight = -1
            expandingIndices = []
            longestPalindrome = String(chars[0])
            longestStart = 0
            longestEnd = 0
            startPosition = 0
            maxLen = 1
            maxPalindromeLength = 1
            currentPalindromeLength = 0
            isCompleted = false
            isExpanding = false
            checkingEvenLength = false
            isCheckingOdd = true
            finalResult = ""
            
            stepDescription = "Starting search at position 0, checking for odd-length palindrome"
            
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
        }
    }
    
    func nextStep() {
        guard canNext && !isCompleted && !isAutoRunning else { return }
        performStep()
    }
    
    func runComplete() {
        guard canRunComplete else { return }
        
        updateFromInput()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isSearching = true
            isAutoRunning = true
            currentIndex = 0
            currentLeft = -1
            currentRight = -1
            expandingIndices = []
            longestPalindrome = String(chars[0])
            longestStart = 0
            longestEnd = 0
            startPosition = 0
            maxLen = 1
            maxPalindromeLength = 1
            currentPalindromeLength = 0
            isCompleted = false
            isExpanding = false
            checkingEvenLength = false
            isCheckingOdd = true
            finalResult = ""
            
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
        }
        
        autoRunTask = Task {
            while currentIndex < chars.count && !isCompleted {
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    performStep()
                }
                
                if isCompleted {
                    break
                }
            }
            
            await MainActor.run {
                isAutoRunning = false
                canReset = true
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = -1
            currentLeft = -1
            currentRight = -1
            expandingIndices = []
            longestPalindrome = ""
            longestStart = -1
            longestEnd = -1
            isSearching = false
            isCompleted = false
            isAutoRunning = false
            isExpanding = false
            stepDescription = ""
            finalResult = ""
            currentPalindromeLength = 0
            maxPalindromeLength = 0
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard currentIndex < chars.count else {
            completeSearch()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if !checkingEvenLength {
                // Check odd-length palindrome
                isCheckingOdd = true
                let len1 = expandAroundCenter(currentIndex, currentIndex)
                
                if len1 > maxLen {
                    maxLen = len1
                    startPosition = currentIndex - (len1 - 1) / 2
                    longestStart = startPosition
                    longestEnd = startPosition + len1 - 1
                    maxPalindromeLength = len1
                    let startIdx = text.index(text.startIndex, offsetBy: startPosition)
                    let endIdx = text.index(startIdx, offsetBy: len1)
                    longestPalindrome = String(text[startIdx..<endIdx])
                    stepDescription = "✓ Found longer palindrome '\(longestPalindrome)' at center \(currentIndex) (odd-length: \(len1))"
                } else {
                    stepDescription = "Checked odd-length at center \(currentIndex), length: \(len1) (not longer than current max: \(maxLen))"
                }
                
                checkingEvenLength = true
                isCheckingOdd = false
            } else {
                // Check even-length palindrome
                isCheckingOdd = false
                let len2 = expandAroundCenter(currentIndex, currentIndex + 1)
                
                if len2 > maxLen {
                    maxLen = len2
                    startPosition = currentIndex - (len2 - 1) / 2
                    longestStart = startPosition
                    longestEnd = startPosition + len2 - 1
                    maxPalindromeLength = len2
                    let startIdx = text.index(text.startIndex, offsetBy: startPosition)
                    let endIdx = text.index(startIdx, offsetBy: len2)
                    longestPalindrome = String(text[startIdx..<endIdx])
                    stepDescription = "✓ Found longer palindrome '\(longestPalindrome)' at centers \(currentIndex),\(currentIndex+1) (even-length: \(len2))"
                } else {
                    stepDescription = "Checked even-length at centers \(currentIndex),\(currentIndex+1), length: \(len2) (not longer than current max: \(maxLen))"
                }
                
                checkingEvenLength = false
                currentIndex += 1
                isCheckingOdd = true
            }
        }
        
        if currentIndex >= chars.count {
            completeSearch()
        }
    }
    
    private func expandAroundCenter(_ left: Int, _ right: Int) -> Int {
        var l = left, r = right
        expandingIndices = []
        currentLeft = l
        currentRight = r
        
        while l >= 0 && r < chars.count && chars[l] == chars[r] {
            expandingIndices.append(l)
            if l != r {
                expandingIndices.append(r)
            }
            l -= 1
            r += 1
        }
        
        currentPalindromeLength = r - l - 1
        return r - l - 1
    }
    
    private func completeSearch() {
        isCompleted = true
        canNext = false
        isExpanding = false
        
        finalResult = "Success! Longest palindrome is '\(longestPalindrome)' with length \(maxLen)"
        stepDescription = ""
        
        if !isAutoRunning {
            canReset = true
        }
    }
    
    // MARK: - Character State
    func characterState(at index: Int) -> CharacterState {
        if longestStart >= 0 && longestEnd >= 0 && index >= longestStart && index <= longestEnd {
            return .longestPalindrome
        } else if expandingIndices.contains(index) {
            return .expanding
        } else if index == currentIndex && isCheckingOdd && !checkingEvenLength {
            return .currentCenter
        } else if !isCheckingOdd && checkingEvenLength && (index == currentIndex || index == currentIndex + 1) {
            return .currentCenter
        }
        return .normal
    }
    
    enum CharacterState {
        case normal
        case currentCenter
        case expanding
        case longestPalindrome
    }
}
