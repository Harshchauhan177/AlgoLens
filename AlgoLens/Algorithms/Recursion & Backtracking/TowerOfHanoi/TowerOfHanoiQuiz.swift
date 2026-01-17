//
//  TowerOfHanoiQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func towerOfHanoiQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the minimum number of moves required to solve Tower of Hanoi with n disks?",
                options: ["2^n", "2^n - 1", "n^2", "n!"],
                correctAnswerIndex: 1,
                explanation: "The minimum number of moves is 2^n - 1. For example, 3 disks require 7 moves, 4 disks require 15 moves.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Tower of Hanoi?",
                options: ["O(n)", "O(n log n)", "O(2^n)", "O(n!)"],
                correctAnswerIndex: 2,
                explanation: "The time complexity is O(2^n) as each disk doubles the number of moves required.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can a larger disk be placed on top of a smaller disk?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. This is one of the fundamental rules - a larger disk cannot be placed on a smaller disk.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many recursive calls are made for n disks?",
                options: ["n", "2n", "2^n - 1", "n^2"],
                correctAnswerIndex: 2,
                explanation: "The algorithm makes 2^n - 1 recursive calls, matching the number of moves required.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Tower of Hanoi?",
                options: ["O(1)", "O(n)", "O(2^n)", "O(n^2)"],
                correctAnswerIndex: 1,
                explanation: "The space complexity is O(n) due to the recursion call stack, which can be at most n levels deep.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Tower of Hanoi uses divide-and-conquer strategy.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. It divides the problem into smaller subproblems: move n-1 disks, move largest disk, move n-1 disks again.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many moves are needed for 4 disks?",
                options: ["7", "15", "31", "63"],
                correctAnswerIndex: 1,
                explanation: "For 4 disks: 2^4 - 1 = 16 - 1 = 15 moves.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
