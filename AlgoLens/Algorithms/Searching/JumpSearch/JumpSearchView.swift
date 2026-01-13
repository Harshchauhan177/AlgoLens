//
//  JumpSearchView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI

struct JumpSearchView: View {
    @StateObject private var viewModel = JumpSearchViewModel()
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
                        Text("Jump Search")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Jump ahead by √n steps, then linear search")
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
                            
                            // Array Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Array (comma-separated)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 1,3,5,7,9,11,13,15", text: $viewModel.arrayInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.arrayInput) { _ in
                                        viewModel.updateFromInputs()
                                    }
                            }
                            
                            // Target Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Target Value")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 13", text: $viewModel.targetInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.targetInput) { _ in
                                        viewModel.updateFromInputs()
                                    }
                            }
                            
                            // Auto-sort Notice
                            HStack(spacing: Theme.Spacing.small) {
                                Image(systemName: "arrow.up.arrow.down.circle.fill")
                                    .foregroundColor(.green)
                                Text("Array is automatically sorted for Jump Search")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                            }
                            .padding(Theme.Spacing.small)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.green.opacity(0.08))
                            .cornerRadius(Theme.CornerRadius.small)
                            
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
                    
                    // Array Visualization Area
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack {
                            Text("Array Elements")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            Spacer()
                            
                            Text("Target: \(viewModel.target)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.blue)
                                .padding(.horizontal, Theme.Spacing.medium)
                                .padding(.vertical, Theme.Spacing.small)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.small)
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                                    JumpSearchArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index),
                                        isJumpPoint: viewModel.isJumpPoint(at: index)
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }
                    
                    // Step Information Panel
                    if viewModel.isSearching || viewModel.isCompleted {
                        JumpSearchStepInformationPanel(
                            currentPhase: viewModel.currentPhase,
                            jumpStep: viewModel.jumpStep,
                            currentIndex: viewModel.currentIndex,
                            previousJump: viewModel.previousJump,
                            stepDescription: viewModel.stepDescription,
                            comparisonResult: viewModel.comparisonResult,
                            finalResult: viewModel.finalResult,
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
                        
                        // Take Quiz Button (shown when completed)
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
        .navigationTitle("Jump Search")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Jump Search",
                description: "Jump ahead by √n steps, then linear search",
                icon: "arrow.forward.to.line.circle.fill",
                complexity: Algorithm.Complexity(time: "O(√n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[0]
            ))
        }
    }
}

// MARK: - Jump Search Step Information Panel
struct JumpSearchStepInformationPanel: View {
    let currentPhase: String
    let jumpStep: Int
    let currentIndex: Int
    let previousJump: Int
    let stepDescription: String
    let comparisonResult: String
    let finalResult: String
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
                    InfoRow(label: "Phase", value: currentPhase, icon: "arrow.triangle.branch", color: .purple)
                    
                    if jumpStep > 0 {
                        InfoRow(label: "Jump Step", value: "√n = \(jumpStep)", icon: "arrow.forward", color: .orange)
                    }
                    
                    if currentIndex >= 0 {
                        InfoRow(label: "Current Index", value: "\(currentIndex)", icon: "location.circle.fill", color: .blue)
                    }
                    
                    if !stepDescription.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(.cyan)
                            Text(stepDescription)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            Spacer()
                        }
                    }
                    
                    if !comparisonResult.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: comparisonResult.contains("✓") ? "checkmark.circle.fill" : "arrow.right.circle.fill")
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
                        Image(systemName: finalResult.contains("Success") ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(finalResult.contains("Success") ? .green : .red)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(finalResult.contains("Success") ? .green : .red)
                        
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

// MARK: - Jump Search Array Element View
struct JumpSearchArrayElementView: View {
    let value: Int
    let index: Int
    let state: JumpSearchViewModel.ElementState
    let isJumpPoint: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            // Index Label
            Text("[\(index)]")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            // Value Box
            ZStack {
                Text("\(value)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                    .frame(width: 70, height: 70)
                    .background(backgroundColor)
                    .cornerRadius(Theme.CornerRadius.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
                    .scaleEffect(state == .current ? 1.08 : 1.0)
                
                // Jump Point Indicator
                if isJumpPoint && state != .current && state != .found {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 8, height: 8)
                                .padding(6)
                        }
                    }
                }
            }
            
            // State Label
            if state == .current {
                Text("Current")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange)
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
            } else if state == .found {
                Text("Found!")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.green)
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
            } else {
                // Spacer to maintain layout
                Text(" ")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .opacity(0)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .unchecked:
            return Color.white.opacity(0.95)
        case .current:
            return Color.orange.opacity(0.15)
        case .jumped:
            return Color.gray.opacity(0.08)
        case .inBlock:
            return Color.cyan.opacity(0.12)
        case .checked:
            return Color.gray.opacity(0.08)
        case .found:
            return Color.green.opacity(0.15)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .unchecked:
            return Theme.Colors.primaryText
        case .current:
            return .orange
        case .jumped:
            return Theme.Colors.secondaryText.opacity(0.5)
        case .inBlock:
            return .cyan
        case .checked:
            return Theme.Colors.secondaryText.opacity(0.6)
        case .found:
            return .green
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .unchecked:
            return Color.gray.opacity(0.25)
        case .current:
            return .orange
        case .jumped:
            return Color.gray.opacity(0.15)
        case .inBlock:
            return .cyan
        case .checked:
            return Color.gray.opacity(0.15)
        case .found:
            return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current:
            return 3
        case .found:
            return 3.5
        case .inBlock:
            return 2
        default:
            return 1.5
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current:
            return Color.orange.opacity(0.4)
        case .inBlock:
            return Color.cyan.opacity(0.3)
        case .found:
            return Color.green.opacity(0.4)
        default:
            return Color.black.opacity(0.06)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current:
            return 15
        case .found:
            return 18
        case .inBlock:
            return 12
        default:
            return 8
        }
    }
    
    private var shadowY: CGFloat {
        switch state {
        case .current, .found:
            return 6
        case .inBlock:
            return 5
        default:
            return 4
        }
    }
    
    private var indexColor: Color {
        switch state {
        case .current:
            return .orange
        case .inBlock:
            return .cyan
        case .found:
            return .green
        case .jumped:
            return Theme.Colors.secondaryText.opacity(0.4)
        default:
            return Theme.Colors.secondaryText.opacity(0.7)
        }
    }
}

#Preview {
    NavigationStack {
        JumpSearchView()
    }
}
