//
//  AlgorithmDetailView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct AlgorithmDetailView: View {
    @StateObject private var viewModel: AlgorithmDetailViewModel
    @State private var showQuiz = false
    
    init(algorithm: Algorithm) {
        _viewModel = StateObject(wrappedValue: AlgorithmDetailViewModel(algorithm: algorithm))
    }
    
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
            
            VStack(spacing: 0) {
                // Scrollable Content Area
                ScrollView {
                    VStack(spacing: 0) {
                        // Subtitle (moved from header)
                        Text(viewModel.algorithm.description)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.top, Theme.Spacing.small)
                            .padding(.bottom, Theme.Spacing.medium)
                        
                        // Enhanced Tab Picker
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(AlgorithmDetailViewModel.DetailTab.allCases, id: \.self) { tab in
                                    EnhancedTabButton(
                                        tab: tab,
                                        isSelected: viewModel.selectedTab == tab
                                    ) {
                                        viewModel.selectTab(tab)
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                        }
                        .padding(.bottom, Theme.Spacing.medium)
                        
                        // Tab Content
                        Group {
                            switch viewModel.selectedTab {
                            case .explanation:
                                ExplanationTabView(content: viewModel.content, algorithm: viewModel.algorithm)
                            case .pseudocode:
                                PseudocodeTabView(content: viewModel.content)
                            case .example:
                                ExampleTabView(content: viewModel.content)
                            case .howItWorks:
                                HowItWorksTabView(content: viewModel.content)
                            }
                        }
                        .animation(.easeInOut(duration: 0.25), value: viewModel.selectedTab)
                    }
                }
                
                // Compact Bottom Action Bar (Side-by-Side Buttons)
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(spacing: Theme.Spacing.medium) {
                        // Primary Action: Visualize
                        Button(action: {
                            viewModel.startVisualization()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Visualize")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.4, blue: 0.9),
                                        Color(red: 0.5, green: 0.3, blue: 0.9)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 3)
                        }
                        
                        // Secondary Action: Quiz
                        Button(action: {
                            showQuiz = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("Quiz")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.25), lineWidth: 1.5)
                            )
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.small + 2)
                    .padding(.bottom, Theme.Spacing.small + 4)
                }
                .background(
                    Color.white.opacity(0.5)
                        .background(.ultraThinMaterial)
                )
            }
        }
        .navigationTitle(viewModel.algorithm.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $viewModel.showVisualization) {
            // Navigate to visualization screen
            if viewModel.algorithm.name == "Linear Search" {
                LinearSearchVisualizationView()
            } else {
                AlgorithmPlaceholderView(algorithm: viewModel.algorithm)
            }
        }
        .navigationDestination(isPresented: $showQuiz) {
            // Navigate to quiz screen
            QuizView(algorithm: viewModel.algorithm)
        }
    }
}

// MARK: - Enhanced Tab Button
struct EnhancedTabButton: View {
    let tab: AlgorithmDetailViewModel.DetailTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .semibold))
                
                Text(tab.rawValue)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : Theme.Colors.secondaryText)
            .padding(.horizontal, Theme.Spacing.medium + 2)
            .padding(.vertical, Theme.Spacing.small + 2)
            .background(
                ZStack {
                    if isSelected {
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        Color.white.opacity(0.6)
                    }
                }
            )
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
        }
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Enhanced Explanation Tab (with complexity section)
struct ExplanationTabView: View {
    let content: AlgorithmContent
    let algorithm: Algorithm
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large + 4) {
            // What is it Section
            EnhancedContentSection(title: "What is it?", icon: "info.circle.fill", iconColor: .blue) {
                Text(content.explanation)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineSpacing(6)
            }
            
            // Time & Space Complexity Section
            if let complexity = algorithm.complexity {
                VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                    HStack(spacing: Theme.Spacing.small) {
                        Image(systemName: "speedometer")
                            .foregroundColor(.purple)
                            .font(.system(size: 18, weight: .semibold))
                        Text("Time & Space Complexity")
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.Spacing.small + 2) {
                        ComplexityRow(
                            label: "Time Complexity",
                            value: complexity.time,
                            explanation: getTimeComplexityExplanation(for: complexity.time),
                            color: .blue
                        )
                        
                        Divider()
                            .padding(.vertical, 2)
                        
                        ComplexityRow(
                            label: "Space Complexity",
                            value: complexity.space,
                            explanation: getSpaceComplexityExplanation(for: complexity.space),
                            color: .purple
                        )
                    }
                    .padding(Theme.Spacing.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.06), Color.blue.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(Theme.CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(Color.purple.opacity(0.15), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                }
            }
            
            // When to use Section
            EnhancedContentSection(title: "When to use", icon: "checkmark.circle.fill", iconColor: .green) {
                VStack(alignment: .leading, spacing: Theme.Spacing.small + 2) {
                    ForEach(content.whenToUse, id: \.self) { point in
                        HStack(alignment: .top, spacing: Theme.Spacing.small + 2) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 6, height: 6)
                                .padding(.top, 7)
                            Text(point)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Theme.Colors.primaryText)
                                .lineSpacing(4)
                        }
                    }
                }
            }
            
            // Key Idea Callout Box
            VStack(alignment: .leading, spacing: Theme.Spacing.small + 2) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                    Text("Key Idea")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                }
                
                Text(content.keyIdea)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineSpacing(5)
            }
            .padding(Theme.Spacing.medium + 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(Theme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1.5)
            )
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
    
    // Helper functions for complexity explanations
    private func getTimeComplexityExplanation(for complexity: String) -> String {
        switch complexity {
        case "O(1)": return "Constant time - always same speed"
        case "O(log n)": return "Logarithmic - very fast even for large data"
        case "O(n)": return "Linear - time grows with array size"
        case "O(n log n)": return "Efficient for sorting operations"
        case "O(n²)": return "Quadratic - slow for large datasets"
        case "O(√n)": return "Square root - better than linear"
        case "O(log log n)": return "Very efficient for uniform data"
        default: return "Performance varies based on input"
        }
    }
    
    private func getSpaceComplexityExplanation(for complexity: String) -> String {
        switch complexity {
        case "O(1)": return "Uses fixed amount of memory"
        case "O(log n)": return "Minimal extra memory needed"
        case "O(n)": return "Memory grows with input size"
        default: return "Additional memory required"
        }
    }
}

