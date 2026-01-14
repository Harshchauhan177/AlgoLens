//
//  DutchNationalFlagContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func dutchNationalFlagContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Dutch National Flag algorithm sorts an array containing three distinct values (typically 0, 1, 2) in a single pass.",
            whenToUse: ["Sorting 0s, 1s, and 2s", "Three-way partitioning", "Color sorting problems"],
            keyIdea: "Use three pointers (low, mid, high) to partition array into three sections.",
            codeImplementations: [:],
            example: AlgorithmExample(inputArray: [2, 0, 1, 2, 1, 0], target: 0, expectedOutput: "[0,0,1,1,2,2]", explanation: "All 0s, then 1s, then 2s"),
            steps: []
        )
    }
}
