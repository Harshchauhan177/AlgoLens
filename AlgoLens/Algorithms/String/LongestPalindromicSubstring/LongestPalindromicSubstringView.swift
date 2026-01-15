//
//  LongestPalindromicSubstringView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct LongestPalindromicSubstringVisualizationView: View {
    @StateObject private var viewModel = LongestPalindromicSubstringViewModel()
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
                        Text("Longest Palindromic Substring")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Find the longest substring that reads the same forwards and backwards")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if !viewModel.isSearching {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // String Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("String")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., babad", text: $viewModel.stringInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.stringInput) { _ in
                                        viewModel.updateFromInput()
                                    }
                            }
                            
                            // Error Message
                            if let error = viewModel.inputError {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                    Text(error)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.orange)
                                }
                                .padding(Theme.Spacing.small)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.small)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    // String Visualization Area
                    VStack(spacing: Theme.Spacing.medium) {
                        // Header with visual alignment indicator
                        VStack(spacing: Theme.Spacing.small) {
                            HStack {
                                Image(systemName: "arrow.left.and.right.text.vertical")
                                    .foregroundColor(.teal)
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Palindrome Detection Visualization")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.isSearching {
                                    HStack(spacing: 6) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text("Pos: \(viewModel.currentIndex)")
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.teal, Color.teal.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: Color.teal.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            
                            // Progress indicator
                            if viewModel.isSearching && !viewModel.isCompleted {
                                let progress = Double(viewModel.currentIndex) / Double(max(1, viewModel.stringInput.count - 1))
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Search Progress")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Theme.Colors.secondaryText)
                                        Spacer()
                                        Text("\(Int(progress * 100))%")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.teal)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.teal, Color.cyan],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        PalindromeStringVisualizationView(
                            text: viewModel.stringInput,
                            currentIndex: viewModel.currentIndex,
                            expandingIndices: viewModel.expandingIndices,
                            longestStart: viewModel.longestStart,
                            longestEnd: viewModel.longestEnd,
                            isCheckingOdd: viewModel.isCheckingOdd,
                            characterState: viewModel.characterState
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    // Step Information Panel
                    if viewModel.isSearching || viewModel.isCompleted {
                        PalindromeStepPanel(
                            currentIndex: viewModel.currentIndex,
                            currentPalindromeLength: viewModel.currentPalindromeLength,
                            maxPalindromeLength: viewModel.maxPalindromeLength,
                            longestPalindrome: viewModel.longestPalindrome,
                            stepDescription: viewModel.stepDescription,
                            finalResult: viewModel.finalResult,
                            isCheckingOdd: viewModel.isCheckingOdd,
                            isCompleted: viewModel.isCompleted
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
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
                                title: "Run Complete",
                                icon: "play.circle.fill",
                                color: .purple,
                                isEnabled: viewModel.canRunComplete
                            ) {
                                isInputFocused = false
                                viewModel.runComplete()
                            }
                            
                            EnhancedControlButton(
                                title: "Reset",
                                icon: "arrow.counterclockwise",
                                color: .orange,
                                isEnabled: viewModel.canReset
                            ) {
                                viewModel.reset()
                            }
                        }
                        
                        // Take Quiz Button
                        if viewModel.isCompleted {
                            Button(action: {
                                showQuiz = true
                            }) {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Take Quiz")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium + 2)
                                .background(
                                    LinearGradient(
                                        colors: [Color.pink, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(Theme.CornerRadius.large)
                                .shadow(color: Color.pink.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.large)
                }
            }
            .onTapGesture {
                isInputFocused = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Longest Palindromic Substring")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Longest Palindromic Substring",
                description: "Find longest palindrome",
                icon: "arrow.left.and.right",
                complexity: Algorithm.Complexity(time: "O(n²)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
}

// MARK: - Step Information Panel
struct PalindromeStepPanel: View {
    let currentIndex: Int
    let currentPalindromeLength: Int
    let maxPalindromeLength: Int
    let longestPalindrome: String
    let stepDescription: String
    let finalResult: String
    let isCheckingOdd: Bool
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.teal)
                Text("Step Information")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            VStack(spacing: Theme.Spacing.small) {
                // Current State
                if !isCompleted {
                    PalindromeInfoRow(label: "Center Position", value: "\(currentIndex)", icon: "location.circle.fill", color: .teal)
                    PalindromeInfoRow(label: "Check Type", value: isCheckingOdd ? "Odd-length" : "Even-length", icon: "arrow.left.and.right.circle.fill", color: .blue)
                    PalindromeInfoRow(label: "Current Length", value: "\(currentPalindromeLength)", icon: "ruler.fill", color: .orange)
                    PalindromeInfoRow(label: "Max Length", value: "\(maxPalindromeLength)", icon: "star.fill", color: .yellow)
                    
                    if !longestPalindrome.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "text.quote")
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Longest So Far")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                Text("'\(longestPalindrome)'")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(.teal)
                            }
                            Spacer()
                        }
                    }
                    
                    if !stepDescription.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: stepDescription.contains("✓") ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                                .foregroundColor(stepDescription.contains("✓") ? .green : .blue)
                            Text(stepDescription)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            Spacer()
                        }
                    }
                }
                
                // Final Result
                if !finalResult.isEmpty {
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.green)
                        
                        Spacer()
                    }
                }
            }
            .padding(Theme.Spacing.medium)
            .background(Color.white.opacity(0.9))
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Palindrome Info Row Helper
struct PalindromeInfoRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.Colors.primaryText)
        }
    }
}

