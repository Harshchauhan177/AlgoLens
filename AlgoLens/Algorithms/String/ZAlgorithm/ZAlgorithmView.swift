//
//  ZAlgorithmView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct ZAlgorithmVisualizationView: View {
    @StateObject private var viewModel = ZAlgorithmViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    headerSection
                    
                    if !viewModel.isSearching {
                        inputSection
                    }
                    
                    visualizationSection
                    
                    if viewModel.isSearching || viewModel.isCompleted {
                        stepInformationPanel
                    }
                    
                    controlButtons
                }
            }
            .onTapGesture {
                isInputFocused = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Z Algorithm")
        .navigationDestination(isPresented: $showQuiz) {
            quizDestination
        }
    }
    
    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Theme.Colors.backgroundGradientStart,
                Theme.Colors.backgroundGradientEnd
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("Z Algorithm")
                .font(Theme.Fonts.title)
                .foregroundColor(Theme.Colors.primaryText)
            
            Text("Linear time pattern matching using Z-array")
                .font(Theme.Fonts.subtitle)
                .foregroundColor(Theme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.large)
        }
        .padding(.top, Theme.Spacing.large)
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Text("Input Data")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            textInputField
            patternInputField
            
            if let error = viewModel.inputError {
                errorMessage(error)
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .transition(.opacity.combined(with: .scale))
    }
    
    private var textInputField: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text("Text")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            TextField("e.g., AABAACAADAABAAABAA", text: $viewModel.textInput)
                .font(.system(size: 15, design: .monospaced))
                .padding(Theme.Spacing.medium)
                .background(Color.white.opacity(0.9))
                .cornerRadius(Theme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                .focused($isInputFocused)
                .onChange(of: viewModel.textInput) { _ in
                    viewModel.updateFromInputs()
                }
        }
    }
    
    private var patternInputField: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text("Pattern")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            TextField("e.g., AABA", text: $viewModel.patternInput)
                .font(.system(size: 15, design: .monospaced))
                .padding(Theme.Spacing.medium)
                .background(Color.white.opacity(0.9))
                .cornerRadius(Theme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                .focused($isInputFocused)
                .onChange(of: viewModel.patternInput) { _ in
                    viewModel.updateFromInputs()
                }
        }
    }
    
    private func errorMessage(_ error: String) -> some View {
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
    
    // MARK: - Visualization Section
    private var visualizationSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            visualizationHeader
            
            ZAlgorithmVisualization(
                text: viewModel.text,
                pattern: viewModel.pattern,
                combinedString: viewModel.combinedString,
                matchedIndices: viewModel.matchedIndices,
                currentZIndex: viewModel.currentZIndex,
                zArray: viewModel.zArray,
                isSearching: viewModel.isSearching
            )
            .padding(.horizontal, Theme.Spacing.large)
        }
    }
    
    private var visualizationHeader: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack {
                Image(systemName: "function")
                    .foregroundColor(.purple)
                    .font(.system(size: 18, weight: .semibold))
                Text("Z-Array Pattern Matching")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Spacer()
                
                if viewModel.isSearching && !viewModel.isCompleted {
                    currentZIndexBadge
                }
            }
            
            if !viewModel.isSearching {
                explanationBox
            }
            
            if viewModel.isSearching && !viewModel.isCompleted {
                progressIndicator
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
    }
    
    private var currentZIndexBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "number")
                .font(.system(size: 12, weight: .bold))
            Text("Z[\(viewModel.currentZIndex)]")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            LinearGradient(
                colors: [Color.purple, Color.purple.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private var explanationBox: some View {
        ZAlgorithmExplanationView()
            .transition(.opacity.combined(with: .scale))
    }
    
    private var progressIndicator: some View {
        let progress = Double(viewModel.currentZIndex) / Double(max(1, viewModel.combinedString.count))
        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Computing Z-Array")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.purple)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color.purple, Color.pink],
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
    
    // MARK: - Step Information Panel
    private var stepInformationPanel: some View {
        ZAlgorithmStepPanel(
            currentZIndex: viewModel.currentZIndex,
            zArray: viewModel.zArray,
            comparisonResult: viewModel.comparisonResult,
            finalResult: viewModel.finalResult,
            foundCount: viewModel.foundPositions.count,
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
            
            if viewModel.isCompleted {
                quizButton
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.large)
    }
    
    private var quizButton: some View {
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
    
    private var quizDestination: some View {
        QuizView(algorithm: Algorithm(
            name: "Z Algorithm",
            description: "Linear time pattern matching",
            icon: "function",
            complexity: Algorithm.Complexity(time: "O(n+m)", space: "O(n+m)"),
            category: AlgorithmCategory.allCategories[3]
        ))
    }
}

// MARK: - Z Algorithm Explanation View
struct ZAlgorithmExplanationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 14))
                Text("How Z Algorithm Works")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                explanationStep(number: "1.", color: .blue, text: "Combines pattern and text with '$' separator")
                explanationStep(number: "2.", color: .purple, text: "Computes Z-array: Z[i] = length of longest prefix match at position i")
                explanationStep(number: "3.", color: .green, text: "Positions where Z[i] equals pattern length indicate matches")
            }
            
            exampleVisualization
        }
        .padding(12)
        .background(Color.orange.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func explanationStep(number: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(number)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(Theme.Colors.secondaryText)
        }
    }
    
    private var exampleVisualization: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Example: Pattern='ABA', Text='ABACABA'")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.blue.opacity(0.8))
            
            HStack(spacing: 4) {
                ForEach(Array("ABA$ABACABA".enumerated()), id: \.offset) { index, char in
                    Text(String(char))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(char == "$" ? .orange : .primary)
                        .frame(width: 20, height: 24)
                        .background(char == "$" ? Color.orange.opacity(0.15) : Color.blue.opacity(0.08))
                        .cornerRadius(4)
                }
            }
            
            Text("→ Combined string for efficient linear-time matching")
                .font(.system(size: 11))
                .italic()
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.8))
        }
        .padding(.top, 4)
    }
}

