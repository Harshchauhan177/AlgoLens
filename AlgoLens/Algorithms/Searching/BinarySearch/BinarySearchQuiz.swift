//
//  BinarySearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func binarySearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Binary Search?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n log n)"],
                correctAnswerIndex: 1,
                explanation: "Binary Search divides the array in half with each comparison, resulting in O(log n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Binary Search requires the array to be sorted.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Binary Search only works on sorted arrays because it relies on comparing middle elements to decide which half to search.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "In an array of 1000 elements, approximately how many comparisons does Binary Search need in the worst case?",
                options: ["10", "100", "500", "1000"],
                correctAnswerIndex: 0,
                explanation: "log₂(1000) ≈ 10, so Binary Search needs about 10 comparisons maximum.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What does Binary Search do if the middle element is greater than the target?",
                options: [
                    "Search the right half",
                    "Search the left half",
                    "Stop searching",
                    "Start over"
                ],
                correctAnswerIndex: 1,
                explanation: "If middle element is greater than target, the target must be in the left half (lower values).",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Binary Search is more efficient than Linear Search for large sorted arrays.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Binary Search's O(log n) complexity is much faster than Linear Search's O(n) for large datasets.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
