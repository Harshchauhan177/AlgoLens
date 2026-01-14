//
//  LongestPalindromicSubstringContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct LongestPalindromicSubstringContent {
    static let title = "Longest Palindromic Substring"
    static let overview = """
    This algorithm finds the longest substring that reads the same forwards and backwards. It uses the expand around center technique to check all possible palindromes.
    """
    
    static let algorithm = """
    1. For each character, treat it as a center
    2. Expand outward while characters match
    3. Check both odd and even length palindromes
    4. Track the longest palindrome found
    5. Return the longest palindromic substring
    """
    
    static let complexity = """
    Time Complexity: O(n²) - expand around each center
    Space Complexity: O(1) - constant extra space
    """
    
    static let useCases = """
    • Text processing and analysis
    • DNA sequence analysis
    • Pattern recognition
    • Competitive programming problems
    """
}
