//
//  StringRotationQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func stringRotationQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of the String Rotation algorithm?",
                options: ["O(1)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "The algorithm performs string concatenation O(n) and substring search O(n), resulting in O(n) overall time complexity where n is the length of the string.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is a string rotation?",
                options: ["Reversing a string", "Moving characters from start to end", "Sorting characters", "Capitalizing letters"],
                correctAnswerIndex: 1,
                explanation: "String rotation moves characters from the beginning to the end, like rotating 'abc' to 'bca' or 'cab'.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the clever trick used in this algorithm?",
                options: ["Binary search", "Concatenate string with itself", "Sort both strings", "Use hash table"],
                correctAnswerIndex: 1,
                explanation: "Concatenating s1 with itself creates s1+s1, which contains all rotations of s1 as substrings. This makes rotation detection simple.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "If s1='abc', which is NOT a rotation?",
                options: ["'bca'", "'cab'", "'acb'", "'abc'"],
                correctAnswerIndex: 2,
                explanation: "'acb' is not a rotation because it changes the relative order of characters. Valid rotations maintain the circular order.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of the String Rotation algorithm?",
                options: ["O(1)", "O(n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "The algorithm creates a concatenated string of length 2n, requiring O(n) extra space.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Must both strings have equal length to be rotations?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Yes, rotation preserves string length. If lengths differ, they cannot be rotations of each other.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "The algorithm checks if s2 is a substring of s1+s1.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Correct! If s2 is a rotation of s1, it will always appear as a substring in s1 concatenated with itself.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "For 'waterbottle' and 'erbottlewat', the concatenated string would be:",
                options: [
                    "'waterbottleerbottlewat'",
                    "'waterbottlewaterbottle'",
                    "'erbottlewaterbottlewat'",
                    "'bottlewaterwater'"
                ],
                correctAnswerIndex: 1,
                explanation: "We concatenate the first string with itself: 'waterbottle' + 'waterbottle' = 'waterbottlewaterbottle'.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
