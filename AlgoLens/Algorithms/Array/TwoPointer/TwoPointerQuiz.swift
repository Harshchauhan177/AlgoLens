//
//  TwoPointerQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func twoPointerQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Two Pointer technique for finding pairs?",
                options: ["O(1)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "Two Pointer technique traverses the array once with two pointers, resulting in O(n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Two Pointer technique requires the array to be sorted.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! For finding pairs with a target sum, the array must be sorted to move pointers correctly based on comparisons.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Two Pointer technique?",
                options: ["O(1)", "O(n)", "O(log n)", "O(n²)"],
                correctAnswerIndex: 0,
                explanation: "Two Pointer uses only two pointers, requiring constant O(1) extra space.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "When should you move the left pointer in Two Pointer Sum problem?",
                options: [
                    "When sum is greater than target",
                    "When sum is less than target",
                    "When sum equals target",
                    "Never move it"
                ],
                correctAnswerIndex: 1,
                explanation: "Move left pointer right when sum < target to increase the sum (since array is sorted).",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Two Pointer is faster than using nested loops for pair sum problems.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Two Pointer is O(n) while nested loops are O(n²), making Two Pointer much more efficient.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
