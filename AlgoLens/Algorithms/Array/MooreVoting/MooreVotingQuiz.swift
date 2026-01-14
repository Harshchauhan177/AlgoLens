//
//  MooreVotingQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func mooreVotingQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(questionText: "Moore's Voting works only if majority element exists.", options: ["True", "False"], correctAnswerIndex: 0, explanation: "True! The algorithm assumes a majority element exists.", type: .trueFalse)
        ]
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
