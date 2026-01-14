//
//  SubarraySumView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct SubarraySumVisualizationView: View {
    @StateObject private var viewModel = SubarraySumViewModel()
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
                        Text("Subarray Sum")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Find subarrays with target sum using prefix sum hashing")
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
                                
                                TextField("e.g., 1,2,3,7,5", text: $viewModel.arrayInput)
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
                            
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Target Sum")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 12", text: $viewModel.targetInput)
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
                            
                            Text("Target: \(viewModel.targetSum)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.purple)
                                .padding(.horizontal, Theme.Spacing.medium)
                                .padding(.vertical, Theme.Spacing.small)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.small)
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                                    SubarraySumArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index),
                                        showPointer: viewModel.showPointer(at: index)
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }
                    
                    // Prefix Sums Display
                    if viewModel.isRunning && !viewModel.prefixSums.isEmpty {
                        VStack(spacing: Theme.Spacing.medium) {
                            HStack {
                                Image(systemName: "number.circle.fill")
                                    .foregroundColor(.cyan)
                                Text("Prefix Sums Map")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                Spacer()
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.Spacing.small) {
                                    ForEach(viewModel.prefixSums.keys.sorted(), id: \.self) { key in
                                        if let value = viewModel.prefixSums[key] {
                                            PrefixSumPairView(sum: key, index: value)
                                        }
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.large)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Step Information
                    if viewModel.isRunning || viewModel.isCompleted {
                        SubarraySumStepPanel(
                            stepInfo: viewModel.stepInfo,
                            currentAction: viewModel.currentAction,
                            currentSum: viewModel.currentSum,
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
        .navigationTitle("Subarray Sum")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Subarray Sum",
                description: "Find subarrays efficiently with hashing",
                icon: "sum",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(n)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Prefix Sum Pair View
struct PrefixSumPairView: View {
    let sum: Int
    let index: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(sum)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
            
            Image(systemName: "arrow.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.cyan.opacity(0.6))
            
            Text("[\(index)]")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundColor(.cyan.opacity(0.8))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(Theme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Subarray Sum Step Panel
struct SubarraySumStepPanel: View {
    let stepInfo: String
    let currentAction: String
    let currentSum: Int
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
                    InfoRow(label: "Current Sum", value: "\(currentSum)", icon: "plus.circle.fill", color: .blue)
                }
                
                if !stepInfo.isEmpty {
                    Divider().padding(.vertical, 4)
                    HStack {
                        Image(systemName: stepInfo.contains("✓") ? "checkmark.seal.fill" : "magnifyingglass.circle.fill")
                            .foregroundColor(stepInfo.contains("✓") ? .green : .cyan)
                        Text(stepInfo)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        Spacer()
                    }
                }
                
                if !currentAction.isEmpty {
                    Divider().padding(.vertical, 4)
                    HStack {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                            .foregroundColor(isCompleted ? .green : .orange)
                        Text(currentAction)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
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
struct SubarraySumArrayElementView: View {
    let value: Int
    let index: Int
    let state: SubarraySumViewModel.ElementState
    let showPointer: Bool
    
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
            
            if showPointer {
                Text("→")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(" ")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .opacity(0)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: showPointer)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .unchecked: return Color.white.opacity(0.95)
        case .current: return Color.blue.opacity(0.15)
        case .checked: return Color.gray.opacity(0.08)
        case .found: return Color.green.opacity(0.15)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .unchecked: return Theme.Colors.primaryText
        case .current: return .blue
        case .checked: return Theme.Colors.secondaryText.opacity(0.6)
        case .found: return .green
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .unchecked: return Color.gray.opacity(0.25)
        case .current: return .blue
        case .checked: return Color.gray.opacity(0.15)
        case .found: return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current: return 3
        case .found: return 3.5
        default: return 1.5
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current: return Color.blue.opacity(0.4)
        case .found: return Color.green.opacity(0.4)
        default: return Color.black.opacity(0.06)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current: return 15
        case .found: return 18
        default: return 8
        }
    }
    
    private var shadowY: CGFloat {
        switch state {
        case .current, .found: return 6
        default: return 4
        }
    }
    
    private var indexColor: Color {
        switch state {
        case .current: return .blue
        case .found: return .green
        default: return Theme.Colors.secondaryText.opacity(0.7)
        }
    }
}

#Preview {
    NavigationStack {
        SubarraySumVisualizationView()
    }
}
