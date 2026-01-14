//
//  PrefixSumQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func prefixSumQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity for building a prefix sum array?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 2,
                explanation: "Building the prefix sum array requires one pass through the array, taking O(n) time. But this preprocessing enables O(1) queries!",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "After building prefix sum, range queries can be answered in O(1) time.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Once the prefix sum array is built, any range query [L..R] can be answered in constant time using: prefix[R] - prefix[L-1].",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How do you calculate the sum of elements from index L to R using prefix sum?",
                options: [
                    "prefix[R] + prefix[L]",
                    "prefix[R] - prefix[L-1]",
                    "prefix[L] - prefix[R]",
                    "prefix[R] * prefix[L]"
                ],
                correctAnswerIndex: 1,
                explanation: "Range sum [L..R] = prefix[R] - prefix[L-1]. Special case: if L=0, just return prefix[R].",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of the prefix sum technique?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 2,
                explanation: "We need O(n) extra space to store the prefix sum array. This trade-off gives us O(1) query time.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Prefix sum is only useful for sum queries, not other operations.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Prefix sum can be generalized to other associative operations like XOR, multiplication, min/max (segment trees), and more.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
