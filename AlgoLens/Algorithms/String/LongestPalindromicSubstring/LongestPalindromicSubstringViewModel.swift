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
    @Published var stringInput: String = "babad"
    @Published var longestPalindrome: String = ""
    @Published var isSearching: Bool = false
    @Published var isCompleted: Bool = false
    
    var canStart: Bool { !isSearching && !isCompleted && !stringInput.isEmpty }
    var canReset: Bool { isSearching || isCompleted }
    
    func start() {
        isSearching = true
        longestPalindrome = findLongestPalindrome(stringInput)
        isCompleted = true
    }
    
    private func findLongestPalindrome(_ s: String) -> String {
        guard !s.isEmpty else { return "" }
        let chars = Array(s)
        var start = 0, maxLen = 1
        
        for i in 0..<chars.count {
            let len1 = expandAroundCenter(chars, i, i)
            let len2 = expandAroundCenter(chars, i, i + 1)
            let len = max(len1, len2)
            if len > maxLen {
                maxLen = len
                start = i - (len - 1) / 2
            }
        }
        
        let startIdx = s.index(s.startIndex, offsetBy: start)
        let endIdx = s.index(startIdx, offsetBy: maxLen)
        return String(s[startIdx..<endIdx])
    }
    
    private func expandAroundCenter(_ chars: [Character], _ left: Int, _ right: Int) -> Int {
        var l = left, r = right
        while l >= 0 && r < chars.count && chars[l] == chars[r] {
            l -= 1
            r += 1
        }
        return r - l - 1
    }
    
    func reset() {
        longestPalindrome = ""
        isSearching = false
        isCompleted = false
    }
}
