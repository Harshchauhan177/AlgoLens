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
        VStack(alignment: .leading, spacing: Theme.Spacing.large + 4) {
            // Header with Icon
            HStack(spacing: Theme.Spacing.small + 2) {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundColor(.purple)
                    .font(.system(size: 20, weight: .semibold))
                Text("Code Implementation")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            .padding(.horizontal, 2)
            
            // Language Selector with Modern Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ProgrammingLanguage.allCases, id: \.self) { language in
                        LanguagePillButton(
                            language: language,
                            isSelected: selectedLanguage == language
                        ) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedLanguage = language
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            
            // Premium Code Editor Container
            VStack(alignment: .leading, spacing: 0) {
                // Editor Header Bar (macOS-style window controls)
                HStack(spacing: 0) {
                    // Left: Window Controls (subtle macOS-style dots)
                    HStack(spacing: 7) {
                        Circle()
                            .fill(Color.red.opacity(0.75))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.yellow.opacity(0.75))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.green.opacity(0.75))
                            .frame(width: 10, height: 10)
                    }
                    .padding(.leading, Theme.Spacing.medium + 2)
                    
                    Spacer()
                    
                    // Center: Language Label
                    Text(selectedLanguage.displayName)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(7)
                    
                    Spacer()
                    
                    // Right: Copy Button
                    Button(action: {
                        UIPasteboard.general.string = content.code(for: selectedLanguage)
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showCopiedAlert = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showCopiedAlert = false
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: showCopiedAlert ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 13, weight: .semibold))
                                .contentTransition(.symbolEffect(.replace))
                            Text(showCopiedAlert ? "Copied!" : "Copy")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(showCopiedAlert ? .green : .blue)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 7)
                        .background(
                            (showCopiedAlert ? Color.green.opacity(0.1) : Color.blue.opacity(0.08))
                        )
                        .cornerRadius(8)
                    }
                    .padding(.trailing, Theme.Spacing.medium + 2)
                }
                .frame(height: 44)
                .background(
                    LinearGradient(
                        colors: [
                            Color(white: 0.96),
                            Color(white: 0.94)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Divider()
                    .background(Color.gray.opacity(0.2))
                
                // Code Content Area with Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: true) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(content.code(for: selectedLanguage))
                            .font(.system(size: 15, weight: .regular, design: .monospaced))
                            .foregroundColor(Theme.Colors.primaryText)
                            .lineSpacing(7)
                            .padding(Theme.Spacing.large)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 220)
                .background(Color(white: 0.99))
            }
            .background(Color(white: 0.99))
            .cornerRadius(Theme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.25),
                                Color.blue.opacity(0.25),
                                Color.purple.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.purple.opacity(0.1), radius: 16, x: 0, y: 8)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Implementation Info Card
            HStack(alignment: .top, spacing: Theme.Spacing.medium) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue.opacity(0.8))
                    .font(.system(size: 20))
                    .padding(.top, 1)
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Implementation Guide")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text("This implementation demonstrates the core logic of the algorithm. You can adapt it to your specific use case and language preferences.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(Theme.Spacing.medium + 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.04))
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Color.blue.opacity(0.12), lineWidth: 1)
            )
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
}

// MARK: - Language Pill Button (Enhanced)
struct LanguagePillButton: View {
    let language: ProgrammingLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                // Language Icon
                if let icon = language.icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                }
                
                Text(language.displayName)
                    .font(.system(size: 14, weight: isSelected ? .bold : .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : Theme.Colors.primaryText.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.95),
                                Color.blue.opacity(0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.white.opacity(0.9)
                    }
                }
            )
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isSelected ? Color.clear : Color.gray.opacity(0.2),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: isSelected ? Color.purple.opacity(0.3) : Color.black.opacity(0.06),
                radius: isSelected ? 10 : 4,
                x: 0,
                y: isSelected ? 5 : 2
            )
        }
        .scaleEffect(isSelected ? 1.02 : 0.98)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
    }
}