// MARK: - Complexity Row
struct ComplexityRow: View {
    let label: String
    let value: String
    let explanation: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Text(explanation)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.9))
                .lineSpacing(2)
        }
    }
}

// MARK: - Enhanced Content Section
struct EnhancedContentSection<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            content()
                .padding(Theme.Spacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.85))
                .cornerRadius(Theme.CornerRadius.medium)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
}

// MARK: - Pseudocode Tab (Enhanced with Multi-Language Support)
struct PseudocodeTabView: View {
    let content: AlgorithmContent
    @State private var selectedLanguage: ProgrammingLanguage = .pseudocode
    @State private var showCopiedAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large) {
            // Header
            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundColor(.purple)
                    .font(.system(size: 20, weight: .semibold))
                Text("Code Implementation")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            // Language Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ProgrammingLanguage.allCases, id: \.self) { language in
                        LanguagePillButton(
                            language: language,
                            isSelected: selectedLanguage == language
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedLanguage = language
                            }
                        }
                    }
                }
            }
            
            // Code Display Container
            VStack(alignment: .leading, spacing: 0) {
                // Language Header Bar
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                    }
                    
                    Spacer()
                    
                    Text(selectedLanguage.rawValue)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText)
                    
                    Spacer()
                    
                    // Copy Button
                    Button(action: {
                        UIPasteboard.general.string = content.code(for: selectedLanguage)
                        showCopiedAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showCopiedAlert = false
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: showCopiedAlert ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 12, weight: .semibold))
                            Text(showCopiedAlert ? "Copied" : "Copy")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(showCopiedAlert ? .green : .blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(showCopiedAlert ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
                .padding(.horizontal, Theme.Spacing.medium)
                .padding(.vertical, Theme.Spacing.small + 2)
                .background(Color.gray.opacity(0.1))
                
                // Code Content with Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: true) {
                    Text(content.code(for: selectedLanguage))
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(Theme.Colors.primaryText)
                        .lineSpacing(4)
                        .padding(Theme.Spacing.medium + 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.white.opacity(0.95))
            .cornerRadius(Theme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .stroke(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.4), Color.blue.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.purple.opacity(0.1), radius: 10, x: 0, y: 5)
            
            // Info Note
            HStack(alignment: .top, spacing: Theme.Spacing.small + 2) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Implementation Note")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.Colors.primaryText)
                    Text("This code represents the same algorithm logic in different programming languages. Use it as a reference for your projects.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .lineSpacing(2)
                }
            }
            .padding(Theme.Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.06))
            .cornerRadius(Theme.CornerRadius.medium)
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
}

// MARK: - Language Pill Button
struct LanguagePillButton: View {
    let language: ProgrammingLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(language.rawValue)
                .font(.system(size: 13, weight: isSelected ? .bold : .semibold, design: .rounded))
                .foregroundColor(isSelected ? .white : Theme.Colors.primaryText)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.white.opacity(0.7)
                        }
                    }
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: isSelected ? Color.purple.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 6 : 3, x: 0, y: isSelected ? 3 : 2)
        }
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Example Tab (Enhanced)
struct ExampleTabView: View {
    let content: AlgorithmContent
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.extraLarge) {
            EnhancedContentSection(title: "Sample Input", icon: "arrow.down.circle.fill", iconColor: .blue) {
                VStack(spacing: Theme.Spacing.small + 2) {
                    InfoRow(label: "Array", value: content.example.inputArray.map(String.init).joined(separator: ", "), icon: "square.grid.3x3.fill", color: .blue)
                    Divider()
                    InfoRow(label: "Target", value: "\(content.example.target)", icon: "target", color: .purple)
                }
            }
            
            EnhancedContentSection(title: "Expected Output", icon: "arrow.up.circle.fill", iconColor: .green) {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                    Text(content.example.expectedOutput)
                        .font(.system(size: 17, weight: .semibold, design: .monospaced))
                        .foregroundColor(.green)
                }
            }
            
            EnhancedContentSection(title: "Explanation", icon: "text.bubble.fill", iconColor: .orange) {
                Text(content.example.explanation)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineSpacing(5)
            }
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
}

