//
//  SelectionSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func selectionSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the main characteristic of Selection Sort?",
                options: [
                    "It compares adjacent elements",
                    "It selects the minimum element and places it at the beginning",
                    "It divides the array in half",
                    "It uses a pivot element"
                ],
                correctAnswerIndex: 1,
                explanation: "Selection Sort finds the minimum element from the unsorted portion and places it at the beginning of that portion.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Selection Sort performs fewer swaps than Bubble Sort.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Selection Sort performs at most n-1 swaps, while Bubble Sort can perform many more swaps.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Selection Sort?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 2,
                explanation: "Selection Sort has O(n²) time complexity in all cases because it always scans the entire unsorted portion.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Selection Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Selection Sort is not stable as it may change the relative order of equal elements during swapping.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Selection Sort?",
                options: ["O(1)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 0,
                explanation: "Selection Sort has O(1) space complexity as it sorts in-place with only a few extra variables.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
