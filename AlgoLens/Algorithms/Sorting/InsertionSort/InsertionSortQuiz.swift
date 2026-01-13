//
//  InsertionSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func insertionSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Insertion Sort is most efficient when the array is already nearly sorted.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Insertion Sort performs well on nearly sorted arrays with O(n) time complexity in the best case.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the best case time complexity of Insertion Sort?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(1)"],
                correctAnswerIndex: 0,
                explanation: "In the best case (already sorted array), Insertion Sort has O(n) time complexity as it only makes one comparison per element.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Insertion Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Insertion Sort maintains the relative order of equal elements, making it stable.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How does Insertion Sort work?",
                options: [
                    "It selects the minimum element repeatedly",
                    "It inserts each element into its correct position in the sorted portion",
                    "It divides the array recursively",
                    "It compares all adjacent pairs"
                ],
                correctAnswerIndex: 1,
                explanation: "Insertion Sort builds the sorted array by inserting each element into its correct position among previously sorted elements.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Insertion Sort?",
                options: ["O(1)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 0,
                explanation: "Insertion Sort has O(1) space complexity as it sorts in-place without requiring extra space.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
