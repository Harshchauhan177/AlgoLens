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
                    
                    // Dynamic Input Section
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
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.textInput) { _ in
                                        viewModel.updateFromInputs()
                                    }
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
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.patternInput) { _ in
                                        viewModel.updateFromInputs()
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
                                Image(systemName: "text.magnifyingglass")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Pattern Matching Visualization")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.isSearching {
                                    HStack(spacing: 6) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text("Pos: \(viewModel.currentTextIndex)")
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.blue, Color.blue.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            
                            // Progress indicator
                            if viewModel.isSearching && !viewModel.isCompleted {
                                let progress = Double(viewModel.currentTextIndex) / Double(max(1, viewModel.text.count - viewModel.pattern.count))
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Search Progress")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Theme.Colors.secondaryText)
                                        Spacer()
                                        Text("\(Int(progress * 100))%")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.blue, Color.purple],
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
                        
                        ImprovedStringVisualizationView(
                            text: viewModel.text,
                            pattern: viewModel.pattern,
                            currentIndex: viewModel.currentTextIndex,
                            patternIndex: viewModel.currentPatternIndex,
                            matchedIndices: viewModel.matchedIndices,
                            isMatching: viewModel.isMatching,
                            characterState: viewModel.characterState
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    // Step Information Panel
                    if viewModel.isSearching || viewModel.isCompleted {
                        StringMatchingStepPanel(
                            currentIndex: viewModel.currentTextIndex,
                            patternIndex: viewModel.currentPatternIndex,
                            patternLength: viewModel.pattern.count,
                            comparisonResult: viewModel.comparisonResult,
                            finalResult: viewModel.finalResult,
                            foundCount: viewModel.foundPositions.count,
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
        .navigationTitle("Naive String Matching")
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

// MARK: - Step Information Panel
struct StringMatchingStepPanel: View {
    let currentIndex: Int
    let patternIndex: Int
    let patternLength: Int
    let comparisonResult: String
    let finalResult: String
    let foundCount: Int
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Step Information")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            VStack(spacing: Theme.Spacing.small) {
                // Current State
                if !isCompleted {
                    InfoRow(label: "Text Position", value: "\(currentIndex)", icon: "arrow.right.circle.fill", color: .blue)
                    InfoRow(label: "Pattern Index", value: "\(patternIndex)/\(patternLength)", icon: "number.circle.fill", color: .purple)
                    InfoRow(label: "Matches Found", value: "\(foundCount)", icon: "checkmark.seal.fill", color: .green)
                    
                    if !comparisonResult.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: comparisonResult.contains("✓") || comparisonResult.contains("🎯") ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(comparisonResult.contains("✓") || comparisonResult.contains("🎯") ? .green : .orange)
                            Text(comparisonResult)
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
                        Image(systemName: finalResult.contains("Success") ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(finalResult.contains("Success") ? .green : .orange)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(finalResult.contains("Success") ? .green : .orange)
                        
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

// MARK: - String Visualization View
struct StringVisualizationView: View {
    let text: String
    let pattern: String
    let currentIndex: Int
    let patternIndex: Int
    let matchedIndices: [Int]
    let isMatching: Bool
    let characterState: (Int) -> NaiveStringMatchingViewModel.CharacterState
    
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
                            EnhancedCharacterBox(
                                char: String(char),
                                index: index,
                                state: characterState(index)
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
                            PatternCharacterBox(
                                char: String(char),
                                index: index,
                                isHighlighted: index == patternIndex && isMatching,
                                isMatched: index < patternIndex
                            )
                        }
                    }
                }
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Enhanced Character Box
struct EnhancedCharacterBox: View {
    let char: String
    let index: Int
    let state: NaiveStringMatchingViewModel.CharacterState
    
    var body: some View {
        VStack(spacing: 4) {
            Text("[\(index)]")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            Text(char)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(textColor)
                .frame(width: 40, height: 45)
                .background(backgroundColor)
                .cornerRadius(Theme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
                .scaleEffect(state == .current ? 1.08 : 1.0)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .normal:
            return Color.white.opacity(0.95)
        case .comparing:
            return Color.blue.opacity(0.08)
        case .current:
            return Color.blue.opacity(0.15)
        case .matching:
            return Color.green.opacity(0.1)
        case .matched:
            return Color.green.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .normal:
            return Theme.Colors.primaryText
        case .comparing:
            return .blue.opacity(0.7)
        case .current:
            return .blue
        case .matching:
            return .green.opacity(0.8)
        case .matched:
            return .green
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .normal:
            return Color.gray.opacity(0.25)
        case .comparing:
            return Color.blue.opacity(0.3)
        case .current:
            return .blue
        case .matching:
            return Color.green.opacity(0.5)
        case .matched:
            return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current:
            return 3
        case .matched:
            return 2.5
        default:
            return 1.5
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current:
            return Color.blue.opacity(0.4)
        case .matched:
            return Color.green.opacity(0.4)
        default:
            return Color.black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current:
            return 12
        case .matched:
            return 10
        default:
            return 6
        }
    }
    
    private var indexColor: Color {
        switch state {
        case .current:
            return .blue
        case .matched:
            return .green
        default:
            return Theme.Colors.secondaryText.opacity(0.7)
        }
    }
}

// MARK: - Pattern Character Box
struct PatternCharacterBox: View {
    let char: String
    let index: Int
    let isHighlighted: Bool
    let isMatched: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("[\(index)]")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            Text(char)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(textColor)
                .frame(width: 40, height: 45)
                .background(backgroundColor)
                .cornerRadius(Theme.CornerRadius.medium)
                .overlay(overlayContent)
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
                .scaleEffect(scaleAmount)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isHighlighted)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isMatched)
    }
    
    private var indexColor: Color {
        if isHighlighted { return .blue }
        if isMatched { return .green }
        return Theme.Colors.secondaryText.opacity(0.7)
    }
    
    private var textColor: Color {
        if isHighlighted { return .blue }
        if isMatched { return .green }
        return Theme.Colors.primaryText
    }
    
    private var backgroundColor: Color {
        if isHighlighted { return Color.blue.opacity(0.15) }
        if isMatched { return Color.green.opacity(0.1) }
        return Color.white.opacity(0.95)
    }
    
    private var borderColor: Color {
        if isHighlighted { return Color.blue }
        if isMatched { return Color.green.opacity(0.5) }
        return Color.gray.opacity(0.25)
    }
    
    private var borderWidth: CGFloat {
        isHighlighted ? 3 : 1.5
    }
    
    private var overlayContent: some View {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    private var shadowColor: Color {
        isHighlighted ? Color.blue.opacity(0.4) : Color.black.opacity(0.05)
    }
    
    private var shadowRadius: CGFloat {
        isHighlighted ? 12 : 6
    }
    
    private var scaleAmount: CGFloat {
        isHighlighted ? 1.08 : 1.0
    }
}

// MARK: - Improved String Visualization View
struct ImprovedStringVisualizationView: View {
    let text: String
    let pattern: String
    let currentIndex: Int
    let patternIndex: Int
    let matchedIndices: [Int]
    let isMatching: Bool
    let characterState: (Int) -> NaiveStringMatchingViewModel.CharacterState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Text Display with sliding pattern indicator
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Text String")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(text.count)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(6)
                }
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                                VStack(spacing: 6) {
                                    Text("\(index)")
                                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        .foregroundColor(indexColorForText(at: index))
                                    
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
                                        .scaleEffect(characterState(index) == .current ? 1.1 : 1.0)
                                }
                                .id(index)
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                        .onChange(of: currentIndex) { newValue in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                }
            }
            
            // Visual separator
            if currentIndex >= 0 {
                HStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Pattern Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.purple.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Pattern to Match")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(pattern.count)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.08))
                        .cornerRadius(6)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(pattern.enumerated()), id: \.offset) { index, char in
                            VStack(spacing: 6) {
                                Text("\(index)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .foregroundColor(indexColorForPattern(at: index))
                                
                                Text(String(char))
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                                    .foregroundColor(textColorForPattern(at: index))
                                    .frame(width: 44, height: 50)
                                    .background(backgroundColorForPattern(at: index))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(borderColorForPattern(at: index), lineWidth: borderWidthForPattern(at: index))
                                    )
                                    .shadow(color: shadowColorForPattern(at: index), radius: shadowRadiusForPattern(at: index), x: 0, y: 4)
                                    .scaleEffect(index == patternIndex && isMatching ? 1.1 : 1.0)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
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
    
    // Helper functions for text character styling
    private func indexColorForText(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .current: return .blue
        case .matched: return .green
        default: return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
    
    private func textColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .normal: return Theme.Colors.primaryText
        case .comparing: return .blue.opacity(0.7)
        case .current: return .blue
        case .matching: return .green.opacity(0.8)
        case .matched: return .green
        }
    }
    
    private func backgroundColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .normal: return Color.white
        case .comparing: return Color.blue.opacity(0.1)
        case .current: return Color.blue.opacity(0.2)
        case .matching: return Color.green.opacity(0.15)
        case .matched: return Color.green.opacity(0.25)
        }
    }
    
    private func borderColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .normal: return Color.gray.opacity(0.3)
        case .comparing: return Color.blue.opacity(0.4)
        case .current: return .blue
        case .matching: return Color.green.opacity(0.6)
        case .matched: return .green
        }
    }
    
    private func borderWidthForChar(at index: Int) -> CGFloat {
        let state = characterState(index)
        switch state {
        case .current: return 3
        case .matched, .matching: return 2.5
        default: return 2
        }
    }
    
    private func shadowColorForChar(at index: Int) -> Color {
        let state = characterState(index)
        switch state {
        case .current: return Color.blue.opacity(0.5)
        case .matched: return Color.green.opacity(0.5)
        default: return Color.black.opacity(0.05)
        }
    }
    
    private func shadowRadiusForChar(at index: Int) -> CGFloat {
        let state = characterState(index)
        switch state {
        case .current: return 14
        case .matched: return 12
        default: return 6
        }
    }
    
    // Helper functions for pattern character styling
    private func indexColorForPattern(at index: Int) -> Color {
        if index == patternIndex && isMatching { return .blue }
        if index < patternIndex { return .green }
        return Theme.Colors.secondaryText.opacity(0.6)
    }
    
    private func textColorForPattern(at index: Int) -> Color {
        if index == patternIndex && isMatching { return .blue }
        if index < patternIndex { return .green }
        return Theme.Colors.primaryText
    }
    
    private func backgroundColorForPattern(at index: Int) -> Color {
        if index == patternIndex && isMatching { return Color.blue.opacity(0.2) }
        if index < patternIndex { return Color.green.opacity(0.15) }
        return Color.white
    }
    
    private func borderColorForPattern(at index: Int) -> Color {
        if index == patternIndex && isMatching { return .blue }
        if index < patternIndex { return .green }
        return Color.gray.opacity(0.3)
    }
    
    private func borderWidthForPattern(at index: Int) -> CGFloat {
        if index == patternIndex && isMatching { return 3 }
        if index < patternIndex { return 2.5 }
        return 2
    }
    
    private func shadowColorForPattern(at index: Int) -> Color {
        if index == patternIndex && isMatching { return Color.blue.opacity(0.5) }
        if index < patternIndex { return Color.green.opacity(0.5) }
        return Color.black.opacity(0.05)
    }
    
    private func shadowRadiusForPattern(at index: Int) -> CGFloat {
        if index == patternIndex && isMatching { return 14 }
        if index < patternIndex { return 12 }
        return 6
    }
}

#Preview {
    NavigationStack {
        NaiveStringMatchingVisualizationView()
    }
}
