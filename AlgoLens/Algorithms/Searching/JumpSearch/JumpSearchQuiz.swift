//
//  JumpSearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func jumpSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the optimal jump size in Jump Search for an array of size n?",
                options: ["n/2", "√n", "log n", "n"],
                correctAnswerIndex: 1,
                explanation: "The optimal jump size is √n, which balances between jumping too far and jumping too little.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Jump Search works on unsorted arrays.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "Jump Search requires a sorted array, similar to Binary Search.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Jump Search?",
                options: ["O(1)", "O(√n)", "O(n)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "Jump Search has O(√n) time complexity - better than Linear but slower than Binary Search.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Jump Search combines which two approaches?",
                options: [
                    "Jumping blocks and linear search within block",
                    "Binary search and interpolation",
                    "Recursive and iterative",
                    "Sequential and random"
                ],
                correctAnswerIndex: 0,
                explanation: "Jump Search jumps ahead by fixed steps to find the right block, then does linear search within that block.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Jump Search is faster than Binary Search.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Binary Search O(log n) is faster than Jump Search O(√n).",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
