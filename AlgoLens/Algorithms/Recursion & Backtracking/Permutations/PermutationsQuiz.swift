//
//  PermutationsQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension Quiz {
    static func permutationsQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "How many permutations exist for n distinct elements?",
                options: ["n", "n²", "n!", "2^n"],
                correctAnswerIndex: 2,
                explanation: "The number of permutations of n distinct elements is n! (n factorial). For example, 3 elements have 3! = 6 permutations.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of generating all permutations?",
                options: ["O(n)", "O(n²)", "O(n!)", "O(2^n)"],
                correctAnswerIndex: 2,
                explanation: "The time complexity is O(n × n!) as we generate n! permutations and each takes O(n) time to construct.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does the order matter in permutations?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. In permutations, order matters. [1,2,3] and [3,2,1] are different permutations.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "How many permutations exist for [1, 2, 3, 4]?",
                options: ["12", "24", "32", "48"],
                correctAnswerIndex: 1,
                explanation: "4! = 4 × 3 × 2 × 1 = 24 permutations.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What technique is used to generate permutations?",
                options: ["Dynamic Programming", "Greedy", "Backtracking", "Binary Search"],
                correctAnswerIndex: 2,
                explanation: "Backtracking is used to systematically generate all permutations by trying different arrangements and undoing choices.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "[1,2] and [2,1] are considered the same permutation.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. These are different permutations because the order of elements is different.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity for storing all permutations?",
                options: ["O(n)", "O(n²)", "O(n × n!)", "O(n!)"],
                correctAnswerIndex: 2,
                explanation: "We store n! permutations, each of size n, requiring O(n × n!) space.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
