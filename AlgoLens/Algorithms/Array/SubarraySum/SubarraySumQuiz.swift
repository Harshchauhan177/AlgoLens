//
//  SubarraySumQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func subarraySumQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the Subarray Sum algorithm using hashing?",
                options: ["O(1)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "Using hash map for prefix sums allows us to find subarrays in O(n) time with O(1) lookups.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Subarray Sum with hashing is faster than the brute force approach.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Hashing gives O(n) time vs O(n²) for brute force checking all subarrays.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Subarray Sum using prefix sum hashing?",
                options: ["O(1)", "O(n)", "O(log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "We store prefix sums in a hash map, which can grow up to O(n) in the worst case.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Why do we initialize the hash map with {0: -1}?",
                options: [
                    "To handle errors",
                    "To handle subarrays starting from index 0",
                    "To improve performance",
                    "It's not necessary"
                ],
                correctAnswerIndex: 1,
                explanation: "Initializing with {0: -1} allows us to find subarrays that start from index 0 and sum to the target.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The algorithm can find subarrays in unsorted arrays.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Unlike Two Pointer, this algorithm works on both sorted and unsorted arrays.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What do we store in the hash map?",
                options: [
                    "Array values and indices",
                    "Prefix sums and their indices",
                    "Target sum and differences",
                    "Start and end indices"
                ],
                correctAnswerIndex: 1,
                explanation: "We store prefix sums as keys and their corresponding indices as values.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "When we find (current_sum - target) in the map, what does it mean?",
                options: [
                    "No subarray exists",
                    "A subarray with target sum exists",
                    "We need to continue searching",
                    "The array is invalid"
                ],
                correctAnswerIndex: 1,
                explanation: "If (current_sum - target) exists, the subarray from that index+1 to current index has the target sum.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "This algorithm can handle arrays with negative numbers.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! The prefix sum hashing approach works with positive, negative, and zero values.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
