//
//  StringRotationQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func stringRotationQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is a string rotation?",
                options: ["Reversing a string", "Moving characters from start to end", "Sorting characters", "Capitalizing letters"],
                correctAnswerIndex: 1,
                explanation: "String rotation moves characters from the beginning to the end, like rotating 'abc' to 'bca'.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the clever trick used in this algorithm?",
                options: ["Binary search", "Concatenate string with itself", "Sort both strings", "Use hash table"],
                correctAnswerIndex: 1,
                explanation: "Concatenating s1 with itself creates s1+s1, which contains all rotations of s1 as substrings.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "If s1='abc', which is NOT a rotation?",
                options: ["'bca'", "'cab'", "'acb'", "'abc'"],
                correctAnswerIndex: 2,
                explanation: "'acb' is not a rotation because it changes the relative order of characters.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