// MARK: - Example Tab (Enhanced with Premium Visual Design)
struct ExampleTabView: View {
    let content: AlgorithmContent
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large + 6) {
            // Header with Icon
            HStack(spacing: Theme.Spacing.small + 2) {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.orange)
                    .font(.system(size: 20, weight: .semibold))
                Text("Example Walkthrough")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            .padding(.horizontal, 2)
            
            // Sample Input Section (Enhanced)
            VStack(alignment: .leading, spacing: Theme.Spacing.medium + 2) {
                // Section Header
                HStack(spacing: Theme.Spacing.small + 2) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Sample Input")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                }
                
                // Input Cards Container
                VStack(spacing: Theme.Spacing.medium) {
                    // Array Card
                    VStack(alignment: .leading, spacing: Theme.Spacing.small + 4) {
                        HStack {
                            Image(systemName: "square.grid.3x3.fill")
                                .foregroundColor(.blue.opacity(0.8))
                                .font(.system(size: 15, weight: .semibold))
                            Text("Array")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.Colors.secondaryText)
                            Spacer()
                        }
                        
                        // Array Elements Display
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Array(content.example.inputArray.enumerated()), id: \.offset) { index, element in
                                    VStack(spacing: 6) {
                                        Text("\(element)")
                                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                                            .foregroundColor(Theme.Colors.primaryText)
                                            .frame(minWidth: 48, minHeight: 48)
                                            .background(
                                                LinearGradient(
                                                    colors: [
                                                        Color.blue.opacity(0.08),
                                                        Color.blue.opacity(0.12)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue.opacity(0.25), lineWidth: 2)
                                            )
                                        
                                        Text("[\(index)]")
                                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                                            .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 2)
                        }
                    }
                    .padding(Theme.Spacing.medium + 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(color: Color.blue.opacity(0.08), radius: 8, x: 0, y: 3)
                    
                    // Target Card
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "target")
                                    .foregroundColor(.purple)
                                    .font(.system(size: 15, weight: .semibold))
                                Text("Target Value")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.Colors.secondaryText)
                            }
                            
                            Text("\(content.example.target)")
                                .font(.system(size: 28, weight: .heavy, design: .monospaced))
                                .foregroundColor(.purple)
                        }
                        
                        Spacer()
                        
                        // Visual Target Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.12),
                                            Color.purple.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                            
                            Image(systemName: "scope")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(Theme.Spacing.medium + 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(color: Color.purple.opacity(0.08), radius: 8, x: 0, y: 3)
                }
                .padding(Theme.Spacing.medium)
                .background(Color.blue.opacity(0.03))
                .cornerRadius(Theme.CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .stroke(Color.blue.opacity(0.15), lineWidth: 1.5)
                )
            }
            
            // Flow Arrow
            HStack {
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.gray.opacity(0.35))
                    
                    Text("Process")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.gray.opacity(0.5))
                        .textCase(.uppercase)
                        .tracking(0.8)
                }
                Spacer()
            }
            .padding(.vertical, 2)
            
            // Expected Output Section (Enhanced)
            VStack(alignment: .leading, spacing: Theme.Spacing.medium + 2) {
                // Section Header
                HStack(spacing: Theme.Spacing.small + 2) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Expected Output")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                }
                
                // Output Result Card
                HStack(spacing: Theme.Spacing.medium + 2) {
                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.green.opacity(0.12),
                                        Color.green.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Result")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.Colors.secondaryText.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(0.8)
                        
                        Text(content.example.expectedOutput)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                .padding(Theme.Spacing.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.06),
                            Color.green.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(Theme.CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: Color.green.opacity(0.18), radius: 12, x: 0, y: 6)
            }
            
            // Flow Arrow
            HStack {
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.gray.opacity(0.35))
                    
                    Text("Explanation")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.gray.opacity(0.5))
                        .textCase(.uppercase)
                        .tracking(0.8)
                }
                Spacer()
            }
            .padding(.vertical, 2)
            
            // Explanation Section (Enhanced)
            VStack(alignment: .leading, spacing: Theme.Spacing.medium + 2) {
                // Section Header
                HStack(spacing: Theme.Spacing.small + 2) {
                    Image(systemName: "text.bubble.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 18, weight: .semibold))
                    Text("How It Works")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                }
                
                // Explanation Content
                HStack(alignment: .top, spacing: Theme.Spacing.medium) {
                    // Quote Icon
                    Image(systemName: "quote.opening")
                        .foregroundColor(.orange.opacity(0.4))
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 4)
                    
                    Text(content.example.explanation)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Theme.Colors.primaryText)
                        .lineSpacing(7)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(Theme.Spacing.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.95))
                .cornerRadius(Theme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1.5)
                )
                .shadow(color: Color.orange.opacity(0.06), radius: 8, x: 0, y: 3)
            }
            
            // Learning Note
            HStack(alignment: .top, spacing: Theme.Spacing.medium) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 18))
                    .padding(.top, 2)
                
                Text("Try tracing through this example step-by-step to understand how the algorithm processes the data.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineSpacing(4)
            }
            .padding(Theme.Spacing.medium + 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.yellow.opacity(0.05))
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Color.yellow.opacity(0.2), lineWidth: 1.5)
            )
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
