//
//  AnagramCheckView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct AnagramCheckVisualizationView: View {
    @StateObject private var viewModel = AnagramCheckViewModel()
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
                        Text("Anagram Check")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Check if two strings are anagrams of each other")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if !viewModel.isChecking {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // First String Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("First String")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., listen", text: $viewModel.string1Input)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.string1Input) { _ in
                                        viewModel.updateFromInputs()
                                    }
                            }
                            
                            // Second String Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Second String")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., silent", text: $viewModel.string2Input)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.string2Input) { _ in
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
                        // Header
                        VStack(spacing: Theme.Spacing.small) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Anagram Check Visualization")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.isChecking && !viewModel.isCompleted {
                                    HStack(spacing: 6) {
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text(phaseText)
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.blue, Color.purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            
                            // Progress indicator
                            if viewModel.isChecking && !viewModel.isCompleted {
                                let progress = calculateProgress()
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Progress")
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
                        
                        AnagramVisualizationView(
                            string1: viewModel.string1,
                            string2: viewModel.string2,
                            currentString1Index: viewModel.currentString1Index,
                            currentString2Index: viewModel.currentString2Index,
                            charCountMap: viewModel.charCountMap,
                            currentPhase: viewModel.currentPhase,
                            characterState1: viewModel.characterState1,
                            characterState2: viewModel.characterState2
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    // Step Information Panel
                    if viewModel.isChecking || viewModel.isCompleted {
                        AnagramStepPanel(
                            currentPhase: viewModel.currentPhase,
                            stepDescription: viewModel.stepDescription,
                            finalResult: viewModel.finalResult,
                            charCountMap: viewModel.charCountMap,
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
        .navigationTitle("Anagram Check")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Anagram Check",
                description: "Check if strings are anagrams",
                icon: "arrow.triangle.2.circlepath",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
    
    private var phaseText: String {
        switch viewModel.currentPhase {
        case .idle: return "Idle"
        case .checkingLength: return "Checking Length"
        case .countingString1: return "Counting"
        case .verifyingString2: return "Verifying"
        case .completed: return "Completed"
        }
    }
    
    private func calculateProgress() -> Double {
        switch viewModel.currentPhase {
        case .idle: return 0.0
        case .checkingLength: return 0.1
        case .countingString1:
            let total = Double(viewModel.string1.count)
            let current = Double(viewModel.currentString1Index)
            return 0.1 + (current / total) * 0.4
        case .verifyingString2:
            let total = Double(viewModel.string2.count)
            let current = Double(viewModel.currentString2Index)
            return 0.5 + (current / total) * 0.5
        case .completed: return 1.0
        }
    }
}

// MARK: - Step Information Panel
struct AnagramStepPanel: View {
    let currentPhase: AnagramCheckViewModel.Phase
    let stepDescription: String
    let finalResult: String
    let charCountMap: [Character: Int]
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
                // Current Phase
                if !isCompleted {
                    InfoRow(label: "Current Phase", value: phaseDescription, icon: "gearshape.fill", color: .blue)
                    
                    // Character Count Map
                    if currentPhase == .countingString1 || currentPhase == .verifyingString2 {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "list.bullet.rectangle")
                                    .foregroundColor(.purple)
                                Text("Character Counts")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.Colors.primaryText)
                            }
                            
                            if !charCountMap.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(Array(charCountMap.keys.sorted()), id: \.self) { char in
                                            if let count = charCountMap[char] {
                                                CharCountBadge(char: String(char), count: count)
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("No characters counted yet")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                                    .italic()
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    if !stepDescription.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: stepDescription.contains("✓") || stepDescription.contains("🎉") ? "checkmark.circle.fill" : (stepDescription.contains("❌") ? "xmark.circle.fill" : "arrow.right.circle.fill"))
                                .foregroundColor(stepDescription.contains("✓") || stepDescription.contains("🎉") ? .green : (stepDescription.contains("❌") ? .red : .blue))
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
                        Image(systemName: finalResult.contains("Success") || finalResult.contains("🎉") ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(finalResult.contains("Success") || finalResult.contains("🎉") ? .green : .red)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(finalResult.contains("Success") || finalResult.contains("🎉") ? .green : .red)
                        
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
    
    private var phaseDescription: String {
        switch currentPhase {
        case .idle: return "Ready to start"
        case .checkingLength: return "Checking string lengths"
        case .countingString1: return "Counting characters in first string"
        case .verifyingString2: return "Verifying second string"
        case .completed: return "Check completed"
        }
    }
}

// MARK: - Character Count Badge
struct CharCountBadge: View {
    let char: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Text(char)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.purple)
            Text(":")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            Text("\(count)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(count > 0 ? Color.purple.opacity(0.1) : Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(count > 0 ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
    }
}

// MARK: - Anagram Visualization View
struct AnagramVisualizationView: View {
    let string1: String
    let string2: String
    let currentString1Index: Int
    let currentString2Index: Int
    let charCountMap: [Character: Int]
    let currentPhase: AnagramCheckViewModel.Phase
    let characterState1: (Int) -> AnagramCheckViewModel.CharacterState
    let characterState2: (Int) -> AnagramCheckViewModel.CharacterState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // First String Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("First String")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(string1.count)")
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
                            ForEach(Array(string1.enumerated()), id: \.offset) { index, char in
                                AnagramCharacterBox(
                                    char: String(char),
                                    index: index,
                                    state: characterState1(index),
                                    colorScheme: .blue
                                )
                                .id("string1_\(index)")
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                    }
                    .onChange(of: currentString1Index) { newValue in
                        if newValue >= 0 && newValue < string1.count {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                proxy.scrollTo("string1_\(newValue)", anchor: .center)
                            }
                        }
                    }
                }
            }
            
            // Visual separator
            if currentPhase != .idle {
                HStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Second String Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(.purple.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Second String")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(string2.count)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.08))
                        .cornerRadius(6)
                }
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(string2.enumerated()), id: \.offset) { index, char in
                                AnagramCharacterBox(
                                    char: String(char),
                                    index: index,
                                    state: characterState2(index),
                                    colorScheme: .purple
                                )
                                .id("string2_\(index)")
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                    }
                    .onChange(of: currentString2Index) { newValue in
                        if newValue >= 0 && newValue < string2.count {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                proxy.scrollTo("string2_\(newValue)", anchor: .center)
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
}

// MARK: - Anagram Character Box
struct AnagramCharacterBox: View {
    let char: String
    let index: Int
    let state: AnagramCheckViewModel.CharacterState
    let colorScheme: ColorScheme
    
    enum ColorScheme {
        case blue, purple
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(index)")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            Text(char)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(textColor)
                .frame(width: 44, height: 50)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
                .scaleEffect(state == .current ? 1.1 : 1.0)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
    }
    
    private var baseColor: Color {
        colorScheme == .blue ? .blue : .purple
    }
    
    private var indexColor: Color {
        switch state {
        case .current: return baseColor
        case .processed, .verified: return .green
        case .mismatch: return .red
        default: return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .normal: return Theme.Colors.primaryText
        case .current: return baseColor
        case .processed, .verified: return .green
        case .mismatch: return .red
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .normal: return Color.white
        case .current: return baseColor.opacity(0.2)
        case .processed, .verified: return Color.green.opacity(0.15)
        case .mismatch: return Color.red.opacity(0.15)
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .normal: return Color.gray.opacity(0.3)
        case .current: return baseColor
        case .processed, .verified: return .green
        case .mismatch: return .red
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current: return 3
        case .processed, .verified, .mismatch: return 2.5
        default: return 2
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current: return baseColor.opacity(0.5)
        case .processed, .verified: return Color.green.opacity(0.5)
        case .mismatch: return Color.red.opacity(0.5)
        default: return Color.black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current: return 14
        case .processed, .verified, .mismatch: return 12
        default: return 6
        }
    }
}

#Preview {
    NavigationStack {
        AnagramCheckVisualizationView()
    }
}
