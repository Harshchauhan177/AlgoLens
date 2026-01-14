//
//  DutchNationalFlagView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct DutchNationalFlagVisualizationView: View {
    @StateObject private var viewModel = DutchNationalFlagViewModel()
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
                        Text("Dutch National Flag")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Sort 0s, 1s, and 2s in a single pass")
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
                                Text("Array (0, 1, 2 only - comma-separated)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 2,0,1,2,1,0", text: $viewModel.arrayInput)
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
                            
                            HStack(spacing: 8) {
                                ColorLegend(color: .red, label: "0")
                                ColorLegend(color: .white, label: "1")
                                ColorLegend(color: .blue, label: "2")
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                                    DutchFlagArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index),
                                        pointerLabel: viewModel.pointerLabel(at: index)
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }
                    
                    // Step Information
                    if viewModel.isRunning || viewModel.isCompleted {
                        DutchFlagStepPanel(
                            stepInfo: viewModel.stepInfo,
                            currentAction: viewModel.currentAction,
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
        .navigationTitle("Dutch National Flag")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Dutch National Flag",
                description: "Sort 0s, 1s, and 2s efficiently",
                icon: "flag.fill",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Color Legend
struct ColorLegend: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color == .white ? Color.gray.opacity(0.3) : color)
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
    }
}

// MARK: - Dutch Flag Step Panel
struct DutchFlagStepPanel: View {
    let stepInfo: String
    let currentAction: String
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
                if !stepInfo.isEmpty {
                    InfoRow(label: "Status", value: stepInfo, icon: "target", color: isCompleted ? .green : .blue)
                }
                
                if !currentAction.isEmpty {
                    Divider().padding(.vertical, 4)
                    HStack {
                        Image(systemName: isCompleted ? "checkmark.seal.fill" : "arrow.left.arrow.right.circle.fill")
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
struct DutchFlagArrayElementView: View {
    let value: Int
    let index: Int
    let state: DutchNationalFlagViewModel.ElementState
    let pointerLabel: String?
    
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
            
            if let label = pointerLabel {
                Text(label)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(pointerLabelColor)
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(" ")
                    .font(.system(size: 11, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .opacity(0)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: pointerLabel)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .unchecked: return Color.white.opacity(0.95)
        case .current: return Color.yellow.opacity(0.2)
        case .pointer: return Color.purple.opacity(0.1)
        case .zero: return Color.red.opacity(0.15)
        case .one: return Color.gray.opacity(0.1)
        case .two: return Color.blue.opacity(0.15)
        case .unsorted: return Color.white.opacity(0.95)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .unchecked: return Theme.Colors.primaryText
        case .current: return .orange
        case .pointer: return .purple
        case .zero: return .red
        case .one: return Theme.Colors.primaryText
        case .two: return .blue
        case .unsorted: return Theme.Colors.primaryText
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .unchecked: return Color.gray.opacity(0.25)
        case .current: return .orange
        case .pointer: return .purple.opacity(0.6)
        case .zero: return .red
        case .one: return Color.gray.opacity(0.3)
        case .two: return .blue
        case .unsorted: return Color.gray.opacity(0.25)
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current: return 3
        case .zero, .one, .two: return 3.5
        case .pointer: return 2.5
        default: return 1.5
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current: return Color.orange.opacity(0.4)
        case .pointer: return Color.purple.opacity(0.3)
        case .zero: return Color.red.opacity(0.3)
        case .two: return Color.blue.opacity(0.3)
        default: return Color.black.opacity(0.06)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current: return 15
        case .zero, .two: return 12
        case .pointer: return 10
        default: return 8
        }
    }
    
    private var shadowY: CGFloat {
        switch state {
        case .current: return 6
        case .zero, .two: return 5
        case .pointer: return 4
        default: return 4
        }
    }
    
    private var indexColor: Color {
        switch state {
        case .current: return .orange
        case .pointer: return .purple
        case .zero: return .red
        case .two: return .blue
        default: return Theme.Colors.secondaryText.opacity(0.7)
        }
    }
    
    private var pointerLabelColor: Color {
        if let label = pointerLabel {
            if label.contains("L") && label.contains("M") {
                return .teal
            } else if label.contains("M") && label.contains("H") {
                return .purple
            } else if label.contains("L") {
                return .blue
            } else if label.contains("M") {
                return .orange
            } else if label.contains("H") {
                return .red
            }
        }
        return .clear
    }
}

#Preview {
    NavigationStack {
        DutchNationalFlagVisualizationView()
    }
}