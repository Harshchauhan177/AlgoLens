//
//  NaiveStringMatchingView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct NaiveStringMatchingVisualizationView: View {
    @StateObject private var viewModel = NaiveStringMatchingViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    
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
            
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // Header Section
                    VStack(spacing: Theme.Spacing.small) {
                        Text("Naive String Matching")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Simple pattern matching character by character")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Input Section
                    if !viewModel.isSearching {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Text Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Text")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., ABABDABACDABABCABAB", text: $viewModel.textInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .focused($isInputFocused)
                            }
                            
                            // Pattern Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Pattern")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., ABABCABAB", text: $viewModel.patternInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .focused($isInputFocused)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    // Visualization Area
                    StringVisualizationView(
                        text: viewModel.text,
                        pattern: viewModel.pattern,
                        currentIndex: viewModel.currentTextIndex,
                        patternIndex: viewModel.currentPatternIndex,
                        matches: viewModel.matchedIndices,
                        isMatching: viewModel.isMatching
                    )
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    // Control Buttons
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(
                                title: "Start",
                                icon: "play.fill",
                                color: .green,
                                isEnabled: viewModel.canStart
                            ) {
                                isInputFocused = false
                                viewModel.start()
                            }
                            
                            EnhancedControlButton(
                                title: "Next Step",
                                icon: "forward.fill",
                                color: .blue,
                                isEnabled: viewModel.canNext
                            ) {
                                viewModel.nextStep()
                            }
                        }
                        
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(
                                title: "Reset",
                                icon: "arrow.counterclockwise",
                                color: .orange,
                                isEnabled: viewModel.canReset
                            ) {
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
                name: "Naive String Matching",
                description: "Simple pattern matching",
                icon: "text.magnifyingglass",
                complexity: Algorithm.Complexity(time: "O(n×m)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
}

// MARK: - String Visualization View
struct StringVisualizationView: View {
    let text: String
    let pattern: String
    let currentIndex: Int
    let patternIndex: Int
    let matches: [Int]
    let isMatching: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Text Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Text")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                            CharacterBox(
                                char: String(char),
                                isHighlighted: index == currentIndex,
                                isMatched: matches.contains(index),
                                color: .blue
                            )
                        }
                    }
                }
            }
            
            // Pattern Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Pattern")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(Array(pattern.enumerated()), id: \.offset) { index, char in
                            CharacterBox(
                                char: String(char),
                                isHighlighted: index == patternIndex && isMatching,
                                isMatched: false,
                                color: .teal
                            )
                        }
                    }
                }
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

// MARK: - Character Box
struct CharacterBox: View {
    let char: String
    let isHighlighted: Bool
    let isMatched: Bool
    let color: Color
    
    var body: some View {
        Text(char)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(isHighlighted ? .white : (isMatched ? .green : Theme.Colors.primaryText))
            .frame(width: 30, height: 40)
            .background(isHighlighted ? color : (isMatched ? Color.green.opacity(0.2) : Color.gray.opacity(0.1)))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isHighlighted ? color : (isMatched ? .green : Color.clear), lineWidth: 2)
            )
    }
}

#Preview {
    NavigationStack {
        NaiveStringMatchingVisualizationView()
    }
}
