//
//  ZAlgorithmQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func zAlgorithmQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What does the Z-array store?",
                options: ["Hash values", "Character counts", "Length of longest prefix match", "Pattern positions"],
                correctAnswerIndex: 2,
                explanation: "Z-array stores the length of the longest substring starting at each position that matches a prefix.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Z Algorithm?",
                options: ["O(n×m)", "O(n+m)", "O(n²)", "O(m²)"],
                correctAnswerIndex: 1,
                explanation: "Z Algorithm processes the string linearly in O(n+m) time.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What separator is typically used in Z Algorithm?",
                options: ["Space", "Comma", "$ or other unique char", "Null"],
                correctAnswerIndex: 2,
                explanation: "A unique character like $ is used to separate pattern and text to avoid false matches.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
