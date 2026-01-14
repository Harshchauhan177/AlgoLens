//
//  NaiveStringMatchingQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func naiveStringMatchingQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Naive String Matching?",
                options: ["O(n)", "O(m)", "O(n×m)", "O(n+m)"],
                correctAnswerIndex: 2,
                explanation: "The algorithm compares the pattern at each position in the text, resulting in O(n×m) complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Naive String Matching?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 0,
                explanation: "The algorithm uses only constant extra space for indices and comparisons.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "When is Naive String Matching most efficient?",
                options: [
                    "When pattern length is very large",
                    "When text length is very large",
                    "When pattern length is very small",
                    "It's always efficient"
                ],
                correctAnswerIndex: 2,
                explanation: "Naive approach works best when the pattern is small, reducing the multiplicative factor.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
