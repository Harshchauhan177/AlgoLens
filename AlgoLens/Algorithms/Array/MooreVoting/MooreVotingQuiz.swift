//
//  MooreVotingQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func mooreVotingQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Moore's Voting Algorithm?",
                options: ["O(log n)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "Moore's Voting Algorithm makes two passes through the array: one to find the candidate and one to verify it, resulting in O(n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Moore's Voting Algorithm always requires a verification phase to confirm the candidate is actually the majority element.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! The algorithm finds a candidate, but doesn't guarantee it's the majority. If no majority element exists, the candidate may be wrong. Always verify by counting its occurrences.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What happens when the count reaches 0 in Moore's Voting Algorithm?",
                options: [
                    "The algorithm terminates",
                    "We elect a new candidate",
                    "We increment the count",
                    "We return null"
                ],
                correctAnswerIndex: 1,
                explanation: "When count reaches 0, it means equal numbers of matching and non-matching elements have been seen. We elect the current element as the new candidate and set count = 1.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Moore's Voting Algorithm?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 0,
                explanation: "Moore's Voting Algorithm uses only O(1) extra space - just variables to store the candidate and count. This is one of its key advantages!",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Moore's Voting Algorithm can find an element that appears exactly n/2 times (not more).",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! The algorithm finds elements appearing MORE than n/2 times (strict majority). An element appearing exactly n/2 times is not guaranteed to be found.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
