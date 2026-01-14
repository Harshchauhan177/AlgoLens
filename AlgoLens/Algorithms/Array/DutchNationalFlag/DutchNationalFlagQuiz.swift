//
//  DutchNationalFlagQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func dutchNationalFlagQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the Dutch National Flag algorithm?",
                options: ["O(1)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "Dutch National Flag sorts in O(n) time with a single pass through the array.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Dutch National Flag algorithm sorts the array in-place.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! It uses only O(1) extra space by swapping elements in the original array.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many pointers does the Dutch National Flag algorithm use?",
                options: ["One", "Two", "Three", "Four"],
                correctAnswerIndex: 2,
                explanation: "It uses three pointers: low (for 0s), mid (current element), and high (for 2s).",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "When array[mid] == 0, what should happen?",
                options: [
                    "Swap with high, decrease high",
                    "Just move mid forward",
                    "Swap with low, move both low and mid forward",
                    "Do nothing"
                ],
                correctAnswerIndex: 2,
                explanation: "When we find 0, swap it with the low pointer position and increment both low and mid.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The Dutch National Flag algorithm can only sort values 0, 1, and 2.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! It's specifically designed for three distinct values. For other values, adaptations are needed.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "When array[mid] == 1, what is the correct action?",
                options: [
                    "Swap with low",
                    "Swap with high",
                    "Just increment mid",
                    "Swap with both"
                ],
                correctAnswerIndex: 2,
                explanation: "When mid points to 1, it's already in the correct region, so just move mid forward.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Dutch National Flag?",
                options: ["O(1)", "O(n)", "O(log n)", "O(n²)"],
                correctAnswerIndex: 0,
                explanation: "It uses constant O(1) extra space since sorting is done in-place with only pointer variables.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The algorithm is named after the colors of the Dutch flag.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! The Dutch flag has three horizontal stripes (red, white, blue), similar to partitioning into three groups.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
