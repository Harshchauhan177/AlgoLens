//
//  CountingSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func countingSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Counting Sort is a comparison-based sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Counting Sort is a non-comparison based algorithm that uses counting and arithmetic instead of comparing elements.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Counting Sort?",
                options: ["O(n)", "O(n + k)", "O(n²)", "O(n log n)"],
                correctAnswerIndex: 1,
                explanation: "Counting Sort has O(n + k) time complexity, where n is the number of elements and k is the range of input values.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Counting Sort is efficient when the range of input values is much larger than the number of elements.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Counting Sort is most efficient when the range (k) is not significantly larger than n, as it requires O(k) extra space.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What does Counting Sort primarily use to sort elements?",
                options: [
                    "Comparisons between elements",
                    "Counting occurrences of each value",
                    "Recursive divide and conquer",
                    "Swapping adjacent elements"
                ],
                correctAnswerIndex: 1,
                explanation: "Counting Sort counts the occurrences of each unique value and uses these counts to determine element positions.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Counting Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! When implemented correctly (building output from right to left), Counting Sort maintains the relative order of equal elements.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
