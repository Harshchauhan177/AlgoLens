//
//  LinearSearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func linearSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Linear Search in the worst case?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 2,
                explanation: "Linear Search checks each element one by one, so in the worst case it examines all n elements, giving O(n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does Linear Search require the array to be sorted?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "Linear Search works on both sorted and unsorted arrays since it checks elements sequentially.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "When is Linear Search preferred over Binary Search?",
                options: [
                    "When array is sorted",
                    "When array is unsorted or very small",
                    "When array is very large",
                    "Never, Binary Search is always better"
                ],
                correctAnswerIndex: 1,
                explanation: "Linear Search is preferred for unsorted arrays or small datasets where sorting overhead isn't worth it.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "In an array of 100 elements, what's the maximum number of comparisons Linear Search might need?",
                options: ["1", "50", "100", "200"],
                correctAnswerIndex: 2,
                explanation: "In the worst case (element at end or not present), Linear Search checks all 100 elements.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Linear Search can find the first occurrence of a duplicate element.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Since Linear Search starts from the beginning and checks sequentially, it naturally finds the first occurrence.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
