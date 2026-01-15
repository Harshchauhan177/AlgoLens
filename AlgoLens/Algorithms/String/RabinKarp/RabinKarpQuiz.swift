//
//  RabinKarpQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func rabinKarpQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What technique does Rabin-Karp use for efficient pattern matching?",
                options: ["Binary search", "Hashing", "Dynamic programming", "Backtracking"],
                correctAnswerIndex: 1,
                explanation: "Rabin-Karp uses rolling hash technique to efficiently compare substrings by computing hash values instead of comparing characters directly.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the average time complexity of Rabin-Karp algorithm?",
                options: ["O(n×m)", "O(n+m)", "O(n log m)", "O(m log n)"],
                correctAnswerIndex: 1,
                explanation: "In average case, Rabin-Karp runs in O(n+m) time - O(m) to compute pattern hash and O(n) to slide through text using constant-time rolling hash.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Why do we need to verify matches character by character after hash match?",
                options: ["To improve speed", "Due to hash collisions", "To save memory", "It's optional"],
                correctAnswerIndex: 1,
                explanation: "Hash collisions can occur where different strings produce the same hash value. Character-by-character verification ensures we have a true match and not a false positive.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity to compute the rolling hash for the next window?",
                options: ["O(1)", "O(m)", "O(log m)", "O(n)"],
                correctAnswerIndex: 0,
                explanation: "Rolling hash technique allows computing the hash of the next window in O(1) constant time by removing the contribution of the first character and adding the new character.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Rabin-Karp requires preprocessing of the pattern before searching.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Rabin-Karp needs to compute the hash value of the pattern and calculate the highest power value (h) for the rolling hash before starting the search.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the worst-case time complexity of Rabin-Karp?",
                options: ["O(n)", "O(m)", "O(n×m)", "O(n+m)"],
                correctAnswerIndex: 2,
                explanation: "In the worst case with many hash collisions, we verify characters at every position, resulting in O(n×m) complexity similar to naive approach.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Which scenario is Rabin-Karp particularly efficient for?",
                options: [
                    "Searching for a single short pattern",
                    "Searching for multiple patterns simultaneously",
                    "Searching in very small texts",
                    "Patterns with many repeated characters"
                ],
                correctAnswerIndex: 1,
                explanation: "Rabin-Karp excels at multiple pattern matching because we can compute hashes for all patterns once and compare them with text window hashes efficiently.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The space complexity of Rabin-Karp is O(1).",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. The algorithm only uses constant extra space for storing hash values and indices, regardless of input size.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the purpose of using a prime number in the hash function?",
                options: [
                    "To make computation faster",
                    "To reduce hash collisions",
                    "To save memory",
                    "It's not necessary"
                ],
                correctAnswerIndex: 1,
                explanation: "Using a prime number as modulus in the hash function helps distribute hash values more uniformly, reducing the probability of hash collisions.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Rabin-Karp can be used for plagiarism detection.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True. Rabin-Karp's ability to efficiently search for multiple patterns makes it ideal for plagiarism detection, where we need to find matching text segments across documents.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