// MARK: - How It Works Tab (Enhanced with Visual Timeline)
struct HowItWorksTabView: View {
    let content: AlgorithmContent
    @State private var appearedSteps: Set<Int> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium + 2) {
            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: "list.number")
                    .foregroundColor(.orange)
                    .font(.system(size: 20, weight: .semibold))
                Text("Step-by-Step Process")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            .padding(.bottom, Theme.Spacing.small)
            
            // Timeline Steps
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(content.steps.enumerated()), id: \.offset) { index, step in
                    TimelineStepCard(
                        number: index + 1,
                        step: step,
                        isFirst: index == 0,
                        isLast: index == content.steps.count - 1
                    )
                    .opacity(appearedSteps.contains(index) ? 1 : 0)
                    .offset(y: appearedSteps.contains(index) ? 0 : 20)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.1)) {
                            _ = appearedSteps.insert(index)
                        }
                    }
                }
            }
            
            // Learning Tip Card
            VStack(alignment: .leading, spacing: Theme.Spacing.small + 2) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18))
                    Text("Pro Tip")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                }
                
                Text(getLearningTip(for: content.algorithm.name))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineSpacing(4)
            }
            .padding(Theme.Spacing.medium + 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color.yellow.opacity(0.08), Color.orange.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Color.yellow.opacity(0.3), lineWidth: 1.5)
            )
            .shadow(color: Color.orange.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
    
    // Helper function to get learning tips
    private func getLearningTip(for algorithmName: String) -> String {
        switch algorithmName {
        case "Linear Search":
            return "Linear Search checks every element, so performance depends on array size. Best for small or unsorted datasets where simplicity matters."
        case "Binary Search":
            return "Binary Search requires a sorted array but is incredibly fast (O(log n)). It's like finding a name in a phone book by opening it in the middle!"
        case "Jump Search":
            return "Jump Search is a sweet spot between Linear and Binary Search. It works well when you want better performance than linear but can't use binary search."
        case "Interpolation Search":
            return "Interpolation Search shines with uniformly distributed data. It's like guessing where 'Smith' would be in a phone book—closer to the end than the beginning."
        case "Exponential Search":
            return "Exponential Search is perfect when you expect the target to be near the beginning of a large array. It doubles the search range until it finds the right spot."
        case "Fibonacci Search":
            return "Fibonacci Search uses Fibonacci numbers to divide the array. It's especially useful when division operations are expensive on your hardware."
        default:
            return "Understanding how each step flows helps you debug and optimize your code. Practice tracing through with different inputs!"
        }
    }
}

// MARK: - Timeline Step Card with Visual Connectors
struct TimelineStepCard: View {
    let number: Int
    let step: AlgorithmContent.AlgorithmStep
    let isFirst: Bool
    let isLast: Bool
    
    var stepColor: Color {
        switch step.type {
        case .start: return .green
        case .process: return .blue
        case .decision: return .purple
        case .success: return .orange
        case .end: return .red
        }
    }
    
    var stepIcon: String {
        switch step.type {
        case .start: return "play.circle.fill"
        case .process: return "arrow.right.circle.fill"
        case .decision: return "questionmark.diamond.fill"
        case .success: return "checkmark.seal.fill"
        case .end: return "flag.checkered"
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Timeline Connector Column
            VStack(spacing: 0) {
                // Top Line
                if !isFirst {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 16)
                }
                
                // Step Badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [stepColor.opacity(0.2), stepColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Circle()
                        .stroke(stepColor.opacity(0.4), lineWidth: 2)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: stepIcon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(stepColor)
                }
                
                // Bottom Line
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2)
                        .frame(minHeight: 20)
                }
            }
            .frame(width: 44)
            .padding(.trailing, Theme.Spacing.medium)
            
            // Content Card
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center) {
                    Text(step.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Spacer()
                    
                    // Step Number Badge
                    Text("\(number)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(stepColor)
                        .frame(width: 24, height: 24)
                        .background(stepColor.opacity(0.15))
                        .clipShape(Circle())
                }
                
                Text(step.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineSpacing(3)
            }
            .padding(Theme.Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.85))
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(stepColor.opacity(0.15), lineWidth: 1.5)
            )
        }
        .padding(.bottom, isLast ? 0 : Theme.Spacing.small)
    }
}

#Preview {
    NavigationStack {
        AlgorithmDetailView(
            algorithm: Algorithm(
                name: "Linear Search",
                description: "Search elements one by one",
                icon: "arrow.forward.circle.fill",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[0]
            )
        )
    }
}
