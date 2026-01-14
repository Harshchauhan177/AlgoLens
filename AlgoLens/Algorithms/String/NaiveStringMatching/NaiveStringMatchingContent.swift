//
//  NaiveStringMatchingContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct NaiveStringMatchingContent {
    static let title = "Naive String Matching"
    static let overview = """
    The Naive String Matching algorithm is the simplest approach to find all occurrences of a pattern in a text. It checks for the pattern at each position in the text by comparing characters one by one.
    """
    
    static let algorithm = """
    1. Start from the first character of the text
    2. Try to match the pattern from the current position
    3. If all characters match, record the position
    4. Move to the next position in text
    5. Repeat until the end of text is reached
    """
    
    static let complexity = """
    Time Complexity: O(n×m) where n is text length and m is pattern length
    Space Complexity: O(1) - only constant extra space needed
    """
    
    static let useCases = """
    • Simple text search in small documents
    • Educational purposes to understand pattern matching
    • When pattern length is very small
    • Quick implementation without preprocessing
    """
}
