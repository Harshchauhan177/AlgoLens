//
//  SudokuSolverQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func sudokuSolverQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the size of a standard Sudoku grid?",
                options: ["6×6", "8×8", "9×9", "12×12"],
                correctAnswerIndex: 2,
                explanation: "A standard Sudoku puzzle is played on a 9×9 grid, divided into nine 3×3 subgrids.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What technique does Sudoku Solver primarily use?",
                options: ["Dynamic Programming", "Greedy", "Backtracking", "Divide and Conquer"],
                correctAnswerIndex: 2,
                explanation: "Sudoku Solver uses backtracking to try different numbers and undo when constraints are violated.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can a digit repeat in the same row?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. Each row must contain all digits from 1-9 exactly once, with no repetitions.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many 3×3 subgrids are in a standard Sudoku?",
                options: ["3", "6", "9", "12"],
                correctAnswerIndex: 2,
                explanation: "There are 9 subgrids (3×3 arrangement of 3×3 boxes) in a standard 9×9 Sudoku puzzle.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is checked before placing a number in a cell?",
                options: ["Only row", "Only column", "Row, column, and 3×3 box", "Adjacent cells"],
                correctAnswerIndex: 2,
                explanation: "We must verify the number doesn't exist in the same row, column, or 3×3 subgrid.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Every Sudoku puzzle has a unique solution.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. While well-designed Sudoku puzzles have unique solutions, it's possible to create puzzles with multiple solutions.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What value typically represents an empty cell?",
                options: ["-1", "0", "null", "9"],
                correctAnswerIndex: 1,
                explanation: "0 or sometimes '.' is used to represent empty cells in Sudoku implementations.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
