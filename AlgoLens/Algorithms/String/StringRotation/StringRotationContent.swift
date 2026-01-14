//
//  StringRotationContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

struct StringRotationContent {
    static let title = "String Rotation"
    static let overview = """
    This algorithm checks if one string is a rotation of another. A rotation means moving some characters from the beginning to the end. For example, 'waterbottle' rotated becomes 'erbottlewat'.
    """
    
    static let algorithm = """
    1. Check if both strings have equal length
    2. If lengths differ, they can't be rotations
    3. Concatenate first string with itself
    4. Check if second string is substring of concatenation
    5. If found, second string is a rotation
    """
    
    static let complexity = """
    Time Complexity: O(n) - substring search in 2n length string
    Space Complexity: O(n) - concatenated string storage
    """
    
    static let useCases = """
    • Circular buffer analysis
    • String pattern matching
    • Data structure problems
    • Interview questions
    """
}
