//
//  HeapSortView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI

struct HeapSortVisualizationView: View {
    @StateObject private var viewModel = HeapSortViewModel()
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
                        Text("Heap Sort")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Build max heap, then extract elements one by one")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if !viewModel.isAnimating {
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
                                
                                TextField("e.g., 12,11,13,5,6,7", text: $viewModel.arrayInput)
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
                            
                            if viewModel.isAnimating || viewModel.isCompleted {
                                HStack(spacing: Theme.Spacing.small) {
                                    Text("Step: \(viewModel.currentPass)")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.purple)
                                        .padding(.horizontal, Theme.Spacing.medium)
                                        .padding(.vertical, Theme.Spacing.small)
                                        .background(Color.purple.opacity(0.1))
                                        .cornerRadius(Theme.CornerRadius.small)
                                    
                                    if !viewModel.currentPhase.isEmpty {
                                        Text(viewModel.currentPhase)
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, Theme.Spacing.medium)
                                            .padding(.vertical, Theme.Spacing.small)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(Theme.CornerRadius.small)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .bottom, spacing: Theme.Spacing.medium) {
                                ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                                    HeapSortArrayElementView(
                                        value: value,
                                        index: index,
                                        state: viewModel.elementState(at: index)
                                    )
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.vertical, Theme.Spacing.small)
                            .frame(height: 350)
                        }
                    }
                    
                    // Step Information Panel
                    if viewModel.isAnimating || viewModel.isCompleted {
                        HeapSortStepInformationPanel(
                            currentPass: viewModel.currentPass,
                            currentStep: viewModel.currentStep,
                            currentPhase: viewModel.currentPhase,
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
        .navigationTitle("Heap Sort")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Heap Sort",
                description: "Binary heap-based sorting algorithm",
                icon: "arrow.up.arrow.down.circle.fill",
                complexity: Algorithm.Complexity(time: "O(n log n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[1]
            ))
        }
    }
}

// MARK: - Heap Sort Step Information Panel
struct HeapSortStepInformationPanel: View {
    let currentPass: Int
    let currentStep: Int
    let currentPhase: String
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
                    InfoRow(label: "Current Step", value: "\(currentPass)", icon: "arrow.triangle.2.circlepath", color: .purple)
                    InfoRow(label: "Operations", value: "\(currentStep)", icon: "number.circle.fill", color: .blue)
                    
                    if !currentPhase.isEmpty {
                        InfoRow(label: "Phase", value: currentPhase, icon: "list.bullet.circle.fill", color: .indigo)
                    }
                    
                    if !comparisonResult.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: comparisonResult.contains("⚡") ? "bolt.circle.fill" : 
                                           comparisonResult.contains("🏗️") ? "hammer.circle.fill" :
                                           comparisonResult.contains("🔍") ? "magnifyingglass.circle.fill" :
                                           comparisonResult.contains("🔄") ? "arrow.triangle.2.circlepath.circle.fill" : "checkmark.circle.fill")
                                .foregroundColor(comparisonResult.contains("⚡") ? .orange : 
                                               comparisonResult.contains("🏗️") ? .indigo :
                                               comparisonResult.contains("🔍") ? .purple :
                                               comparisonResult.contains("🔄") ? .blue : .green)
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

// MARK: - Heap Sort Array Element View
struct HeapSortArrayElementView: View {
    let value: Int
    let index: Int
    let state: HeapSortViewModel.ElementState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            // Value Label on top
            Text("\(value)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(textColor)
            
            // Vertical Bar
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .frame(width: 50, height: CGFloat(value) * 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
                .scaleEffect(state == .root || state == .comparing ? 1.05 : 1.0)
            
            // Index Label at bottom
            Text("[\(index)]")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            // State Indicator
            if !stateLabel.isEmpty {
                Text(stateLabel)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(stateLabelColor)
                    .cornerRadius(6)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .unchecked:
            return Color.white.opacity(0.95)
        case .active:
            return Color.blue.opacity(0.1)
        case .root:
            return Color.red.opacity(0.15)
        case .heapifying:
            return Color.purple.opacity(0.15)
        case .comparing:
            return Color.orange.opacity(0.15)
        case .sorted:
            return Color.green.opacity(0.15)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .unchecked:
            return Theme.Colors.primaryText
        case .active:
            return .blue
        case .root:
            return .red
        case .heapifying:
            return .purple
        case .comparing:
            return .orange
        case .sorted:
            return .green
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .unchecked:
            return Color.gray.opacity(0.25)
        case .active:
            return .blue.opacity(0.5)
        case .root:
            return .red
        case .heapifying:
            return .purple
        case .comparing:
            return .orange
        case .sorted:
            return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .root:
            return 3.5
        case .heapifying:
            return 2.5
        case .comparing:
            return 3
        case .sorted:
            return 3.5
        case .active:
            return 2
        default:
            return 1.5
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .root:
            return Color.red.opacity(0.4)
        case .heapifying:
            return Color.purple.opacity(0.3)
        case .comparing:
            return Color.orange.opacity(0.4)
        case .sorted:
            return Color.green.opacity(0.4)
        case .active:
            return Color.blue.opacity(0.3)
        default:
            return Color.black.opacity(0.06)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .root:
            return 18
        case .heapifying:
            return 12
        case .comparing:
            return 15
        case .sorted:
            return 18
        case .active:
            return 12
        default:
            return 8
        }
    }
    
    private var indexColor: Color {
        switch state {
        case .root:
            return .red
        case .heapifying:
            return .purple
        case .comparing:
            return .orange
        case .sorted:
            return .green
        case .active:
            return .blue
        default:
            return Theme.Colors.secondaryText.opacity(0.7)
        }
    }
    
    private var stateLabel: String {
        switch state {
        case .root:
            return "Root"
        case .heapifying:
            return "Heapify"
        case .comparing:
            return "Comparing"
        case .sorted:
            return "Sorted"
        default:
            return ""
        }
    }
    
    private var stateLabelColor: Color {
        switch state {
        case .root:
            return .red
        case .heapifying:
            return .purple
        case .comparing:
            return .orange
        case .sorted:
            return .green
        default:
            return .clear
        }
    }
}

#Preview {
    NavigationStack {
        HeapSortVisualizationView()
    }
}
