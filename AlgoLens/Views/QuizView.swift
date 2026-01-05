//
//  QuizView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    @Environment(\.dismiss) var dismiss
    
    init(algorithm: Algorithm) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(algorithm: algorithm))
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Theme.Colors.backgroundGradientStart,
                    Theme.Colors.backgroundGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.showResult {
                QuizResultView(result: viewModel.getResult()) {
                    viewModel.retryQuiz()
                } onDismiss: {
                    dismiss()
                }
            } else {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: Theme.Spacing.small) {
                        Text("Quick Quiz")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Test your understanding of \(viewModel.algorithm.name)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.medium)
                    .padding(.bottom, Theme.Spacing.large)
                    
                    // Progress Bar
                    VStack(spacing: Theme.Spacing.small) {
                        HStack {
                            Text(viewModel.progressText)
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.secondaryText)
                            Spacer()
                            Text("\(Int(viewModel.progress * 100))%")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                        
                        ProgressView(value: viewModel.progress)
                            .tint(.blue)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.large)
                    
                    // Question Content
                    ScrollView {
                        VStack(spacing: Theme.Spacing.extraLarge) {
                            // Question Card
                            QuestionCard(question: viewModel.currentQuestion)
                            
                            // Answer Options
                            VStack(spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.currentQuestion.options.enumerated()), id: \.offset) { index, option in
                                    AnswerOptionCard(
                                        option: option,
                                        index: index,
                                        isSelected: viewModel.selectedAnswerIndex == index,
                                        isCorrect: index == viewModel.currentQuestion.correctAnswerIndex,
                                        hasSubmitted: viewModel.hasSubmittedAnswer
                                    ) {
                                        viewModel.selectAnswer(index)
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            
                            // Explanation (shown after submission)
                            if viewModel.hasSubmittedAnswer {
                                FeedbackCard(
                                    isCorrect: viewModel.isAnswerCorrect,
                                    explanation: viewModel.currentQuestion.explanation
                                )
                                .padding(.horizontal, Theme.Spacing.large)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding(.bottom, Theme.Spacing.extraLarge)
                    }
                    
                    // Action Button
                    VStack(spacing: Theme.Spacing.small) {
                        Divider()
                        
                        if viewModel.hasSubmittedAnswer {
                            Button(action: {
                                viewModel.nextQuestion()
                            }) {
                                HStack {
                                    Text(viewModel.isLastQuestion ? "View Results" : "Next Question")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    Image(systemName: viewModel.isLastQuestion ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium + 2)
                                .background(Color.blue)
                                .cornerRadius(Theme.CornerRadius.large)
                                .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                        } else {
                            Button(action: {
                                viewModel.submitAnswer()
                            }) {
                                HStack {
                                    Text("Submit Answer")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                }
                                .foregroundColor(viewModel.canSubmit ? .white : Theme.Colors.secondaryText.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium + 2)
                                .background(viewModel.canSubmit ? Color.green : Color.gray.opacity(0.3))
                                .cornerRadius(Theme.CornerRadius.large)
                                .shadow(color: viewModel.canSubmit ? Color.green.opacity(0.4) : Color.clear, radius: 15, x: 0, y: 8)
                            }
                            .disabled(!viewModel.canSubmit)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.vertical, Theme.Spacing.medium)
                    .background(Color.white.opacity(0.5))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Quiz")
    }
}

// MARK: - Question Card
struct QuestionCard: View {
    let question: QuizQuestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                Text("Question")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                Spacer()
            }
            
            Text(question.questionText)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .lineSpacing(4)
        }
        .padding(Theme.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.95))
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .padding(.horizontal, Theme.Spacing.large)
    }
}

// MARK: - Answer Option Card
struct AnswerOptionCard: View {
    let option: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let hasSubmitted: Bool
    let action: () -> Void
    
    private var optionLabel: String {
        return ["A", "B", "C", "D", "E"][index]
    }
    
