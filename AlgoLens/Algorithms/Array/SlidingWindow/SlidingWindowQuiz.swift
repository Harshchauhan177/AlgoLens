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
            QuizQuestion(
                questionText: "What is the time complexity of Sliding Window for finding maximum sum of k consecutive elements?",
                options: ["O(k)", "O(n)", "O(n*k)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "Sliding Window traverses the array once with O(n) time, much better than the naive O(n*k) approach that recalculates each window.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Sliding Window is useful for subarray/substring problems.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Sliding Window is perfect for contiguous subarray or substring problems where you need to track a range of elements.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the key advantage of Sliding Window over brute force?",
                options: [
                    "Uses less memory",
                    "Reuses previous calculations instead of starting fresh",
                    "Works on unsorted arrays",
                    "Easier to implement"
                ],
                correctAnswerIndex: 1,
                explanation: "The key advantage is that Sliding Window reuses the previous window's calculation by just removing one element and adding another, avoiding redundant work.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "In a fixed-size sliding window, how do you move to the next window?",
                options: [
                    "Recalculate sum from scratch",
                    "Remove leftmost element and add new rightmost element",
                    "Only add new elements",
                    "Only remove old elements"
                ],
                correctAnswerIndex: 1,
                explanation: "To slide the window efficiently, remove the leftmost element from the sum and add the new rightmost element. This is O(1) operation.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Sliding Window can only work with fixed-size windows.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Sliding Window can have variable size. For example, finding the longest substring without repeating characters uses a variable-size window.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
