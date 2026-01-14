//
//  RabinKarpView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct RabinKarpVisualizationView: View {
    @StateObject private var viewModel = RabinKarpViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    VStack(spacing: Theme.Spacing.small) {
                        Text("Rabin-Karp Algorithm")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Pattern matching using rolling hash")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    if !viewModel.isSearching {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Text")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                TextField("e.g., GEEKSFORGEEKS", text: $viewModel.textInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .focused($isInputFocused)
                            }
                            
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Pattern")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                TextField("e.g., GEEK", text: $viewModel.patternInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .focused($isInputFocused)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    StringVisualizationView(
                        text: viewModel.text, pattern: viewModel.pattern,
                        currentIndex: viewModel.currentIndex, patternIndex: -1,
                        matches: viewModel.matchedIndices, isMatching: viewModel.isMatching
                    )
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(title: "Start", icon: "play.fill", color: .green, isEnabled: viewModel.canStart) {
                                isInputFocused = false
                                viewModel.start()
                            }
                            EnhancedControlButton(title: "Next Step", icon: "forward.fill", color: .blue, isEnabled: viewModel.canNext) {
                                viewModel.nextStep()
                            }
                        }
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(title: "Reset", icon: "arrow.counterclockwise", color: .orange, isEnabled: viewModel.canReset) {
                                viewModel.reset()
                            }
                        }
                        if viewModel.isCompleted {
                            Button(action: { showQuiz = true }) {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "questionmark.circle.fill")
                                    Text("Take Quiz")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium + 2)
                                .background(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(Theme.CornerRadius.large)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.large)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Rabin-Karp", description: "Pattern matching using hashing",
                icon: "number.circle.fill",
                complexity: Algorithm.Complexity(time: "O(n+m)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
}

#Preview {
    NavigationStack { RabinKarpVisualizationView() }
}
