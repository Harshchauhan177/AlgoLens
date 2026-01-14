//
//  MooreVotingContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func mooreVotingContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Moore's Voting Algorithm finds the majority element (appearing more than n/2 times) in linear time with constant space.",
            whenToUse: ["Finding majority element", "Voting systems", "Frequency problems"],
            keyIdea: "Maintain a candidate and count. Cancel out non-candidate elements.",
            codeImplementations: [:],
            example: AlgorithmExample(inputArray: [2, 2, 1, 1, 1, 2, 2], target: 0, expectedOutput: "Majority: 2", explanation: "2 appears 4 times out of 7"),
            steps: []
        )
    }
}
