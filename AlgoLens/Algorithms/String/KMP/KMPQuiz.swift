//
//  KMPQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func kmpQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of KMP algorithm?",
                options: ["O(n×m)", "O(n+m)", "O(n²)", "O(m²)"],
                correctAnswerIndex: 1,
                explanation: "KMP processes both text and pattern linearly, resulting in O(n+m) time complexity where n is text length and m is pattern length.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What does LPS stand for in KMP algorithm?",
                options: ["Longest Prefix Suffix", "Linear Pattern Search", "Longest Pattern String", "Last Position Stored"],
                correctAnswerIndex: 0,
                explanation: "LPS stands for Longest Prefix Suffix, which is an array that stores the length of the longest proper prefix which is also a suffix for each position in the pattern.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of KMP algorithm?",
                options: ["O(1)", "O(n)", "O(m)", "O(n+m)"],
                correctAnswerIndex: 2,
                explanation: "KMP requires O(m) space to store the LPS array for the pattern, where m is the length of the pattern.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does KMP algorithm require preprocessing of the pattern?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! KMP preprocesses the pattern to build the LPS array, which is then used to avoid redundant comparisons during the search phase.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the main advantage of KMP over Naive String Matching?",
                options: [
                    "Uses less space",
                    "Easier to implement",
                    "Avoids unnecessary character comparisons",
                    "Works only with small patterns"
                ],
                correctAnswerIndex: 2,
                explanation: "KMP's main advantage is that it avoids redundant comparisons by using the LPS array to skip characters when a mismatch occurs, resulting in linear time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "KMP algorithm can find multiple occurrences of a pattern in a single pass.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! KMP naturally finds all occurrences of the pattern in the text in a single pass through the text, making it efficient for finding multiple matches.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
