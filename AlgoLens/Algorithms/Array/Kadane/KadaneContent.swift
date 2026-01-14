//
//  KadaneContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func kadaneContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Kadane's Algorithm finds the maximum sum of a contiguous subarray in linear time.",
            whenToUse: ["Finding maximum sum subarray", "Stock profit problems", "Dynamic programming on arrays"],
            keyIdea: "At each position, decide whether to extend current subarray or start new one.",
            codeImplementations: [:],
            example: AlgorithmExample(inputArray: [-2, 1, -3, 4, -1, 2, 1, -5, 4], target: 0, expectedOutput: "Max sum: 6", explanation: "Subarray [4,-1,2,1] has sum 6"),
            steps: []
        )
    }
}
