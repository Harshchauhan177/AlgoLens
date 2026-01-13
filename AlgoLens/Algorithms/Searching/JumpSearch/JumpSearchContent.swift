//
//  JumpSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func jumpSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Jump Search works by jumping ahead by fixed steps in a sorted array, then performing a linear search in the identified block.",
            whenToUse: [
                "When array is sorted",
                "For medium-sized sorted datasets",
                "When binary search is not suitable",
                "Better than linear for sorted arrays"
            ],
            keyIdea: "Jump ahead by √n steps to find the block containing the target, then search linearly within that block.",
            codeImplementations: [
                .pseudocode: """
                function jumpSearch(array, target):
                    n = length(array)
                    step = sqrt(n)
                    prev = 0
                    while array[min(step, n)-1] < target:
                        prev = step
                        step += sqrt(n)
                        if prev >= n:
                            return -1
                    while array[prev] < target:
                        prev++
                        if prev == min(step, n):
                            return -1
                    if array[prev] == target:
                        return prev
                    return -1
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Jump by √6 ≈ 2 steps. Find block [4,6,7], then linear search finds 6."
            ),
            steps: [
                AlgorithmStep(title: "Calculate Jump", description: "Calculate optimal jump size (√n)", type: .start),
                AlgorithmStep(title: "Jump Ahead", description: "Jump ahead by step size", type: .process),
                AlgorithmStep(title: "Check Block", description: "Check if target is in current block", type: .decision),
                AlgorithmStep(title: "Continue", description: "If target is larger, continue jumping", type: .process),
                AlgorithmStep(title: "Linear Search", description: "Once block is identified, do linear search", type: .process),
                AlgorithmStep(title: "Result", description: "Return index if found, -1 otherwise", type: .end)
            ]
        )
    }
}
