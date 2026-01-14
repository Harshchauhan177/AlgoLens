//
//  KMPQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func kmpQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of KMP algorithm?",
                options: ["O(n×m)", "O(n+m)", "O(n²)", "O(m²)"],
                correctAnswerIndex: 1,
                explanation: "KMP processes both text and pattern linearly, resulting in O(n+m) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What does LPS stand for in KMP algorithm?",
                options: ["Longest Prefix Suffix", "Linear Pattern Search", "Longest Pattern String", "Last Position Stored"],
                correctAnswerIndex: 0,
                explanation: "LPS stands for Longest Prefix Suffix, which helps in skipping characters during matching.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of KMP algorithm?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 2,
                explanation: "KMP requires O(m) space to store the LPS array for the pattern.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
