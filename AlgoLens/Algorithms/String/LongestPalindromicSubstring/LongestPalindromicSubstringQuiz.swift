//
//  LongestPalindromicSubstringQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func longestPalindromicSubstringQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is a palindrome?",
                options: ["A string that contains only letters", "A string that reads same forwards and backwards", "A string with even length", "A string with unique characters"],
                correctAnswerIndex: 1,
                explanation: "A palindrome reads the same forwards and backwards, like 'racecar' or 'noon'.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What technique is used to find palindromes?",
                options: ["Binary search", "Expand around center", "Two pointers from ends", "Dynamic programming"],
                correctAnswerIndex: 1,
                explanation: "The expand around center technique checks for palindromes by expanding outward from each position.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(2^n)"],
                correctAnswerIndex: 2,
                explanation: "For each of n positions, we might expand up to n characters, giving O(n²) complexity.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
