//
//  KadaneView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct KadaneVisualizationView: View {
    @StateObject private var viewModel = KadaneViewModel()
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
                        Text("Kadane's Algorithm")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Find maximum sum contiguous subarray")
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
                                Text("Array (comma-separated, can include negatives)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., -2,1,-3,4,-1,2,1,-5,4", text: $viewModel.arrayInput)
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
                                    KadaneArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index),
                                        isInMaxSubarray: viewModel.isInMaxSubarray(at: index),
                                        isInCurrentSubarray: viewModel.isInCurrentSubarray(at: index)
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }
                    
                    // Step Information
                    if viewModel.isRunning || viewModel.isCompleted {
                        KadaneStepPanel(
                            currentSum: viewModel.currentSum,
                            maxSum: viewModel.maxSum,
                            stepInfo: viewModel.stepInfo,
                            finalResult: viewModel.finalResult,
                            isCompleted: viewModel.isCompleted
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Legend
                    if viewModel.isRunning || viewModel.isCompleted {
                        VStack(spacing: Theme.Spacing.small) {
                            HStack(spacing: Theme.Spacing.large) {
                                LegendItem(color: .blue, label: "Current Element")
                                LegendItem(color: .cyan, label: "Current Subarray")
                            }
                            HStack(spacing: Theme.Spacing.large) {
                                LegendItem(color: .orange, label: "Max Subarray")
                                LegendItem(color: .gray.opacity(0.3), label: "Checked")
                            }
                        }
                        .padding(Theme.Spacing.medium)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(Theme.CornerRadius.medium)
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity)
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
        .navigationTitle("Kadane's Algorithm")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Kadane's Algorithm",
                description: "Find maximum sum contiguous subarray",
                icon: "chart.line.uptrend.xyaxis",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Kadane Step Panel
struct KadaneStepPanel: View {
    let currentSum: Int
    let maxSum: Int
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
                if !isCompleted {
                    InfoRow(label: "Current Sum", value: "\(currentSum)", icon: "plus.circle.fill", color: .cyan)
                    InfoRow(label: "Max Sum", value: "\(maxSum)", icon: "star.circle.fill", color: .orange)
                    
                    if !stepInfo.isEmpty {
                        Divider().padding(.vertical, 4)
                        HStack {
                            Image(systemName: stepInfo.contains("New max") ? "star.fill" : "arrow.right.circle.fill")
                                .foregroundColor(stepInfo.contains("New max") ? .orange : .blue)
                            Text(stepInfo)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            Spacer()
                        }
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
struct KadaneArrayElementView: View {
    let value: Int
    let index: Int
    let state: KadaneViewModel.ElementState
    let isInMaxSubarray: Bool
    let isInCurrentSubarray: Bool
    
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
            
            if isInMaxSubarray {
                Text("MAX")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange)
                    .cornerRadius(6)
                    .transition(.scale.combined(with: .opacity))
            } else if isInCurrentSubarray && !isInMaxSubarray {
                Text("CURR")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.cyan)
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
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isInMaxSubarray)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isInCurrentSubarray)
    }
    
    private var backgroundColor: Color {
        if isInMaxSubarray {
            return Color.orange.opacity(0.2)
        } else if isInCurrentSubarray {
            return Color.cyan.opacity(0.15)
        } else if state == .current {
            return Color.blue.opacity(0.15)
        } else if state == .checked {
            return Color.gray.opacity(0.08)
        }
        return Color.white.opacity(0.95)
    }
    
    private var textColor: Color {
        if isInMaxSubarray {
            return .orange
        } else if isInCurrentSubarray {
            return .cyan
        } else if state == .current {
            return .blue
        } else if state == .checked {
            return Theme.Colors.secondaryText.opacity(0.6)
        }
        return Theme.Colors.primaryText
    }
    
    private var borderColor: Color {
        if isInMaxSubarray {
            return .orange
        } else if isInCurrentSubarray {
            return .cyan
        } else if state == .current {
            return .blue
        } else if state == .checked {
            return Color.gray.opacity(0.15)
        }
        return Color.gray.opacity(0.25)
    }
    
    private var borderWidth: CGFloat {
        if isInMaxSubarray {
            return 3.5
        } else if isInCurrentSubarray {
            return 3
        } else if state == .current {
            return 3
        }
        return 1.5
    }
    
    private var shadowColor: Color {
        if isInMaxSubarray {
            return Color.orange.opacity(0.5)
        } else if isInCurrentSubarray {
            return Color.cyan.opacity(0.4)
        } else if state == .current {
            return Color.blue.opacity(0.4)
        }
        return Color.black.opacity(0.06)
    }
    
    private var shadowRadius: CGFloat {
        if isInMaxSubarray {
            return 18
        } else if isInCurrentSubarray || state == .current {
            return 15
        }
        return 8
    }
    
    private var shadowY: CGFloat {
        if isInMaxSubarray || isInCurrentSubarray || state == .current {
            return 6
        }
        return 4
    }
    
    private var indexColor: Color {
        if isInMaxSubarray {
            return .orange
        } else if isInCurrentSubarray {
            return .cyan
        } else if state == .current {
            return .blue
        }
        return Theme.Colors.secondaryText.opacity(0.7)
    }
}

// MARK: - Legend Item
struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 20, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
        }
    }
}

#Preview {
    NavigationStack {
        KadaneVisualizationView()
    }
}
