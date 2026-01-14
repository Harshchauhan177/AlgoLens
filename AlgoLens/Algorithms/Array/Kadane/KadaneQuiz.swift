//
//  KadaneQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func kadaneQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(questionText: "What is the time complexity of Kadane's Algorithm?", options: ["O(1)", "O(n)", "O(n log n)", "O(n²)"], correctAnswerIndex: 1, explanation: "Kadane's Algorithm traverses the array once: O(n)", type: .multipleChoice)
        ]
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
