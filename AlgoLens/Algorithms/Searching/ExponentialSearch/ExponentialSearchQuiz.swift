//
//  ExponentialSearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func exponentialSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Exponential Search combines which two search techniques?",
                options: [
                    "Linear and Jump Search",
                    "Linear and Binary Search",
                    "Binary and Jump Search",
                    "Interpolation and Binary Search"
                ],
                correctAnswerIndex: 1,
                explanation: "Exponential Search first uses exponential jumps (linear approach) then applies Binary Search on the identified range.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Exponential Search is useful for unbounded or infinite arrays.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Exponential Search is particularly useful when the array size is unknown or unbounded.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Exponential Search?",
                options: ["O(1)", "O(log n)", "O(√n)", "O(n)"],
                correctAnswerIndex: 1,
                explanation: "Exponential Search has O(log n) time complexity, same as Binary Search.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "How does Exponential Search find the range to search?",
                options: [
                    "By dividing array in half",
                    "By doubling the index (1, 2, 4, 8...)",
                    "By using square root jumps",
                    "By random selection"
                ],
                correctAnswerIndex: 1,
                explanation: "Exponential Search doubles the index exponentially (1, 2, 4, 8, 16...) to quickly find the range containing the target.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Exponential Search is better than Binary Search when target is near the beginning.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Exponential Search finds elements near the beginning faster as it starts with small jumps.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
