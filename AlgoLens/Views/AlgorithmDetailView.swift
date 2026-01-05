//
//  AlgorithmDetailView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct AlgorithmDetailView: View {
    @StateObject private var viewModel: AlgorithmDetailViewModel
    
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
                // Header Section
                VStack(spacing: Theme.Spacing.small) {
                    Text(viewModel.algorithm.name)
                        .font(Theme.Fonts.title)
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text(viewModel.algorithm.description)
                        .font(Theme.Fonts.subtitle)
                        .foregroundColor(Theme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.top, Theme.Spacing.medium)
                .padding(.bottom, Theme.Spacing.large)
                
                // Tab Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.medium) {
                        ForEach(AlgorithmDetailViewModel.DetailTab.allCases, id: \.self) { tab in
                            TabButton(
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
                TabView(selection: $viewModel.selectedTab) {
                    ExplanationTabView(content: viewModel.content)
                        .tag(AlgorithmDetailViewModel.DetailTab.explanation)
                    
                    PseudocodeTabView(content: viewModel.content)
                        .tag(AlgorithmDetailViewModel.DetailTab.pseudocode)
                    
                    ExampleTabView(content: viewModel.content)
                        .tag(AlgorithmDetailViewModel.DetailTab.example)
                    
                    HowItWorksTabView(content: viewModel.content)
                        .tag(AlgorithmDetailViewModel.DetailTab.howItWorks)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom Action Button
                VStack(spacing: Theme.Spacing.small) {
                    Divider()
                    
                    Button(action: {
                        viewModel.startVisualization()
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Visualize Algorithm")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.medium + 2)
                        .background(
                            LinearGradient(
                                colors: [
                                    Theme.Colors.primaryGradientStart,
                                    Theme.Colors.primaryGradientEnd
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(Theme.CornerRadius.large)
                        .shadow(color: Theme.Colors.primaryGradientStart.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.vertical, Theme.Spacing.medium)
                }
                .background(Color.white.opacity(0.5))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.showVisualization) {
            // Navigate to existing visualization screen
            if viewModel.algorithm.name == "Linear Search" {
                LinearSearchVisualizationView()
            } else {
                AlgorithmPlaceholderView(algorithm: viewModel.algorithm)
            }
        }
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let tab: AlgorithmDetailViewModel.DetailTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(tab.rawValue)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium, design: .rounded))
            }
            .foregroundColor(isSelected ? .blue : Theme.Colors.secondaryText)
            .padding(.horizontal, Theme.Spacing.medium)
            .padding(.vertical, Theme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.white.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Explanation Tab
struct ExplanationTabView: View {
    let content: AlgorithmContent
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                ContentSection(title: "What is it?", icon: "info.circle.fill") {
                    Text(content.explanation)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Theme.Colors.primaryText)
                        .lineSpacing(4)
                }
                
                ContentSection(title: "When to use", icon: "checkmark.circle.fill") {
                    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                        ForEach(content.whenToUse, id: \.self) { point in
                            HStack(alignment: .top, spacing: Theme.Spacing.small) {
                                Text("•")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.blue)
                                Text(point)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Theme.Colors.primaryText)
                            }
                        }
                    }
                }
                
                ContentSection(title: "Key Idea", icon: "lightbulb.fill") {
                    Text(content.keyIdea)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.Colors.primaryText)
                        .padding(Theme.Spacing.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(Theme.CornerRadius.medium)
                }
            }
            .padding(Theme.Spacing.large)
        }
    }
}

// MARK: - Pseudocode Tab
struct PseudocodeTabView: View {
    let content: AlgorithmContent
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                HStack {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .foregroundColor(.purple)
                    Text("Algorithm Pseudocode")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                }
                
                Text(content.pseudocode)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(Theme.Colors.primaryText)
                    .padding(Theme.Spacing.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                    )
                
                HStack(spacing: Theme.Spacing.small) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                    Text("This pseudocode represents the algorithm logic")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
                .padding(Theme.Spacing.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(Theme.CornerRadius.small)
            }
            .padding(Theme.Spacing.large)
        }
    }
}

// MARK: - Example Tab
struct ExampleTabView: View {
    let content: AlgorithmContent
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                ContentSection(title: "Sample Input", icon: "arrow.down.circle.fill") {
                    VStack(spacing: Theme.Spacing.small) {
                        InfoRow(label: "Array", value: content.example.inputArray.map(String.init).joined(separator: ", "), icon: "square.grid.3x3", color: .blue)
                        InfoRow(label: "Target", value: "\(content.example.target)", icon: "target", color: .purple)
                    }
                }
                
                ContentSection(title: "Expected Output", icon: "arrow.up.circle.fill") {
                    Text(content.example.expectedOutput)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(.green)
                        .padding(Theme.Spacing.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.08))
                        .cornerRadius(Theme.CornerRadius.medium)
                }
                
                ContentSection(title: "Explanation", icon: "text.bubble.fill") {
                    Text(content.example.explanation)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Theme.Colors.primaryText)
                        .lineSpacing(4)
                }
            }
            .padding(Theme.Spacing.large)
        }
    }
}

// MARK: - How It Works Tab
struct HowItWorksTabView: View {
    let content: AlgorithmContent
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                HStack {
                    Image(systemName: "list.number")
                        .foregroundColor(.orange)
                    Text("Step-by-Step Process")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                }
                .padding(.bottom, Theme.Spacing.small)
                
                ForEach(Array(content.steps.enumerated()), id: \.offset) { index, step in
                    StepCard(number: index + 1, description: step)
                }
            }
            .padding(Theme.Spacing.large)
        }
    }
}

// MARK: - Step Card
struct StepCard: View {
    let number: Int
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Text("\(number)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
            }
            
            Text(description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Theme.Colors.primaryText)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.8))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Content Section
struct ContentSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            content()
        }
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
