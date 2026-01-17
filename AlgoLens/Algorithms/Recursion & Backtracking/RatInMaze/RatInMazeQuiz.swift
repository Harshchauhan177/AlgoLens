//
//  RatInMazeQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func ratInMazeQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What value represents a blocked cell in the maze?",
                options: ["1", "0", "-1", "null"],
                correctAnswerIndex: 1,
                explanation: "0 represents a blocked cell (wall), while 1 represents an open path.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "In how many directions can the rat move?",
                options: ["2", "4", "6", "8"],
                correctAnswerIndex: 1,
                explanation: "The rat can move in 4 directions: Down, Right, Up, and Left.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The rat can revisit cells during pathfinding.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. We use a visited matrix to prevent revisiting cells in the current path, avoiding infinite loops.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the worst-case time complexity?",
                options: ["O(N)", "O(N²)", "O(2^(N²))", "O(N!)"],
                correctAnswerIndex: 2,
                explanation: "In worst case, we might explore all possible paths in the maze, leading to O(2^(N²)) complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What technique is used when a path leads to a dead end?",
                options: ["Greedy", "Backtracking", "Dynamic Programming", "Memoization"],
                correctAnswerIndex: 1,
                explanation: "Backtracking is used to undo the current path and explore alternative routes.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Where does the rat start in a standard maze?",
                options: ["Bottom-right", "Top-left", "Center", "Any position"],
                correctAnswerIndex: 1,
                explanation: "The rat typically starts at position (0, 0), the top-left corner of the maze.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can there be multiple solutions to reach the destination?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. There can be multiple valid paths from start to destination depending on the maze structure.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
