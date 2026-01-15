//
//  ZAlgorithmQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func zAlgorithmQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What does the Z-array store?",
                options: ["Hash values", "Character counts", "Length of longest prefix match", "Pattern positions"],
                correctAnswerIndex: 2,
                explanation: "Z-array stores the length of the longest substring starting at each position that matches a prefix of the string.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Z Algorithm?",
                options: ["O(n×m)", "O(n+m)", "O(n²)", "O(m²)"],
                correctAnswerIndex: 1,
                explanation: "Z Algorithm processes the string linearly in O(n+m) time, where n is text length and m is pattern length.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What separator is typically used in Z Algorithm?",
                options: ["Space", "Comma", "$ or other unique char", "Null"],
                correctAnswerIndex: 2,
                explanation: "A unique character like $ is used to separate pattern and text to avoid false matches between pattern and text.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Z Algorithm requires preprocessing of the pattern before searching.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Z Algorithm creates a combined string (pattern$text) and computes the Z-array, which is a form of preprocessing.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Z Algorithm?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 3,
                explanation: "Z Algorithm requires O(n+m) space to store the combined string and the Z-array, where n is text length and m is pattern length.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Which concept does Z Algorithm use to achieve linear time?",
                options: [
                    "Hash functions",
                    "Z-box optimization",
                    "Binary search",
                    "Dynamic programming"
                ],
                correctAnswerIndex: 1,
                explanation: "Z Algorithm uses Z-box optimization to reuse previously computed information, avoiding redundant comparisons and achieving O(n+m) time.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Z Algorithm can find all occurrences of a pattern in the text.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Z Algorithm finds all positions where Z[i] equals the pattern length, indicating all pattern occurrences in the text.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
