//
//  AlgorithmVisualizationView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct AlgorithmVisualizationView: View {
    let algorithm: Algorithm
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            // Route to specific algorithm visualization if available
            if algorithm.name == "Linear Search" {
                LinearSearchVisualizationView()
            } else {
                // Placeholder for other algorithms
                AlgorithmPlaceholderView(algorithm: algorithm)
            }
        }
    }
}

// MARK: - Algorithm Placeholder View
struct AlgorithmPlaceholderView: View {
    let algorithm: Algorithm
    
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
                VStack(spacing: Theme.Spacing.extraLarge) {
                    // Algorithm Header
                    VStack(spacing: Theme.Spacing.medium) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: algorithm.icon)
                                .font(.system(size: 48))
                                .foregroundColor(.blue)
                        }
                        .padding(.top, Theme.Spacing.large)
                        
                        Text(algorithm.name)
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text(algorithm.description)
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                        
                        // Complexity Info
                        if let complexity = algorithm.complexity {
                            HStack(spacing: Theme.Spacing.medium) {
                                ComplexityInfoCard(label: "Time Complexity", value: complexity.time)
                                ComplexityInfoCard(label: "Space Complexity", value: complexity.space)
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                        }
                    }
                    
                    // Coming Soon Section
                    VStack(spacing: Theme.Spacing.medium) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.Colors.secondaryText.opacity(0.5))
                        
                        Text("Visualization Coming Soon")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Interactive step-by-step visualization will be available here.")
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.extraLarge)
                    }
                    .padding(.vertical, Theme.Spacing.extraLarge)
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(algorithm.name)
    }
}

// MARK: - Complexity Info Card
struct ComplexityInfoCard: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.medium)
        .background(Color.white.opacity(0.8))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        AlgorithmVisualizationView(
            algorithm: Algorithm(
                name: "Linear Search",
                description: "Search elements one by one",
                icon: "arrow.forward.circle.fill",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory(
                    name: "Searching Algorithms",
                    description: "Linear, Binary, Jump, and Exponential Search",
                    icon: "magnifyingglass.circle.fill",
                    color: .blue
                )
            )
        )
    }
}
