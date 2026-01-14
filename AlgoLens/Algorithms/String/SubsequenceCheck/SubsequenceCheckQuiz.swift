//
//  SubsequenceCheckQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func subsequenceCheckQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is a subsequence?",
                options: ["Characters in reverse order", "Characters in same relative order", "Characters sorted alphabetically", "Adjacent characters only"],
                correctAnswerIndex: 1,
                explanation: "A subsequence maintains the relative order of characters from the original string.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Is 'ace' a subsequence of 'abcde'?",
                options: ["Yes", "No", "Only if case matches", "Depends on length"],
                correctAnswerIndex: 0,
                explanation: "Yes! 'a', 'c', 'e' appear in order in 'abcde', even though not consecutive.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 0,
                explanation: "Only two pointers are used, giving O(1) constant space complexity.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
