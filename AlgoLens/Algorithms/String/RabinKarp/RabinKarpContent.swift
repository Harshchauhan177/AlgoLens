//
//  RabinKarpContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct RabinKarpContent {
    static let title = "Rabin-Karp Algorithm"
    static let overview = """
    Rabin-Karp is a string matching algorithm that uses hashing to find patterns in text. It employs a rolling hash technique to efficiently compute hash values for substrings.
    """
    
    static let algorithm = """
    1. Calculate hash value of the pattern
    2. Calculate hash value of first window in text
    3. Compare hash values
    4. If match, verify character by character
    5. Use rolling hash to move to next window
    6. Repeat until end of text
    """
    
    static let complexity = """
    Time Complexity: O(n+m) average case, O(n×m) worst case
    Space Complexity: O(1) - only constant extra space
    """
    
    static let useCases = """
    • Plagiarism detection
    • Multiple pattern matching
    • DNA sequence analysis
    • Document similarity checking
    """
}
