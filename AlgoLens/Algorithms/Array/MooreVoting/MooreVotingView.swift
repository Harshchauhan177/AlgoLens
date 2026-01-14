//
//  MooreVotingView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct MooreVotingVisualizationView: View {
    @StateObject private var viewModel = MooreVotingViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
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
                    // Header
                    VStack(spacing: Theme.Spacing.small) {
                        Text("Moore's Voting Algorithm")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Find majority element (appears > n/2 times)")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Input Section
                    if !viewModel.isRunning {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Array (comma-separated)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 3,3,4,2,4,4,2,4,4", text: $viewModel.arrayInput)
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
                    
                    // Candidate Info Panel
                    if viewModel.isRunning || viewModel.isCompleted {
                        VStack(spacing: Theme.Spacing.small) {
                            HStack {
                                Image(systemName: "person.fill.checkmark")
                                    .foregroundColor(.purple)
                                Text("Current Candidate")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                Spacer()
                            }
                            
                            HStack(spacing: Theme.Spacing.large) {
                                VStack(spacing: 4) {
                                    Text("Candidate")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.Colors.secondaryText)
                                    Text("\(viewModel.candidate ?? 0)")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.purple)
                                }
                                
                                Divider()
                                    .frame(height: 40)
                                
                                VStack(spacing: 4) {
                                    Text("Count")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.Colors.secondaryText)
                                    Text("\(viewModel.count)")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                            }
                            .padding(Theme.Spacing.medium)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(Theme.CornerRadius.medium)
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Array Visualization
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack {
                            Text("Array Elements")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            Spacer()
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                                    MooreVotingArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index),
                                        isCandidate: viewModel.isCandidate(at: index)
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }
                    
                    // Step Information
                    if viewModel.isRunning || viewModel.isCompleted {
                        MooreVotingStepPanel(
                            stepInfo: viewModel.stepInfo,
                            finalResult: viewModel.finalResult,
                            isCompleted: viewModel.isCompleted
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Verification Panel
                    if viewModel.isVerifying {
                        VStack(spacing: Theme.Spacing.medium) {
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(.green)
                                Text("Verification Phase")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                Spacer()
                            }
                            
                            Text(viewModel.verificationResult)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(viewModel.verificationResult.contains("✓") ? .green : .red)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(Theme.Spacing.medium)
                                .background(
                                    viewModel.verificationResult.contains("✓") ?
                                    Color.green.opacity(0.1) : Color.red.opacity(0.1)
                                )
                                .cornerRadius(Theme.CornerRadius.medium)
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .scale))
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
                        
                        if viewModel.canVerify {
                            Button(action: {
                                viewModel.verify()
                            }) {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "checkmark.shield.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Verify Candidate")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium)
                                .background(
                                    LinearGradient(
                                        colors: [Color.green, Color.green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(Theme.CornerRadius.large)
                                .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                        
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
        .navigationTitle("Moore's Voting")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Moore's Voting",
                description: "Find majority element efficiently",
                icon: "chart.bar.fill",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Moore Voting Step Panel
struct MooreVotingStepPanel: View {
    let stepInfo: String
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
                if !stepInfo.isEmpty && !isCompleted {
                    HStack {
                        Image(systemName: stepInfo.contains("New candidate") ? "person.crop.circle.badge.plus" : "arrow.right.circle.fill")
                            .foregroundColor(stepInfo.contains("New candidate") ? .purple : .blue)
                        Text(stepInfo)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        Spacer()
                    }
                }
                
                if !finalResult.isEmpty {
                    Divider().padding(.vertical, 4)
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

// MARK: - Array Element View
struct MooreVotingArrayElementView: View {
    let value: Int
    let index: Int
    let state: MooreVotingViewModel.ElementState
    let isCandidate: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("[\(index)]")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
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
            
            if isCandidate && state == .checked {
                Text("CAND")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.purple)
                    .cornerRadius(6)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(" ")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .opacity(0)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isCandidate)
    }
    
    private var backgroundColor: Color {
        if state == .current {
            return Color.blue.opacity(0.15)
        } else if isCandidate && state == .checked {
            return Color.purple.opacity(0.15)
        } else if state == .checked {
            return Color.gray.opacity(0.08)
        }
        return Color.white.opacity(0.95)
    }
    
    private var textColor: Color {
        if state == .current {
            return .blue
        } else if isCandidate && state == .checked {
            return .purple
        } else if state == .checked {
            return Theme.Colors.secondaryText.opacity(0.6)
        }
        return Theme.Colors.primaryText
    }
    
    private var borderColor: Color {
        if state == .current {
            return .blue
        } else if isCandidate && state == .checked {
            return .purple
        } else if state == .checked {
            return Color.gray.opacity(0.15)
        }
        return Color.gray.opacity(0.25)
    }
    
    private var borderWidth: CGFloat {
        if state == .current {
            return 3
        } else if isCandidate && state == .checked {
            return 2.5
        }
        return 1.5
    }
    
    private var shadowColor: Color {
        if state == .current {
            return Color.blue.opacity(0.4)
        } else if isCandidate && state == .checked {
            return Color.purple.opacity(0.3)
        }
        return Color.black.opacity(0.06)
    }
    
    private var shadowRadius: CGFloat {
        if state == .current {
            return 15
        } else if isCandidate && state == .checked {
            return 10
        }
        return 8
    }
    
    private var shadowY: CGFloat {
        if state == .current {
            return 6
        } else if isCandidate && state == .checked {
            return 4
        }
        return 4
    }
    
    private var indexColor: Color {
        if state == .current {
            return .blue
        } else if isCandidate && state == .checked {
            return .purple
        }
        return Theme.Colors.secondaryText.opacity(0.7)
    }
}

#Preview {
    NavigationStack {
        MooreVotingVisualizationView()
    }
}
