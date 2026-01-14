//
//  SlidingWindowQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func slidingWindowQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(questionText: "What is the time complexity of Sliding Window for fixed size k?", options: ["O(1)", "O(n)", "O(n*k)", "O(n²)"], correctAnswerIndex: 1, explanation: "Sliding Window traverses array once: O(n)", type: .multipleChoice),
            QuizQuestion(questionText: "Sliding Window is useful for subarray problems.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "True! It's designed for contiguous subarray problems.", type: .trueFalse)
        ]
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
