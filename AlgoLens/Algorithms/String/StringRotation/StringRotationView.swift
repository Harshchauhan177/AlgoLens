//
//  StringRotationView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct StringRotationVisualizationView: View {
    @StateObject private var viewModel = StringRotationViewModel()
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
                        Text("String Rotation")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Check if one string is a rotation of another")
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
                            
                            // String 1 Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Original String")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., WATERBOTTLE", text: $viewModel.string1Input)
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
                            
                            // String 2 Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Potential Rotation")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., ERBOTTLEWAT", text: $viewModel.string2Input)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
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
                                Text("Rotation Check Visualization")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.isChecking && !viewModel.isCompleted {
                                    HStack(spacing: 6) {
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text("Step: \(viewModel.currentStep + 1)")
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
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        StringRotationVisualizationContent(
                            string1: viewModel.string1,
                            string2: viewModel.string2,
                            concatenated: viewModel.concatenated,
                            currentIndex: viewModel.currentIndex,
                            matchedIndices: viewModel.matchedIndices,
                            isMatching: viewModel.isMatching,
                            currentStep: viewModel.currentStep,
                            characterState: viewModel.characterState
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    // Step Information Panel
                    if viewModel.isChecking || viewModel.isCompleted {
                        StringRotationStepPanel(
                            currentStep: viewModel.currentStep,
                            comparisonResult: viewModel.comparisonResult,
                            finalResult: viewModel.finalResult,
                            isRotation: viewModel.isRotation,
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
        .navigationTitle("String Rotation")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "String Rotation",
                description: "Check if one string is a rotation of another",
                icon: "arrow.triangle.2.circlepath",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(n)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
}

// MARK: - Step Information Panel
struct StringRotationStepPanel: View {
    let currentStep: Int
    let comparisonResult: String
    let finalResult: String
    let isRotation: Bool
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
                    InfoRow(label: "Current Step", value: stepName(currentStep), icon: "number.circle.fill", color: .blue)
                    
                    if !comparisonResult.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: comparisonResult.contains("✓") || comparisonResult.contains("🎯") ? "checkmark.circle.fill" : "magnifyingglass.circle.fill")
                                .foregroundColor(comparisonResult.contains("✓") || comparisonResult.contains("🎯") ? .green : .blue)
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
                        Image(systemName: finalResult.contains("Success") ? "checkmark.seal.fill" : "xmark.seal.fill")
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
    
    private func stepName(_ step: Int) -> String {
        switch step {
        case 0: return "Length Check"
        case 1: return "Concatenation"
        case 2: return "Search Setup"
        case 3: return "Pattern Search"
        case 4: return "Complete"
        default: return "Unknown"
        }
    }
}

// MARK: - String Rotation Visualization Content
struct StringRotationVisualizationContent: View {
    let string1: String
    let string2: String
    let concatenated: String
    let currentIndex: Int
    let matchedIndices: [Int]
    let isMatching: Bool
    let currentStep: Int
    let characterState: (Int, Bool) -> StringRotationViewModel.CharacterState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // String 1 Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Original String")
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(string1.enumerated()), id: \.offset) { index, char in
                            StringCharacterBox(
                                char: String(char),
                                index: index,
                                state: .normal
                            )
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                }
            }
            
            // String 2 Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.purple.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Potential Rotation")
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(string2.enumerated()), id: \.offset) { index, char in
                            StringCharacterBox(
                                char: String(char),
                                index: index,
                                state: .normal
                            )
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                }
            }
            
            // Concatenated String Display (only when created)
            if currentStep >= 1 && !concatenated.isEmpty {
                VStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    HStack(spacing: 8) {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(.green.opacity(0.7))
                            .font(.system(size: 14, weight: .semibold))
                        Text("Concatenated String (S1 + S1)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.Colors.secondaryText)
                        
                        Spacer()
                        
                        Text("Length: \(concatenated.count)")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.08))
                            .cornerRadius(6)
                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(Array(concatenated.enumerated()), id: \.offset) { index, char in
                                    StringCharacterBox(
                                        char: String(char),
                                        index: index,
                                        state: characterState(index, true)
                                    )
                                    .id("concat_\(index)")
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 8)
                        }
                        .onChange(of: currentIndex) { newValue in
                            if newValue >= 0 && newValue < concatenated.count {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    proxy.scrollTo("concat_\(newValue)", anchor: .center)
                                }
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

// MARK: - String Character Box
struct StringCharacterBox: View {
    let char: String
    let index: Int
    let state: StringRotationViewModel.CharacterState
    
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
    
    private var backgroundColor: Color {
        switch state {
        case .normal: return Color.white
        case .comparing: return Color.blue.opacity(0.1)
        case .current: return Color.blue.opacity(0.2)
        case .matching: return Color.green.opacity(0.15)
        case .matched: return Color.green.opacity(0.25)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .normal: return Theme.Colors.primaryText
        case .comparing: return .blue.opacity(0.7)
        case .current: return .blue
        case .matching: return .green.opacity(0.8)
        case .matched: return .green
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .normal: return Color.gray.opacity(0.3)
        case .comparing: return Color.blue.opacity(0.4)
        case .current: return .blue
        case .matching: return Color.green.opacity(0.6)
        case .matched: return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current: return 3
        case .matched, .matching: return 2.5
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
    
    private var indexColor: Color {
        switch state {
        case .current: return .blue
        case .matched: return .green
        default: return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
}

#Preview {
    NavigationStack {
        StringRotationVisualizationView()
    }
}
