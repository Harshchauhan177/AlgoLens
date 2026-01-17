//
//  WordSearchQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func wordSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "In which directions can we move to form words?",
                options: ["Only horizontal", "Only vertical", "Horizontal and vertical", "All 8 directions"],
                correctAnswerIndex: 2,
                explanation: "Word Search allows movement only in horizontal and vertical directions (up, down, left, right), not diagonally.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can the same cell be used multiple times in one word?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. Each cell can only be used once per word. We mark cells as visited to prevent reuse.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the worst-case time complexity where M×N is grid size and L is word length?",
                options: ["O(M×N)", "O(L)", "O(M×N×3^L)", "O(M×N×L)"],
                correctAnswerIndex: 2,
                explanation: "Worst case is O(M×N×3^L): we try starting from each cell (M×N), and at each step we have 3 choices (can't go back), for L steps.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What technique is used to avoid revisiting cells?",
                options: ["Dynamic Programming", "Visited matrix", "Priority queue", "Stack"],
                correctAnswerIndex: 1,
                explanation: "We use a visited matrix (or modify the board) to track which cells are used in the current path.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Which search algorithm does Word Search primarily use?",
                options: ["Breadth-First Search", "Depth-First Search", "Binary Search", "Greedy Search"],
                correctAnswerIndex: 1,
                explanation: "Word Search uses Depth-First Search (DFS) with backtracking to explore paths deeply before trying alternatives.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "We need to search the entire grid even after finding the word.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. We can stop immediately (early termination) once we find the word, improving efficiency.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many directions do we explore from each cell?",
                options: ["2", "4", "6", "8"],
                correctAnswerIndex: 1,
                explanation: "We explore 4 directions from each cell: up, down, left, and right.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
