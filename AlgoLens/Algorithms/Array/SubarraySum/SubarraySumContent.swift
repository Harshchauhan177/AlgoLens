//
//  SubarraySumContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func subarraySumContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Subarray Sum uses hashing to find subarrays with a given sum in linear time.",
            whenToUse: ["Finding subarrays with target sum", "Prefix sum + hashing problems", "Continuous subarray problems"],
            keyIdea: "Store prefix sums in hash map. If (current_sum - target) exists, subarray found.",
            codeImplementations: [:],
            example: AlgorithmExample(inputArray: [1, 2, 3, 4, 5], target: 9, expectedOutput: "Subarray [2,3,4]", explanation: "Elements from index 1 to 3 sum to 9"),
            steps: []
        )
    }
}
