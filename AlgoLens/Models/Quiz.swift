//
//  Quiz.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import Foundation

// MARK: - Quiz Model
struct Quiz {
    let algorithm: Algorithm
    let questions: [QuizQuestion]
    
    var totalQuestions: Int {
        return questions.count
    }
}

// MARK: - Quiz Question Model
struct QuizQuestion: Identifiable {
    let id = UUID()
    let questionText: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let type: QuestionType
    
    enum QuestionType {
        case multipleChoice
        case trueFalse
    }
    
    var correctAnswer: String {
        return options[correctAnswerIndex]
    }
}

// MARK: - Quiz Answer Model
struct QuizAnswer {
    let questionId: UUID
    let selectedAnswerIndex: Int
    let isCorrect: Bool
}

// MARK: - Quiz Result
struct QuizResult {
    let quiz: Quiz
    let answers: [QuizAnswer]
    let score: Int
    let totalQuestions: Int
    
    var percentage: Double {
        return Double(score) / Double(totalQuestions) * 100
    }
    
    var feedbackMessage: String {
        switch percentage {
        case 90...100:
            return "Excellent! You've mastered this algorithm! 🎉"
        case 70..<90:
            return "Great job! Keep practicing to master it! 👏"
        case 50..<70:
            return "Good effort! Review the algorithm once more. 📚"
        default:
            return "Keep learning! Try the visualization again. 💪"
        }
    }
    
    var feedbackColor: String {
        switch percentage {
        case 90...100:
            return "green"
        case 70..<90:
            return "blue"
        case 50..<70:
            return "orange"
        default:
            return "red"
        }
    }
}

// MARK: - Quiz Content Repository
extension Quiz {
    static func quiz(for algorithm: Algorithm) -> Quiz {
        switch algorithm.name {
        case "Linear Search":
            return linearSearchQuiz(algorithm: algorithm)
        case "Binary Search":
            return binarySearchQuiz(algorithm: algorithm)
        case "Jump Search":
            return jumpSearchQuiz(algorithm: algorithm)
        case "Interpolation Search":
            return interpolationSearchQuiz(algorithm: algorithm)
        case "Exponential Search":
            return exponentialSearchQuiz(algorithm: algorithm)
        case "Fibonacci Search":
            return fibonacciSearchQuiz(algorithm: algorithm)
        default:
            return defaultQuiz(algorithm: algorithm)
        }
    }
    
