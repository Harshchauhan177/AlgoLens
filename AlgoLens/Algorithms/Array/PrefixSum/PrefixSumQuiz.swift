//
//  PrefixSumQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func prefixSumQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(questionText: "What is the space complexity of Prefix Sum?", options: ["O(1)", "O(n)", "O(log n)", "O(n²)"], correctAnswerIndex: 1, explanation: "Prefix Sum requires O(n) extra space to store cumulative sums.", type: .multipleChoice)
        ]
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
