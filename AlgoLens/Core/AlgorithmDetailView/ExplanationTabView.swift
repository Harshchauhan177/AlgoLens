//
//  ExplanationTabView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

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
