//
//  AnagramCheckQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func anagramCheckQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the Anagram Check algorithm using character frequency counting?",
                options: ["O(1)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "The algorithm iterates through both strings once - counting characters in the first string and verifying in the second. This results in O(n) time complexity where n is the string length.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does Anagram Check require the strings to be of the same length?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Anagrams must have the same number of characters. If lengths differ, the strings cannot be anagrams, and this check is performed first.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the space complexity of Anagram Check using a hash map?",
                options: ["O(1)", "O(n)", "O(k)", "O(n²)"],
                correctAnswerIndex: 2,
                explanation: "The space complexity is O(k) where k is the size of the character set. For English alphabet, this is constant O(26), effectively O(1) in practice.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Which of the following pairs are anagrams?",
                options: [
                    "listen, silent",
                    "hello, world",
                    "abc, def",
                    "test, tests"
                ],
                correctAnswerIndex: 0,
                explanation: "'listen' and 'silent' are anagrams as they contain exactly the same characters with the same frequencies: l(1), i(1), s(1), t(1), e(1), n(1).",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Anagram Check is case-sensitive by default.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. By default, uppercase and lowercase letters are treated as different characters. 'A' ≠ 'a'. Strings must be normalized to lowercase first if case-insensitive comparison is needed.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What happens first in the Anagram Check algorithm?",
                options: [
                    "Count all characters",
                    "Compare string lengths",
                    "Sort both strings",
                    "Create hash map"
                ],
                correctAnswerIndex: 1,
                explanation: "The algorithm first checks if both strings have the same length. If not, they cannot be anagrams, allowing for an early exit optimization.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Alternative approach: Sorting both strings and comparing them also works for anagram checking.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Sorting both strings and comparing them is a valid approach, though it has O(n log n) time complexity compared to O(n) for the frequency counting method.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "Which data structure is most commonly used for efficient Anagram Check?",
                options: [
                    "Array/List",
                    "Hash Map/Dictionary",
                    "Stack",
                    "Queue"
                ],
                correctAnswerIndex: 1,
                explanation: "Hash Map (Dictionary) is ideal because it provides O(1) average-case lookup and insertion for counting character frequencies.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
