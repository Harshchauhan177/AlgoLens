//
//  HeapSortQuiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension Quiz {
    static func heapSortQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Heap Sort in all cases?",
                options: ["O(n)", "O(n log n)", "O(n²)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "Heap Sort always has O(n log n) time complexity in best, average, and worst cases.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Heap Sort is an in-place sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Heap Sort sorts in-place with O(1) space complexity, requiring only a constant amount of extra space.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What data structure does Heap Sort use?",
                options: [
                    "Linked List",
                    "Binary Heap",
                    "Hash Table",
                    "Stack"
                ],
                correctAnswerIndex: 1,
                explanation: "Heap Sort uses a binary heap data structure, specifically a max heap for ascending sort.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Heap Sort is a stable sorting algorithm.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "False! Heap Sort is not stable as the heapify operations can change the relative order of equal elements.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the first step in Heap Sort?",
                options: [
                    "Find the minimum element",
                    "Build a max heap from the array",
                    "Partition around a pivot",
                    "Merge two halves"
                ],
                correctAnswerIndex: 1,
                explanation: "The first step in Heap Sort is to build a max heap from the input array, which takes O(n) time.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
