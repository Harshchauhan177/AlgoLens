//
//  QuickSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func quickSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the average-case time complexity of Quick Sort?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "Quick Sort has O(n log n) average-case time complexity, making it one of the fastest sorting algorithms in practice.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Quick Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Quick Sort is not stable as the partitioning process can change the relative order of equal elements.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the key operation in Quick Sort?",
                options: [
                    "Merging two sorted arrays",
                    "Selecting the minimum element",
                    "Partitioning around a pivot",
                    "Inserting elements one by one"
                ],
                correctAnswerIndex: 2,
                explanation: "Quick Sort works by partitioning the array around a pivot element, placing smaller elements on one side and larger on the other.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the worst-case time complexity of Quick Sort?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 2,
                explanation: "Quick Sort has O(n²) worst-case time complexity, which occurs when the pivot is always the smallest or largest element.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Quick Sort typically performs better than Merge Sort in practice.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Despite having the same average time complexity, Quick Sort often performs better due to better cache locality and lower constant factors.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
