//
//  SubsetGenerationQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func subsetGenerationQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "How many subsets does a set with n elements have?",
                options: ["n", "n²", "2^n", "n!"],
                correctAnswerIndex: 2,
                explanation: "A set with n elements has 2^n subsets, including the empty set. Each element can either be included or excluded.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Is the empty set considered a subset?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. The empty set (∅) is a subset of every set, including itself.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many subsets does the set [1, 2, 3, 4] have?",
                options: ["8", "12", "16", "24"],
                correctAnswerIndex: 2,
                explanation: "2^4 = 16 subsets. Each of the 4 elements can either be included or excluded.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of generating all subsets?",
                options: ["O(n)", "O(n²)", "O(2^n)", "O(n!)"],
                correctAnswerIndex: 2,
                explanation: "The time complexity is O(n × 2^n) as we generate 2^n subsets and each takes O(n) time to construct.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "For each element, how many choices do we have?",
                options: ["1", "2", "3", "n"],
                correctAnswerIndex: 1,
                explanation: "For each element, we have 2 choices: include it in the subset or exclude it.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The set itself is always a subset.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Every set is a subset of itself, known as the improper subset.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is another name for the collection of all subsets?",
                options: ["Universal Set", "Power Set", "Super Set", "Union Set"],
                correctAnswerIndex: 1,
                explanation: "The Power Set is the set of all subsets of a given set, including the empty set and the set itself.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
