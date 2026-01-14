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
                questionText: "What is an anagram?",
                options: ["Words with same length", "Words formed by rearranging letters", "Words with same meaning", "Words that rhyme"],
                correctAnswerIndex: 1,
                explanation: "An anagram is formed by rearranging the letters of another word, like 'listen' and 'silent'.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of anagram checking?",
                options: ["O(1)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 1,
                explanation: "We process each character once, giving O(n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Are 'Dormitory' and 'Dirty room' anagrams?",
                options: ["Yes", "No", "Only if case-insensitive", "Depends on spaces"],
                correctAnswerIndex: 0,
                explanation: "Yes! When normalized (lowercase, no spaces), both contain the same letters.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
