//
//  SubsequenceCheckQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func subsequenceCheckQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the Subsequence Check algorithm?",
                options: ["O(n)", "O(m)", "O(n+m)", "O(n×m)"],
                correctAnswerIndex: 0,
                explanation: "The algorithm traverses the main string (n) at most once with two pointers. In the worst case, we only need to scan through the entire main string once, resulting in O(n) time complexity where n is the length of the main string.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Subsequence Check?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 0,
                explanation: "The algorithm uses only two pointers and constant extra space for tracking indices, regardless of input size.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Is 'ace' a subsequence of 'abcde'?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Yes! The characters 'a', 'c', 'e' appear in order in 'abcde' (at positions 0, 2, 4), even though they are not consecutive.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "Must the characters in a subsequence be consecutive in the main string?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False. A subsequence maintains the relative order of characters but they don't need to be consecutive. For example, 'ac' is a subsequence of 'abc'.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What happens when we find a character match in the algorithm?",
                options: [
                    "Only advance the main string pointer",
                    "Only advance the subsequence pointer",
                    "Advance both pointers",
                    "Reset both pointers"
                ],
                correctAnswerIndex: 2,
                explanation: "When characters match, we advance both the main string pointer and the subsequence pointer to continue checking the next characters.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "When do we determine that the subsequence check is successful?",
                options: [
                    "When main string pointer reaches the end",
                    "When subsequence pointer reaches the end",
                    "When both pointers reach their ends",
                    "When we find any character match"
                ],
                correctAnswerIndex: 1,
                explanation: "The check is successful when the subsequence pointer reaches the end, meaning we found all characters of the subsequence in order in the main string.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can an empty string be considered a subsequence of any string?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. An empty string is considered a subsequence of any string, including another empty string, as it requires finding zero characters in order.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
