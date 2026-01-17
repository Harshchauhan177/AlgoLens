//
//  NQueensQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func nQueensQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the N-Queens backtracking algorithm?",
                options: ["O(N²)", "O(N!)", "O(2^N)", "O(N^N)"],
                correctAnswerIndex: 1,
                explanation: "The time complexity is O(N!) as we try to place queens in N! different ways, with pruning reducing the actual number of explorations.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "How many solutions exist for the 8-Queens problem?",
                options: ["12", "92", "40", "64"],
                correctAnswerIndex: 1,
                explanation: "There are exactly 92 distinct solutions for placing 8 queens on an 8×8 chessboard.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can two queens be placed in the same row?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. Two queens in the same row would attack each other, violating the N-Queens constraint.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What technique does N-Queens use to avoid invalid configurations?",
                options: ["Dynamic Programming", "Greedy Algorithm", "Backtracking", "Divide and Conquer"],
                correctAnswerIndex: 2,
                explanation: "N-Queens uses backtracking to explore possible placements and undo (backtrack) when a configuration is invalid.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of N-Queens?",
                options: ["O(1)", "O(N)", "O(N²)", "O(N!)"],
                correctAnswerIndex: 2,
                explanation: "Space complexity is O(N²) for storing the board, plus O(N) for recursion depth, resulting in O(N²) overall.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Is it possible to solve N-Queens for N=2 or N=3?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. No solution exists for N=2 or N=3. The first solution exists for N=1, and then N≥4.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "Which directions must be checked before placing a queen?",
                options: ["Only rows", "Only columns", "Rows, columns, and diagonals", "Only diagonals"],
                correctAnswerIndex: 2,
                explanation: "We must check rows, columns, and both diagonals since queens can attack in all these directions.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
