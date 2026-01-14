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
            QuizQuestion(questionText: "Dutch National Flag sorts in a single pass.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "True! It sorts in O(n) time with one pass.", type: .trueFalse)
        ]
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
