//
//  SubsequenceCheckView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct SubsequenceCheckVisualizationView: View {
    @StateObject private var viewModel = SubsequenceCheckViewModel()
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
                        Text("Subsequence Check")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Check if one string is a subsequence of another")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if !viewModel.isChecking {
                        inputSection
                    }
                    
                    // String Visualization Area
                    visualizationSection
                    
                    // Step Information Panel
                    if viewModel.isChecking || viewModel.isCompleted {
                        stepInfoPanel
                    }
                    
                    // Control Buttons
                    controlButtons
                }
            }
            .onTapGesture {
                isInputFocused = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Subsequence Check")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Subsequence Check",
                description: "Check if string is subsequence",
                icon: "arrow.down.right.circle.fill",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Text("Input Data")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Main String Input
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Main String")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                TextField("e.g., ahbgdc", text: $viewModel.mainStringInput)
                    .font(.system(size: 15, design: .monospaced))
                    .padding(Theme.Spacing.medium)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .focused($isInputFocused)
                    .onChange(of: viewModel.mainStringInput) { _ in
                        viewModel.updateFromInputs()
                    }
            }
            
            // Subsequence Input
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Subsequence to Check")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                TextField("e.g., abc", text: $viewModel.subsequenceInput)
                    .font(.system(size: 15, design: .monospaced))
                    .padding(Theme.Spacing.medium)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .focused($isInputFocused)
                    .onChange(of: viewModel.subsequenceInput) { _ in
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
    
    // MARK: - Visualization Section
    private var visualizationSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Header
            VStack(spacing: Theme.Spacing.small) {
                HStack {
                    Image(systemName: "arrow.down.right.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Subsequence Check Visualization")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Spacer()
                    
                    if viewModel.isChecking {
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12, weight: .bold))
                            Text("Pos: \(viewModel.mainStringIndex)")
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
                if viewModel.isChecking && !viewModel.isCompleted {
                    progressBar
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
            
            SubsequenceVisualizationView(
                mainString: viewModel.mainString,
                subsequence: viewModel.subsequence,
                mainStringIndex: viewModel.mainStringIndex,
                subsequenceIndex: viewModel.subsequenceIndex,
                matchedIndices: viewModel.matchedIndices,
                isMatching: viewModel.isMatching,
                mainStringCharacterState: viewModel.mainStringCharacterState,
                subsequenceCharacterState: viewModel.subsequenceCharacterState
            )
            .padding(.horizontal, Theme.Spacing.large)
        }
    }
    
    // MARK: - Progress Bar
    private var progressBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            let progress = Double(viewModel.mainStringIndex) / Double(max(1, viewModel.mainString.count))
            
            HStack {
                Text("Check Progress")
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
    
    // MARK: - Step Info Panel
    private var stepInfoPanel: some View {
        SubsequenceStepPanel(
            mainStringIndex: viewModel.mainStringIndex,
            subsequenceIndex: viewModel.subsequenceIndex,
            subsequenceLength: viewModel.subsequence.count,
            comparisonResult: viewModel.comparisonResult,
            finalResult: viewModel.finalResult,
            matchedCount: viewModel.matchedIndices.count,
            isCompleted: viewModel.isCompleted
        )
        .padding(.horizontal, Theme.Spacing.large)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    // MARK: - Control Buttons
    private var controlButtons: some View {
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

// MARK: - Step Information Panel
struct SubsequenceStepPanel: View {
    let mainStringIndex: Int
    let subsequenceIndex: Int
    let subsequenceLength: Int
    let comparisonResult: String
    let finalResult: String
    let matchedCount: Int
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
                    InfoRow(label: "Main String Position", value: "\(mainStringIndex)", icon: "arrow.right.circle.fill", color: .blue)
                    InfoRow(label: "Subsequence Progress", value: "\(subsequenceIndex)/\(subsequenceLength)", icon: "number.circle.fill", color: .purple)
                    InfoRow(label: "Characters Matched", value: "\(matchedCount)", icon: "checkmark.seal.fill", color: .green)
                    
                    if !comparisonResult.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: comparisonResult.contains("✓") ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(comparisonResult.contains("✓") ? .green : .orange)
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
                        Image(systemName: finalResult.contains("✅") ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(finalResult.contains("✅") ? .green : .red)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(finalResult.contains("✅") ? .green : .red)
                        
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

// MARK: - Subsequence Visualization View
struct SubsequenceVisualizationView: View {
    let mainString: String
    let subsequence: String
    let mainStringIndex: Int
    let subsequenceIndex: Int
    let matchedIndices: [Int]
    let isMatching: Bool
    let mainStringCharacterState: (Int) -> SubsequenceCheckViewModel.CharacterState
    let subsequenceCharacterState: (Int) -> SubsequenceCheckViewModel.CharacterState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Main String Display
            mainStringView
            
            // Visual separator
            if mainStringIndex >= 0 {
                HStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Subsequence Display
            subsequenceView
        }
        .padding(Theme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var mainStringView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue.opacity(0.7))
                    .font(.system(size: 14, weight: .semibold))
                Text("Main String")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                Spacer()
                
                Text("Length: \(mainString.count)")
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
                        ForEach(Array(mainString.enumerated()), id: \.offset) { index, char in
                            CharacterBoxView(
                                char: String(char),
                                index: index,
                                state: mainStringCharacterState(index)
                            )
                            .id("main_\(index)")
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                }
                .onChange(of: mainStringIndex) { newValue in
                    if newValue >= 0 && newValue < mainString.count {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            proxy.scrollTo("main_\(newValue)", anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    private var subsequenceView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.purple.opacity(0.7))
                    .font(.system(size: 14, weight: .semibold))
                Text("Subsequence to Match")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                Spacer()
                
                Text("Length: \(subsequence.count)")
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
                        ForEach(Array(subsequence.enumerated()), id: \.offset) { index, char in
                            CharacterBoxView(
                                char: String(char),
                                index: index,
                                state: subsequenceCharacterState(index)
                            )
                            .id("sub_\(index)")
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                }
                .onChange(of: subsequenceIndex) { newValue in
                    if newValue >= 0 && newValue < subsequence.count {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            proxy.scrollTo("sub_\(newValue)", anchor: .center)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Character Box View
struct CharacterBoxView: View {
    let char: String
    let index: Int
    let state: SubsequenceCheckViewModel.CharacterState
    
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
    
    private var indexColor: Color {
        switch state {
        case .current: return .blue
        case .matched: return .green
        default: return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .normal: return Theme.Colors.primaryText
        case .current: return .blue
        case .visited: return Theme.Colors.primaryText.opacity(0.5)
        case .matched: return .green
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .normal: return Color.white
        case .current: return Color.blue.opacity(0.2)
        case .visited: return Color.gray.opacity(0.1)
        case .matched: return Color.green.opacity(0.25)
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .normal: return Color.gray.opacity(0.3)
        case .current: return .blue
        case .visited: return Color.gray.opacity(0.2)
        case .matched: return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current: return 3
        case .matched: return 2.5
        default: return 2
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current: return Color.blue.opacity(0.5)
        case .matched: return Color.green.opacity(0.5)
        default: return Color.black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current: return 14
        case .matched: return 12
        default: return 6
        }
    }
}

#Preview {
    NavigationStack {
        SubsequenceCheckVisualizationView()
    }
}
