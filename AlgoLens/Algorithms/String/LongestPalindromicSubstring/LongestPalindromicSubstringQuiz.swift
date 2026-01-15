//
//  LongestPalindromicSubstringQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension Quiz {
    static func longestPalindromicSubstringQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is a palindrome?",
                options: [
                    "A string that contains only letters",
                    "A string that reads the same forwards and backwards",
                    "A string with even length",
                    "A string with unique characters"
                ],
                correctAnswerIndex: 1,
                explanation: "A palindrome reads the same forwards and backwards, like 'racecar', 'noon', or 'aba'. It can be of any length and contain any characters.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of the expand around center approach?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(2^n)"],
                correctAnswerIndex: 2,
                explanation: "For each of the n positions (treating each as a potential center), we might expand up to n characters outward to check for palindromes, giving O(n²) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the space complexity of the expand around center approach?",
                options: ["O(1)", "O(n)", "O(n²)", "O(n log n)"],
                correctAnswerIndex: 0,
                explanation: "The algorithm uses only constant extra space for storing indices and tracking the longest palindrome found, regardless of the input string length.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Why do we need to check both odd and even length palindromes?",
                options: [
                    "To make the algorithm faster",
                    "Because palindromes can have a single center (odd) or two centers (even)",
                    "To handle special characters",
                    "It's not necessary, only odd lengths need checking"
                ],
                correctAnswerIndex: 1,
                explanation: "Odd-length palindromes like 'aba' have a single center character, while even-length palindromes like 'abba' have two center characters. We must check both to find all possible palindromes.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "In the string 'babad', which of these is NOT a palindrome?",
                options: ["b", "bab", "aba", "bad"],
                correctAnswerIndex: 3,
                explanation: "'bad' is not a palindrome because it doesn't read the same forwards and backwards (bad ≠ dab). All single characters ('b') and 'bab', 'aba' are valid palindromes.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "The expand around center technique can be more efficient than dynamic programming for this problem.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! While both have O(n²) time complexity, expand around center uses O(1) space compared to O(n²) space for dynamic programming, making it more space-efficient.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What happens when we expand around a center in the algorithm?",
                options: [
                    "We check if characters are unique",
                    "We compare characters moving outward from center while they match",
                    "We sort the characters alphabetically",
                    "We reverse the string"
                ],
                correctAnswerIndex: 1,
                explanation: "Starting from a center position, we compare characters at equal distances on both sides (left and right). We continue expanding outward as long as the characters match, forming a palindrome.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "For string 'cbbd', what is the longest palindromic substring?",
                options: ["c", "bb", "cbd", "cbbd"],
                correctAnswerIndex: 1,
                explanation: "'bb' is the longest palindrome in 'cbbd'. While 'c', 'b', 'b', 'd' are all palindromes of length 1, 'bb' with length 2 is the longest.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Every single character in a string is a palindrome.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Any single character reads the same forwards and backwards, making it a palindrome by definition. This is why the minimum length of the longest palindromic substring is always 1.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the best case time complexity when the entire string is a palindrome?",
                options: ["O(1)", "O(n)", "O(n log n)", "O(n²)"],
                correctAnswerIndex: 3,
                explanation: "Even when the entire string is a palindrome, the algorithm still needs to check all possible centers and expand around them, resulting in O(n²) time complexity. There's no shortcut to avoid checking.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Can there be multiple longest palindromic substrings in a string?",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! A string like 'abacabad' has two longest palindromic substrings of length 3: 'aba' (appears twice) and 'aca'. When multiple palindromes have the same maximum length, any one can be returned.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "Which algorithm offers better time complexity than expand around center?",
                options: [
                    "Naive approach O(n³)",
                    "Dynamic Programming O(n²)",
                    "Manacher's Algorithm O(n)",
                    "Binary Search O(n log n)"
                ],
                correctAnswerIndex: 2,
                explanation: "Manacher's Algorithm is the most efficient with O(n) time complexity. It uses clever techniques to avoid redundant comparisons by reusing information from previously found palindromes.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
