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
            // Icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: algorithm.icon)
                    .font(.system(size: 22))
                    .foregroundColor(accentColor)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small / 2) {
                Text(algorithm.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(algorithm.description)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(1)
                
                // Complexity Badge (if available)
                if let complexity = algorithm.complexity {
                    HStack(spacing: Theme.Spacing.small) {
                        AlgorithmComplexityBadge(label: "Time", value: complexity.time, accentColor: accentColor)
                        AlgorithmComplexityBadge(label: "Space", value: complexity.space, accentColor: accentColor)
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.5))
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
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
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(accentColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(accentColor.opacity(0.08))
        .cornerRadius(6)
    }
}

// MARK: - Reusable Algorithm Card Button Style
struct AlgorithmCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
