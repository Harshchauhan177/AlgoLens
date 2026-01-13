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