// MARK: - Z Algorithm Step Panel
struct ZAlgorithmStepPanel: View {
    let currentZIndex: Int
    let zArray: [Int]
    let comparisonResult: String
    let finalResult: String
    let foundCount: Int
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.purple)
                Text("Step Information")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            VStack(spacing: Theme.Spacing.small) {
                // Current State
                if !isCompleted && currentZIndex > 0 {
                    InfoRow(label: "Current Index", value: "\(currentZIndex)", icon: "arrow.right.circle.fill", color: .purple)
                    if currentZIndex > 0 && currentZIndex <= zArray.count {
                        InfoRow(label: "Z-Value", value: "\(zArray[currentZIndex - 1])", icon: "number.circle.fill", color: .blue)
                    }
                    InfoRow(label: "Matches Found", value: "\(foundCount)", icon: "checkmark.seal.fill", color: .green)
                    
                    if !comparisonResult.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: comparisonResult.contains("✓") || comparisonResult.contains("🎯") ? "checkmark.circle.fill" : "info.circle.fill")
                                .foregroundColor(comparisonResult.contains("🎯") ? .green : .blue)
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
                            .foregroundColor(finalResult.contains("Success") ? .green : .orange)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(finalResult.contains("Success") ? .green : .orange)
                        
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

// MARK: - Z Algorithm Visualization
struct ZAlgorithmVisualization: View {
    let text: String
    let pattern: String
    let combinedString: String
    let matchedIndices: [Int]
    let currentZIndex: Int
    let zArray: [Int]
    let isSearching: Bool
    
    // Calculate current text position being compared
    private var currentTextPosition: Int? {
        let patternLength = pattern.count
        let separatorPosition = patternLength
        
        if currentZIndex > separatorPosition {
            let textIndex = currentZIndex - separatorPosition - 1
            if textIndex >= 0 && textIndex < text.count {
                return textIndex
            }
        }
        return nil
    }
    
    // Check if text index is currently being compared
    private func isCurrentlyComparing(textIndex: Int) -> Bool {
        guard let currentPos = currentTextPosition else { return false }
        return textIndex == currentPos
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Text Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Text String")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(text.count)")
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
                            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                                TextCharacterView(
                                    char: char,
                                    index: index,
                                    isMatched: matchedIndices.contains(index),
                                    isCurrent: isCurrentlyComparing(textIndex: index)
                                )
                                .id("text_\(index)")
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                    }
                    .onChange(of: currentZIndex) { newValue in
                        // Calculate the corresponding text index from the combined string index
                        let patternLength = pattern.count
                        let separatorPosition = patternLength
                        
                        if newValue > separatorPosition {
                            let textIndex = newValue - separatorPosition - 1
                            if textIndex >= 0 && textIndex < text.count {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    proxy.scrollTo("text_\(textIndex)", anchor: .center)
                                }
                            }
                        }
                    }
                    .onChange(of: matchedIndices) { indices in
                        // Scroll to the first matched index when a match is found
                        if let firstMatch = indices.first {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("text_\(firstMatch)", anchor: .center)
                            }
                        }
                    }
                }
            }
            
            // Pattern Display
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.purple.opacity(0.7))
                        .font(.system(size: 14, weight: .semibold))
                    Text("Pattern to Match")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Length: \(pattern.count)")
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
                            ForEach(Array(pattern.enumerated()), id: \.offset) { index, char in
                                VStack(spacing: 6) {
                                    Text("\(index)")
                                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        .foregroundColor(Theme.Colors.secondaryText.opacity(0.6))
                                    
                                    Text(String(char))
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundColor(Theme.Colors.primaryText)
                                        .frame(width: 44, height: 50)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
                                }
                                .id("pattern_\(index)")
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                    }
                    .onChange(of: currentZIndex) { newValue in
                        // Calculate pattern comparison position
                        let patternLength = pattern.count
                        
                        if newValue >= 0 && newValue <= patternLength {
                            let patternIndex = min(newValue, patternLength - 1)
                            withAnimation(.easeInOut(duration: 0.4)) {
                                proxy.scrollTo("pattern_\(patternIndex)", anchor: .center)
                            }
                        }
                    }
                    .onAppear {
                        // Scroll to beginning when view appears
                        if pattern.count > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                proxy.scrollTo("pattern_0", anchor: .leading)
                            }
                        }
                    }
                }
            }
            
            // Combined String Display (if searching)
            if isSearching && !combinedString.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    HStack(spacing: 8) {
                        Image(systemName: "link")
                            .foregroundColor(.orange.opacity(0.7))
                            .font(.system(size: 14, weight: .semibold))
                        Text("Combined String (Pattern$Text)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.Colors.secondaryText)
                        
                        Spacer()
                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(Array(combinedString.enumerated()), id: \.offset) { index, char in
                                    CombinedStringCharacterView(
                                        char: char,
                                        index: index,
                                        currentZIndex: currentZIndex,
                                        zArray: zArray
                                    )
                                    .id("combined_\(index)")
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                        }
                        .onChange(of: currentZIndex) { newValue in
                            if newValue >= 0 && newValue < combinedString.count {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    proxy.scrollTo("combined_\(newValue)", anchor: .center)
                                }
                            }
                        }
                        .onAppear {
                            // Scroll to beginning when view appears
                            if combinedString.count > 0 && currentZIndex >= 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    proxy.scrollTo("combined_\(max(0, currentZIndex))", anchor: .center)
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

// MARK: - Text Character View
struct TextCharacterView: View {
    let char: Character
    let index: Int
    let isMatched: Bool
    let isCurrent: Bool
    
    private var indexColor: Color {
        if isCurrent {
            return .blue
        } else if isMatched {
            return .green
        } else {
            return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
    
    private var textColor: Color {
        if isCurrent {
            return .blue
        } else if isMatched {
            return .green
        } else {
            return Theme.Colors.primaryText
        }
    }
    
    private var backgroundColor: Color {
        if isCurrent {
            return Color.blue.opacity(0.2)
        } else if isMatched {
            return Color.green.opacity(0.25)
        } else {
            return Color.white
        }
    }
    
    private var borderColor: Color {
        if isCurrent {
            return .blue
        } else if isMatched {
            return .green
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        if isCurrent {
            return 3
        } else if isMatched {
            return 2.5
        } else {
            return 2
        }
    }
    
    private var shadowColor: Color {
        if isCurrent {
            return Color.blue.opacity(0.5)
        } else if isMatched {
            return Color.green.opacity(0.5)
        } else {
            return Color.black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        if isCurrent {
            return 14
        } else if isMatched {
            return 12
        } else {
            return 6
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(index)")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            Text(String(char))
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
                .scaleEffect(isCurrent ? 1.08 : 1.0)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isCurrent)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isMatched)
    }
}

// MARK: - Combined String Character View
struct CombinedStringCharacterView: View {
    let char: Character
    let index: Int
    let currentZIndex: Int
    let zArray: [Int]
    
    private var isCurrent: Bool {
        index == currentZIndex
    }
    
    private var isSeparator: Bool {
        char == "$"
    }
    
    private var indexColor: Color {
        isCurrent ? .purple : Theme.Colors.secondaryText.opacity(0.5)
    }
    
    private var textColor: Color {
        if isCurrent {
            return .purple
        } else if isSeparator {
            return .orange
        } else {
            return Theme.Colors.primaryText
        }
    }
    
    private var backgroundColor: Color {
        if isCurrent {
            return Color.purple.opacity(0.2)
        } else if isSeparator {
            return Color.orange.opacity(0.1)
        } else {
            return Color.white.opacity(0.9)
        }
    }
    
    private var borderColor: Color {
        if isCurrent {
            return Color.purple
        } else if isSeparator {
            return Color.orange.opacity(0.5)
        } else {
            return Color.gray.opacity(0.25)
        }
    }
    
    private var borderWidth: CGFloat {
        isCurrent ? 2.5 : 1.5
    }
    
    private var zValue: Int? {
        index < zArray.count ? zArray[index] : nil
    }
    
    private var zValueColor: Color {
        guard let value = zValue else { return .gray.opacity(0.5) }
        return value > 0 ? .blue : .gray.opacity(0.5)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(index)")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundColor(indexColor)
            
            Text(String(char))
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(textColor)
                .frame(width: 36, height: 40)
                .background(backgroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            
            if let value = zValue {
                Text("Z:\(value)")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundColor(zValueColor)
            }
        }
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationStack {
        ZAlgorithmVisualizationView()
    }
}
