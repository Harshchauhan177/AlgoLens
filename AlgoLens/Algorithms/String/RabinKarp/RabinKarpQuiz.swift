//
//  RabinKarpQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func rabinKarpQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What technique does Rabin-Karp use for efficient pattern matching?",
                options: ["Binary search", "Hashing", "Dynamic programming", "Backtracking"],
                correctAnswerIndex: 1,
                explanation: "Rabin-Karp uses rolling hash technique to efficiently compare substrings.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the average time complexity of Rabin-Karp?",
                options: ["O(n×m)", "O(n+m)", "O(n log m)", "O(m log n)"],
                correctAnswerIndex: 1,
                explanation: "In average case, Rabin-Karp runs in O(n+m) time using hash comparisons.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Why do we need to verify matches character by character?",
                options: ["To improve speed", "Due to hash collisions", "To save memory", "It's optional"],
                correctAnswerIndex: 1,
                explanation: "Hash collisions can occur, so we verify actual character match when hashes are equal.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
