//
//  SlidingWindowContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func slidingWindowContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Sliding Window maintains a fixed or variable size window that moves through the array, useful for finding subarrays with specific properties.",
            whenToUse: ["Finding maximum/minimum sum of k consecutive elements", "Substring problems", "Running averages"],
            keyIdea: "Slide a window through the array, adding new elements and removing old ones efficiently.",
            codeImplementations: [:],
            example: AlgorithmExample(inputArray: [2, 1, 5, 1, 3, 2], target: 3, expectedOutput: "Max sum: 9", explanation: "Window [5,1,3] has maximum sum"),
            steps: []
        )
    }
}
