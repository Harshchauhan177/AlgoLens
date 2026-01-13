//
//  FibonacciSearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func fibonacciSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Fibonacci Search uses Fibonacci numbers to divide the array.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Fibonacci Search divides the array using Fibonacci numbers instead of exact halves.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What advantage does Fibonacci Search have over Binary Search?",
                options: [
                    "Faster execution",
                    "Works on unsorted arrays",
                    "Avoids division operations",
                    "Uses less memory"
                ],
                correctAnswerIndex: 2,
                explanation: "Fibonacci Search avoids costly division operations, using only addition and subtraction.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Fibonacci Search?",
                options: ["O(1)", "O(log n)", "O(√n)", "O(n)"],
                correctAnswerIndex: 1,
                explanation: "Fibonacci Search has O(log n) time complexity, similar to Binary Search.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Fibonacci Search divides the array into equal halves like Binary Search.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Fibonacci Search divides the array into unequal parts using Fibonacci ratios, not equal halves.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the Fibonacci sequence used in Fibonacci Search?",
                options: [
                    "1, 2, 3, 4, 5...",
                    "0, 1, 1, 2, 3, 5, 8...",
                    "2, 4, 8, 16, 32...",
                    "1, 4, 9, 16, 25..."
                ],
                correctAnswerIndex: 1,
                explanation: "The Fibonacci sequence (0, 1, 1, 2, 3, 5, 8, 13...) where each number is the sum of the two preceding ones.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
