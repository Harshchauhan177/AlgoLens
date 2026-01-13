//
//  MergeSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func mergeSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Merge Sort in all cases?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "Merge Sort always has O(n log n) time complexity in best, average, and worst cases due to its divide-and-conquer approach.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Merge Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Merge Sort maintains the relative order of equal elements during the merge process.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the main disadvantage of Merge Sort?",
                options: [
                    "Slow time complexity",
                    "Requires O(n) extra space",
                    "Not stable",
                    "Cannot handle large datasets"
                ],
                correctAnswerIndex: 1,
                explanation: "Merge Sort requires O(n) auxiliary space for the temporary arrays used during merging, which can be a limitation for memory-constrained systems.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Merge Sort uses the divide-and-conquer paradigm.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Merge Sort divides the problem into smaller subproblems, solves them recursively, and combines the solutions.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "In Merge Sort, what happens during the 'merge' step?",
                options: [
                    "The array is divided into halves",
                    "Two sorted arrays are combined into one sorted array",
                    "Elements are swapped randomly",
                    "The pivot is selected"
                ],
                correctAnswerIndex: 1,
                explanation: "During the merge step, two sorted subarrays are combined into a single sorted array by comparing elements from both arrays.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
