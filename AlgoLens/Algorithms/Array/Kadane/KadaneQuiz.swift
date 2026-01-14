//
//  KadaneQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func kadaneQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Kadane's Algorithm?",
                options: ["O(log n)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "Kadane's Algorithm traverses the array once with O(n) time complexity, making it much more efficient than the naive O(n²) approach.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Kadane's Algorithm can handle arrays with all negative numbers.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! If all numbers are negative, Kadane's returns the least negative number (the maximum possible sum). The algorithm works correctly for any array.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the key decision at each step in Kadane's Algorithm?",
                options: [
                    "Whether to sort the array",
                    "Whether to extend the current subarray or start a new one",
                    "Whether to use binary search",
                    "Whether to use two pointers"
                ],
                correctAnswerIndex: 1,
                explanation: "The key insight is deciding at each element: should we extend the current subarray (currentSum + element) or start fresh (element alone)?",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Kadane's Algorithm?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 0,
                explanation: "Kadane's Algorithm uses only a constant amount of extra space O(1) - just variables to track currentSum and maxSum.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Kadane's Algorithm finds the maximum sum of any subarray, not necessarily contiguous.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Kadane's Algorithm specifically finds the maximum sum of a *contiguous* subarray. For non-contiguous subarrays, you'd just sum all positive numbers.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