// MARK: - Palindrome String Visualization View
struct PalindromeStringVisualizationView: View {
    let text: String
    let currentIndex: Int
    let expandingIndices: [Int]
    let longestStart: Int
    let longestEnd: Int
    let isCheckingOdd: Bool
    let characterState: (Int) -> LongestPalindromicSubstringViewModel.CharacterState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // String Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "textformat")
                        .foregroundColor(.teal.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Input String")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(text.count)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.teal.opacity(0.08))
                        .cornerRadius(6)
                }
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                                VStack(spacing: 6) {
                                    Text("\(index)")
                                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        .foregroundColor(indexColorForChar(at: index))
                                    
                                    Text(String(char))
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundColor(textColorForChar(at: index))
                                        .frame(width: 44, height: 50)
                                        .background(backgroundColorForChar(at: index))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(borderColorForChar(at: index), lineWidth: borderWidthForChar(at: index))
                                        )
                                        .shadow(color: shadowColorForChar(at: index), radius: shadowRadiusForChar(at: index), x: 0, y: 4)
                                        .scaleEffect(scaleForChar(at: index))
                                }
                                .id("char_\(index)")
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                    }
                    .onChange(of: currentIndex) { newValue in
                        if newValue >= 0 && newValue < text.count {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                proxy.scrollTo("char_\(newValue)", anchor: .center)
                            }
                        }
                    }
                }
            }
        }
        .padding(Theme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    // Helper functions for character styling
    private func indexColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .currentCenter: return .teal
        case .expanding: return .blue
        case .longestPalindrome: return .green
        default: return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
    
    private func textColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .normal: return Theme.Colors.primaryText
        case .currentCenter: return .teal
        case .expanding: return .blue
        case .longestPalindrome: return .green
        }
    }
    
    private func backgroundColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .normal: return Color.white
        case .currentCenter: return Color.teal.opacity(0.2)
        case .expanding: return Color.blue.opacity(0.15)
        case .longestPalindrome: return Color.green.opacity(0.25)
        }
    }
    
    private func borderColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .normal: return Color.gray.opacity(0.3)
        case .currentCenter: return .teal
        case .expanding: return .blue
        case .longestPalindrome: return .green
        }
    }
    
    private func borderWidthForChar(at index: Int) -> CGFloat {
        let state = characterState(index)
        switch state {
        case .currentCenter, .longestPalindrome: return 3
        case .expanding: return 2.5
        default: return 2
        }
    }
    
    private func shadowColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .currentCenter: return Color.teal.opacity(0.5)
        case .expanding: return Color.blue.opacity(0.4)
        case .longestPalindrome: return Color.green.opacity(0.5)
        default: return Color.black.opacity(0.05)
        }
    }
    
    private func shadowRadiusForChar(at index: Int) -> CGFloat {
        let state = characterState(index)
        switch state {
        case .currentCenter, .longestPalindrome: return 14
        case .expanding: return 12
        default: return 6
        }
    }
    
    private func scaleForChar(at index: Int) -> CGFloat {
        let state = characterState(index)
        return state == .currentCenter ? 1.1 : 1.0
    }
}

#Preview {
    NavigationStack {
        LongestPalindromicSubstringVisualizationView()
    }
}
