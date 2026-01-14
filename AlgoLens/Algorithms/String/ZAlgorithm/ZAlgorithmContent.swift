//
//  ZAlgorithmContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct ZAlgorithmContent {
    static let title = "Z Algorithm"
    static let overview = """
    The Z Algorithm is used for pattern matching that computes the Z-array, where each element represents the length of the longest substring starting from that position which is also a prefix of the string.
    """
    
    static let algorithm = """
    1. Concatenate pattern and text with a separator
    2. Compute Z-array for the concatenated string
    3. Z-array[i] gives longest match starting at position i
    4. Find positions where Z-value equals pattern length
    5. Those positions indicate pattern matches
    """
    
    static let complexity = """
    Time Complexity: O(n+m) linear time processing
    Space Complexity: O(n+m) for Z-array storage
    """
    
    static let useCases = """
    • Fast pattern matching in large texts
    • Bioinformatics for DNA sequence matching
    • Text compression algorithms
    • Multiple pattern searches
    """
}
