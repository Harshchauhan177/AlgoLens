//
//  PrefixSumView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct PrefixSumVisualizationView: View {
    @StateObject private var viewModel = PrefixSumViewModel()
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
                        Text("Prefix Sum")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Precompute cumulative sums for O(1) range queries")
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
                                
                                TextField("e.g., 1,2,3,4,5", text: $viewModel.arrayInput)
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
                    
                    // Original Array Visualization
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack {
                            Text("Original Array")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            Spacer()
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                                    PrefixSumArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index),
                                        isInQueryRange: viewModel.isInQueryRange(at: index),
                                        label: "arr"
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }
                    
                    // Prefix Sum Array Visualization
                    if viewModel.isRunning || viewModel.isCompleted {
                        VStack(spacing: Theme.Spacing.medium) {
                            HStack {
                                Text("Prefix Sum Array")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                Spacer()
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.Spacing.medium) {
                                    ForEach(Array(viewModel.prefixSum.enumerated()), id: \.offset) { index, value in
                                        PrefixSumArrayElementView(
                                            value: value,
                                            index: index,
                                            state: viewModel.prefixElementState(at: index),
                                            isInQueryRange: false,
                                            label: "prefix"
                                        )
                                    }
                                    
                                    // Show placeholder for remaining elements
                                    ForEach(viewModel.prefixSum.count..<viewModel.array.count, id: \.self) { index in
                                        PrefixSumPlaceholderView(index: index)
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.large)
                                .padding(.vertical, Theme.Spacing.small)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Step Information
                    if viewModel.isRunning || viewModel.isCompleted {
                        PrefixSumStepPanel(
                            stepInfo: viewModel.stepInfo,
                            finalResult: viewModel.finalResult,
                            isCompleted: viewModel.isCompleted
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Range Query Section
                    if viewModel.canQuery {
                        VStack(spacing: Theme.Spacing.medium) {
                            HStack {
                                Image(systemName: "function")
                                    .foregroundColor(.purple)
                                Text("Range Query (O(1))")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                Spacer()
                            }
                            
                            HStack(spacing: Theme.Spacing.medium) {
                                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                    Text("Left Index")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Theme.Colors.secondaryText)
                                    
                                    TextField("0", text: $viewModel.queryLeftInput)
                                        .font(.system(size: 15, design: .monospaced))
                                        .padding(Theme.Spacing.medium)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(Theme.CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                        )
                                        .keyboardType(.numberPad)
                                }
                                
                                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                    Text("Right Index")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Theme.Colors.secondaryText)
                                    
                                    TextField("\(viewModel.array.count - 1)", text: $viewModel.queryRightInput)
                                        .font(.system(size: 15, design: .monospaced))
                                        .padding(Theme.Spacing.medium)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(Theme.CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                        )
                                        .keyboardType(.numberPad)
                                }
                            }
                            
                            Button(action: {
                                isInputFocused = false
                                viewModel.executeQuery()
                            }) {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Execute Query")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium)
                                .background(
                                    LinearGradient(
                                        colors: [Color.purple, Color.purple.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(Theme.CornerRadius.large)
                                .shadow(color: Color.purple.opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                            
                            if viewModel.showQueryResult {
                                VStack(spacing: Theme.Spacing.small) {
                                    Text("Range Sum [\(viewModel.queryLeft)..\(viewModel.queryRight)]")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Theme.Colors.secondaryText)
                                    
                                    Text("\(viewModel.queryResult)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.green)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(Theme.Spacing.medium)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                                )
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(Theme.Spacing.medium)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(Theme.CornerRadius.large)
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
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
        .navigationTitle("Prefix Sum")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Prefix Sum",
                description: "Precompute cumulative sums efficiently",
                icon: "plus.forwardslash.minus",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(n)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Prefix Sum Step Panel
struct PrefixSumStepPanel: View {
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
                        Image(systemName: "function")
                            .foregroundColor(.blue)
                        Text(stepInfo)
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
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
struct PrefixSumArrayElementView: View {
    let value: Int
    let index: Int
    let state: PrefixSumViewModel.ElementState
    let isInQueryRange: Bool
    let label: String
    
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
            
            Text(label == "arr" ? "arr[\(index)]" : "prefix[\(index)]")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isInQueryRange)
    }
    
    private var backgroundColor: Color {
        if isInQueryRange {
            return Color.purple.opacity(0.2)
        }
        switch state {
        case .unchecked: return Color.white.opacity(0.95)
        case .current: return Color.blue.opacity(0.15)
        case .completed: return Color.green.opacity(0.1)
        }
    }
    
    private var textColor: Color {
        if isInQueryRange {
            return .purple
        }
        switch state {
        case .unchecked: return Theme.Colors.primaryText
        case .current: return .blue
        case .completed: return .green
        }
    }
    
    private var borderColor: Color {
        if isInQueryRange {
            return .purple
        }
        switch state {
        case .unchecked: return Color.gray.opacity(0.25)
        case .current: return .blue
        case .completed: return .green
        }
    }
    
    private var borderWidth: CGFloat {
        if isInQueryRange {
            return 3
        }
        switch state {
        case .current: return 3
        case .completed: return 2
        default: return 1.5
        }
    }
    
    private var shadowColor: Color {
        if isInQueryRange {
            return Color.purple.opacity(0.4)
        }
        switch state {
        case .current: return Color.blue.opacity(0.4)
        case .completed: return Color.green.opacity(0.3)
        default: return Color.black.opacity(0.06)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current: return 15
        case .completed: return 10
        default: return 8
        }
    }
    
    private var shadowY: CGFloat {
        switch state {
        case .current: return 6
        case .completed: return 4
        default: return 4
        }
    }
    
    private var indexColor: Color {
        if isInQueryRange {
            return .purple
        }
        switch state {
        case .current: return .blue
        case .completed: return .green
        default: return Theme.Colors.secondaryText.opacity(0.7)
        }
    }
}

// MARK: - Placeholder View
struct PrefixSumPlaceholderView: View {
    let index: Int
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("[\(index)]")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.4))
            
            Text("?")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.3))
                .frame(width: 70, height: 70)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(Theme.CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5, 5]))
                        .foregroundColor(Color.gray.opacity(0.3))
                )
            
            Text("prefix[\(index)]")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.4))
        }
    }
}

#Preview {
    NavigationStack {
        PrefixSumVisualizationView()
    }
}
