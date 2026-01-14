//
//  AnagramCheckContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct AnagramCheckContent {
    static let title = "Anagram Check"
    static let overview = """
    An anagram is a word or phrase formed by rearranging the letters of another. This algorithm checks if two strings are anagrams by comparing character frequencies.
    """
    
    static let algorithm = """
    1. Normalize both strings (lowercase, remove spaces)
    2. Check if lengths are equal
    3. Count frequency of each character in first string
    4. Decrement counts for characters in second string
    5. If all counts are zero, strings are anagrams
    """
    
    static let complexity = """
    Time Complexity: O(n) - single pass through both strings
    Space Complexity: O(1) - fixed size character frequency map
    """
    
    static let useCases = """
    • Word games and puzzles
    • Spell checkers
    • Cryptography
    • Text processing applications
    """
}
