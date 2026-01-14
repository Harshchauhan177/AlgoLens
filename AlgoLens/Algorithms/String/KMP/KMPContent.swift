//
//  KMPContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct KMPContent {
    static let title = "KMP Algorithm"
    static let overview = """
    The Knuth-Morris-Pratt (KMP) algorithm is an efficient string matching algorithm that preprocesses the pattern to avoid unnecessary comparisons. It uses a prefix function (LPS array) to skip characters smartly.
    """
    
    static let algorithm = """
    1. Compute the Longest Prefix Suffix (LPS) array for the pattern
    2. Start matching from the beginning of text and pattern
    3. On mismatch, use LPS array to skip unnecessary comparisons
    4. Continue until pattern is found or text ends
    5. Record all match positions
    """
    
    static let complexity = """
    Time Complexity: O(n+m) where n is text length and m is pattern length
    Space Complexity: O(m) for storing the LPS array
    """
    
    static let useCases = """
    • Text editors for search functionality
    • DNA sequence matching in bioinformatics
    • Network intrusion detection systems
    • Large text processing where efficiency matters
    """
}
