//
//  QuizViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI
import Combine

@MainActor
class QuizViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var quiz: Quiz
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswerIndex: Int?
    @Published var hasSubmittedAnswer: Bool = false
    @Published var answers: [QuizAnswer] = []
    @Published var showResult: Bool = false
    
    let algorithm: Algorithm
    
    // MARK: - Computed Properties
    var currentQuestion: QuizQuestion {
        return quiz.questions[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        return currentQuestionIndex == quiz.totalQuestions - 1
    }
    
    var progress: Double {
        return Double(currentQuestionIndex + 1) / Double(quiz.totalQuestions)
    }
    
    var progressText: String {
        return "Question \(currentQuestionIndex + 1) of \(quiz.totalQuestions)"
    }
    
    var canSubmit: Bool {
        return selectedAnswerIndex != nil && !hasSubmittedAnswer
    }
    
    var canProceed: Bool {
        return hasSubmittedAnswer
    }
    
    var isAnswerCorrect: Bool {
        guard let selected = selectedAnswerIndex else { return false }
        return selected == currentQuestion.correctAnswerIndex
    }
    
    // MARK: - Initialization
    init(algorithm: Algorithm) {
        self.algorithm = algorithm
        self.quiz = Quiz.quiz(for: algorithm)
    }
    
    // MARK: - Actions
    func selectAnswer(_ index: Int) {
        guard !hasSubmittedAnswer else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedAnswerIndex = index
        }
    }
    
    func submitAnswer() {
        guard canSubmit else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            hasSubmittedAnswer = true
            
            // Record answer
            let answer = QuizAnswer(
                questionId: currentQuestion.id,
                selectedAnswerIndex: selectedAnswerIndex!,
                isCorrect: isAnswerCorrect
            )
            answers.append(answer)
        }
    }
    
    func nextQuestion() {
        guard canProceed else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if isLastQuestion {
                // Show results
                showResult = true
            } else {
                // Move to next question
                currentQuestionIndex += 1
                selectedAnswerIndex = nil
                hasSubmittedAnswer = false
            }
        }
    }
    
    func retryQuiz() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentQuestionIndex = 0
            selectedAnswerIndex = nil
            hasSubmittedAnswer = false
            answers = []
            showResult = false
        }
    }
    
    func getResult() -> QuizResult {
        let score = answers.filter { $0.isCorrect }.count
        return QuizResult(
            quiz: quiz,
            answers: answers,
            score: score,
            totalQuestions: quiz.totalQuestions
        )
    }
}
