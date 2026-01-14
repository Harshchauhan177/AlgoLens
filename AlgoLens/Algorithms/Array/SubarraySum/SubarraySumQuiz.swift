//
//  SubarraySumQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func subarraySumQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(questionText: "Subarray Sum with hashing has O(n) time complexity.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "True! Using hash map makes it O(n) instead of O(n²).", type: .trueFalse)
        ]
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
