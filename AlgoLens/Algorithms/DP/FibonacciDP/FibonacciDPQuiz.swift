//
//  FibonacciDPQuiz.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import Foundation

extension Quiz {
    static func fibonacciDPQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the DP approach for Fibonacci?",
                options: ["O(2^n)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "The DP approach calculates each Fibonacci number once, resulting in O(n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of the DP approach?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 2,
                explanation: "We need an array of size n+1 to store all Fibonacci numbers up to n.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What are the base cases for Fibonacci?",
                options: ["F(0)=1, F(1)=1", "F(0)=0, F(1)=1", "F(0)=1, F(1)=2", "F(0)=0, F(1)=0"],
                correctAnswerIndex: 1,
                explanation: "The Fibonacci sequence starts with F(0)=0 and F(1)=1.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
