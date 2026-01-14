//
//  PrefixSumContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func prefixSumContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Prefix Sum precomputes cumulative sums to answer range sum queries in O(1) time.",
            whenToUse: ["Range sum queries", "Subarray sum problems", "Finding equilibrium index"],
            keyIdea: "Build an array where prefix[i] = sum of all elements from 0 to i.",
            codeImplementations: [:],
            example: AlgorithmExample(inputArray: [1, 2, 3, 4, 5], target: 0, expectedOutput: "Prefix: [1,3,6,10,15]", explanation: "Each element is sum of all previous"),
            steps: []
        )
    }
}
