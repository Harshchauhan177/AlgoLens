//
//  CombinationsQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func combinationsQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the formula for C(n, k)?",
                options: ["n! / k!", "n! / (k! × (n-k)!)", "n^k", "k^n"],
                correctAnswerIndex: 1,
                explanation: "The number of combinations is C(n,k) = n! / (k! × (n-k)!), also known as the binomial coefficient.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does order matter in combinations?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. In combinations, order doesn't matter. [1,2] and [2,1] are considered the same combination.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many ways can you choose 2 items from 5 items?",
                options: ["5", "10", "20", "25"],
                correctAnswerIndex: 1,
                explanation: "C(5,2) = 5! / (2! × 3!) = 120 / (2 × 6) = 10 combinations.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of generating all combinations?",
                options: ["O(n)", "O(n²)", "O(C(n,k))", "O(n!)"],
                correctAnswerIndex: 2,
                explanation: "The time complexity is O(C(n,k)) as we generate exactly C(n,k) combinations.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What technique prevents duplicate combinations in different orders?",
                options: ["Sorting", "Using a start index", "Hashing", "Dynamic Programming"],
                correctAnswerIndex: 1,
                explanation: "Using a start index ensures we only pick elements forward, preventing duplicates like [1,2] and [2,1].",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "C(n, 0) always equals 1.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. There is exactly one way to choose 0 items from n items: choose nothing.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is C(5, 5)?",
                options: ["0", "1", "5", "25"],
                correctAnswerIndex: 1,
                explanation: "C(5,5) = 1. There is only one way to choose all 5 items from 5 items.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
