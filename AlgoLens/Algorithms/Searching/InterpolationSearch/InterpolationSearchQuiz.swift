//
//  InterpolationSearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func interpolationSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Interpolation Search works best on which type of data?",
                options: [
                    "Randomly distributed",
                    "Uniformly distributed",
                    "Clustered data",
                    "Unsorted data"
                ],
                correctAnswerIndex: 1,
                explanation: "Interpolation Search performs best on uniformly distributed sorted data where values are evenly spaced.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Interpolation Search is similar to how we search in a dictionary.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Just like we estimate position in a dictionary based on letters, Interpolation Search estimates position based on values.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the best-case time complexity of Interpolation Search?",
                options: ["O(1)", "O(log log n)", "O(log n)", "O(n)"],
                correctAnswerIndex: 1,
                explanation: "For uniformly distributed data, Interpolation Search achieves O(log log n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "How does Interpolation Search estimate the position?",
                options: [
                    "Random guessing",
                    "Always checking middle",
                    "Using value distribution formula",
                    "Sequential checking"
                ],
                correctAnswerIndex: 2,
                explanation: "Interpolation Search uses a formula based on the value distribution to estimate where the target might be.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Interpolation Search can be slower than Binary Search on non-uniform data.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! On non-uniformly distributed data, Interpolation Search can degrade to O(n) while Binary Search remains O(log n).",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
