//
//  SubsequenceCheckContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct SubsequenceCheckContent {
    static let title = "Subsequence Check"
    static let overview = """
    A subsequence is a sequence that can be derived from another sequence by deleting some or no elements without changing the order of remaining elements. This algorithm checks if one string is a subsequence of another.
    """
    
    static let algorithm = """
    1. Use two pointers, one for each string
    2. Iterate through the main string
    3. When characters match, advance both pointers
    4. When they don't match, only advance main pointer
    5. If subsequence pointer reaches end, it's a valid subsequence
    """
    
    static let complexity = """
    Time Complexity: O(n) - single pass through main string
    Space Complexity: O(1) - only two pointers used
    """
    
    static let useCases = """
    • Pattern matching in DNA sequences
    • Text search and filtering
    • Log analysis
    • Stream processing
    """
}