    // MARK: - Linear Search Quiz
    private static func linearSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Linear Search in the worst case?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n²)"],
                correctAnswerIndex: 2,
                explanation: "Linear Search checks each element one by one, so in the worst case it examines all n elements, giving O(n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Does Linear Search require the array to be sorted?",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "Linear Search works on both sorted and unsorted arrays since it checks elements sequentially.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "When is Linear Search preferred over Binary Search?",
                options: [
                    "When array is sorted",
                    "When array is unsorted or very small",
                    "When array is very large",
                    "Never, Binary Search is always better"
                ],
                correctAnswerIndex: 1,
                explanation: "Linear Search is preferred for unsorted arrays or small datasets where sorting overhead isn't worth it.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "In an array of 100 elements, what's the maximum number of comparisons Linear Search might need?",
                options: ["1", "50", "100", "200"],
                correctAnswerIndex: 2,
                explanation: "In the worst case (element at end or not present), Linear Search checks all 100 elements.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Linear Search can find the first occurrence of a duplicate element.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Since Linear Search starts from the beginning and checks sequentially, it naturally finds the first occurrence.",
                type: .trueFalse
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
    
    // MARK: - Binary Search Quiz
    private static func binarySearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the time complexity of Binary Search?",
                options: ["O(1)", "O(log n)", "O(n)", "O(n log n)"],
                correctAnswerIndex: 1,
                explanation: "Binary Search divides the array in half with each comparison, resulting in O(log n) time complexity.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Binary Search requires the array to be sorted.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "Binary Search only works on sorted arrays because it relies on comparing middle elements to decide which half to search.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "In an array of 1000 elements, approximately how many comparisons does Binary Search need in the worst case?",
                options: ["10", "100", "500", "1000"],
                correctAnswerIndex: 0,
                explanation: "log₂(1000) ≈ 10, so Binary Search needs about 10 comparisons maximum.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What does Binary Search do if the middle element is greater than the target?",
                options: [
                    "Search the right half",
                    "Search the left half",
                    "Stop searching",
                    "Start over"
                ],
                correctAnswerIndex: 1,
                explanation: "If middle element is greater than target, the target must be in the left half (lower values).",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
    
    // MARK: - Jump Search Quiz
    private static func jumpSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "What is the optimal jump size in Jump Search for an array of size n?",
                options: ["n/2", "√n", "log n", "n"],
                correctAnswerIndex: 1,
                explanation: "The optimal jump size is √n, which balances between jumping too far and jumping too little.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Jump Search works on unsorted arrays.",
                options: ["True", "False"],
                correctAnswerIndex: 1,
                explanation: "Jump Search requires a sorted array, similar to Binary Search.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Jump Search?",
                options: ["O(1)", "O(√n)", "O(n)", "O(log n)"],
                correctAnswerIndex: 1,
                explanation: "Jump Search has O(√n) time complexity - better than Linear but slower than Binary Search.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
    
    // MARK: - Interpolation Search Quiz
    private static func interpolationSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Interpolation Search works best on which type of data?",
                options: [
                    "Randomly distributed",
                    "Uniformly distributed",
                    "Clustered data",
                    "Unsorted data"
                ],
                correctAnswerIndex: 1,
                explanation: "Interpolation Search performs best on uniformly distributed sorted data where values are evenly spaced.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Interpolation Search is similar to how we search in a dictionary.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Just like we estimate position in a dictionary based on letters, Interpolation Search estimates position based on values.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the best-case time complexity of Interpolation Search?",
                options: ["O(1)", "O(log log n)", "O(log n)", "O(n)"],
                correctAnswerIndex: 1,
                explanation: "For uniformly distributed data, Interpolation Search achieves O(log log n) time complexity.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
    
    // MARK: - Exponential Search Quiz
    private static func exponentialSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Exponential Search combines which two search techniques?",
                options: [
                    "Linear and Jump Search",
                    "Linear and Binary Search",
                    "Binary and Jump Search",
                    "Interpolation and Binary Search"
                ],
                correctAnswerIndex: 1,
                explanation: "Exponential Search first uses exponential jumps (linear approach) then applies Binary Search on the identified range.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "Exponential Search is useful for unbounded or infinite arrays.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Exponential Search is particularly useful when the array size is unknown or unbounded.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Exponential Search?",
                options: ["O(1)", "O(log n)", "O(√n)", "O(n)"],
                correctAnswerIndex: 1,
                explanation: "Exponential Search has O(log n) time complexity, same as Binary Search.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
    
    // MARK: - Fibonacci Search Quiz
    private static func fibonacciSearchQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Fibonacci Search uses Fibonacci numbers to divide the array.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Fibonacci Search divides the array using Fibonacci numbers instead of exact halves.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "What advantage does Fibonacci Search have over Binary Search?",
                options: [
                    "Faster execution",
                    "Works on unsorted arrays",
                    "Avoids division operations",
                    "Uses less memory"
                ],
                correctAnswerIndex: 2,
                explanation: "Fibonacci Search avoids costly division operations, using only addition and subtraction.",
                type: .multipleChoice
            ),
            QuizQuestion(
                questionText: "What is the time complexity of Fibonacci Search?",
                options: ["O(1)", "O(log n)", "O(√n)", "O(n)"],
                correctAnswerIndex: 1,
                explanation: "Fibonacci Search has O(log n) time complexity, similar to Binary Search.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
    
    // MARK: - Default Quiz
    private static func defaultQuiz(algorithm: Algorithm) -> Quiz {
        let questions = [
            QuizQuestion(
                questionText: "Understanding algorithm complexity is important.",
                options: ["True", "False"],
                correctAnswerIndex: 0,
                explanation: "True! Knowing time and space complexity helps you choose the right algorithm for your problem.",
                type: .trueFalse
            ),
            QuizQuestion(
                questionText: "Which factor is most important when choosing an algorithm?",
                options: [
                    "Code length",
                    "Time and space complexity",
                    "Programming language",
                    "Variable names"
                ],
                correctAnswerIndex: 1,
                explanation: "Time and space complexity determine how efficiently an algorithm performs as data size grows.",
                type: .multipleChoice
            )
        ]
        
        return Quiz(algorithm: algorithm, questions: questions)
    }
}
