//
//  AlgorithmCardView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import SwiftUI

// MARK: - Reusable Algorithm Card
struct AlgorithmCardView: View {
    let algorithm: Algorithm
    var accentColor: Color = .blue
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.18), accentColor.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                
                Image(systemName: algorithm.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 5) {
                Text(algorithm.name)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(algorithm.description)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(1)
                
                // Complexity Badges
                if let complexity = algorithm.complexity {
                    HStack(spacing: Theme.Spacing.small) {
                        AlgorithmComplexityBadge(label: "Time", value: complexity.time, accentColor: accentColor)
                        AlgorithmComplexityBadge(label: "Space", value: complexity.space, accentColor: accentColor)
                    }
                    .padding(.top, 3)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.4))
        }
        .padding(Theme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(Color(.systemBackground).opacity(0.92))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(Color(.separator).opacity(0.15), lineWidth: 1)
        )
        .overlay(
            // Left accent bar
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.7), accentColor.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 4)
                    .padding(.vertical, 12)
                Spacer()
            }
            .padding(.leading, 6)
        )
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
        .shadow(color: accentColor.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Reusable Complexity Badge
struct AlgorithmComplexityBadge: View {
    let label: String
    let value: String
    var accentColor: Color = .blue
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label + ":")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            Text(value)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(accentColor)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(accentColor.opacity(0.07))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(accentColor.opacity(0.1), lineWidth: 0.5)
        )
    }
}

// MARK: - Reusable Algorithm Card Button Style
struct AlgorithmCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
