//
//  BubbleSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func bubbleSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Bubble Sort in the worst case?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 2,
                explanation: "Bubble Sort has O(n²) time complexity in the worst case because it uses nested loops to compare all pairs of elements.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Bubble Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Bubble Sort maintains the relative order of equal elements, making it a stable sorting algorithm.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What happens in each pass of Bubble Sort?",
                options: [
                    "The smallest element moves to the beginning",
                    "The largest unsorted element moves to its correct position",
                    "The array is divided in half",
                    "Random elements are swapped"
                ],
                correctAnswerIndex: 1,
                explanation: "In each pass, adjacent elements are compared and swapped if needed, causing the largest unsorted element to 'bubble up' to its correct position at the end.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Bubble Sort?",
                options: ["O(1)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 0,
                explanation: "Bubble Sort has O(1) space complexity because it only needs a temporary variable for swapping, sorting in-place.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Bubble Sort is efficient for large datasets.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Bubble Sort has O(n²) time complexity, making it inefficient for large datasets. Better algorithms like Quick Sort or Merge Sort should be used.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