    private var backgroundColor: Color {
        if hasSubmitted {
            if isCorrect {
                return Color.green.opacity(0.15)
            } else if isSelected {
                return Color.red.opacity(0.15)
            }
        } else if isSelected {
            return Color.blue.opacity(0.1)
        }
        return Color.white.opacity(0.9)
    }
    
    private var borderColor: Color {
        if hasSubmitted {
            if isCorrect {
                return Color.green
            } else if isSelected {
                return Color.red
            }
        } else if isSelected {
            return Color.blue
        }
        return Color.gray.opacity(0.3)
    }
    
    private var icon: String? {
        if hasSubmitted {
            if isCorrect {
                return "checkmark.circle.fill"
            } else if isSelected {
                return "xmark.circle.fill"
            }
        }
        return nil
    }
    
    private var iconColor: Color {
        if isCorrect {
            return .green
        } else {
            return .red
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.medium) {
                // Option Label
                ZStack {
                    Circle()
                        .fill(isSelected ? (hasSubmitted ? (isCorrect ? Color.green : Color.red) : Color.blue) : Color.gray.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Text(optionLabel)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white : Theme.Colors.secondaryText)
                }
                
                // Option Text
                Text(option)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.Colors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                // Result Icon
                if let iconName = icon {
                    Image(systemName: iconName)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }
            .padding(Theme.Spacing.medium)
            .background(backgroundColor)
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(borderColor, lineWidth: hasSubmitted && (isCorrect || isSelected) ? 2.5 : (isSelected ? 2 : 1))
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .disabled(hasSubmitted)
        .scaleEffect(isSelected && !hasSubmitted ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Feedback Card
struct FeedbackCard: View {
    let isCorrect: Bool
    let explanation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(isCorrect ? .green : .orange)
                
                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(isCorrect ? .green : .orange)
                
                Spacer()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Explanation")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                Text(explanation)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineSpacing(3)
            }
        }
        .padding(Theme.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isCorrect ? Color.green.opacity(0.08) : Color.orange.opacity(0.08))
        .cornerRadius(Theme.CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(isCorrect ? Color.green.opacity(0.3) : Color.orange.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Quiz Result View
struct QuizResultView: View {
    let result: QuizResult
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    private var resultColor: Color {
        switch result.feedbackColor {
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        default: return .red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.extraLarge) {
                // Trophy Icon
                Image(systemName: result.percentage >= 70 ? "trophy.fill" : "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(resultColor)
                    .padding(.top, Theme.Spacing.extraLarge)
                
                // Score Display
                VStack(spacing: Theme.Spacing.small) {
                    Text("Your Score")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Text("\(result.score)/\(result.totalQuestions)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(resultColor)
                    
                    Text("\(Int(result.percentage))%")
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
                
                // Feedback Message
                Text(result.feedbackMessage)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.extraLarge)
                
                // Stats Cards
                HStack(spacing: Theme.Spacing.medium) {
                    StatCard(
                        icon: "checkmark.circle.fill",
                        value: "\(result.score)",
                        label: "Correct",
                        color: .green
                    )
                    
                    StatCard(
                        icon: "xmark.circle.fill",
                        value: "\(result.totalQuestions - result.score)",
                        label: "Incorrect",
                        color: .red
                    )
                }
                .padding(.horizontal, Theme.Spacing.large)
                
                // Action Buttons
                VStack(spacing: Theme.Spacing.medium) {
                    Button(action: onRetry) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Retry Quiz")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.medium + 2)
                        .background(Color.blue)
                        .cornerRadius(Theme.CornerRadius.large)
                        .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    
                    Button(action: onDismiss) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Back to Algorithms")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.medium + 2)
                        .background(Color.purple)
                        .cornerRadius(Theme.CornerRadius.large)
                        .shadow(color: Color.purple.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                }
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.bottom, Theme.Spacing.extraLarge)
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.large)
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    NavigationStack {
        QuizView(algorithm: Algorithm(
            name: "Linear Search",
            description: "Search elements one by one",
            icon: "arrow.forward.circle.fill",
            complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
            category: AlgorithmCategory.allCategories[0]
        ))
    }
}
