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
                questionText: "What is the time complexity of Naive String Matching in the worst case?",
                options: ["O(n)", "O(m)", "O(n×m)", "O(n+m)"],
                correctAnswerIndex: 2,
                explanation: "The algorithm compares the pattern at each position in the text, resulting in O(n×m) complexity where n is text length and m is pattern length.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does Naive String Matching require preprocessing of the pattern?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "Naive String Matching does not require any preprocessing. It directly compares characters, making it simple but less efficient.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Naive String Matching?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 0,
                explanation: "The algorithm uses only constant extra space for indices and comparisons, regardless of input size.",
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
                explanation: "Naive approach works best when the pattern is small, reducing the multiplicative factor in the time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Naive String Matching can find multiple occurrences of a pattern in text.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "The algorithm naturally finds all occurrences as it checks every possible position in the text where the pattern could match.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
