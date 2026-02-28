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
    
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Left accent bar
            RoundedRectangle(cornerRadius: 3)
                .fill(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 4)
                .padding(.vertical, 16)
                .shadow(color: accentColor.opacity(0.3), radius: 3, x: 0, y: 0)
            
            HStack(spacing: 14) {
                // Icon container
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.08))
                        .frame(width: 52, height: 52)
                    
                    Circle()
                        .stroke(accentColor.opacity(0.15), lineWidth: 1.2)
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: algorithm.icon)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(accentColor)
                        .symbolRenderingMode(.hierarchical)
                }
                .padding(.leading, 12)
                
                // Text Content
                VStack(alignment: .leading, spacing: 5) {
                    Text(algorithm.name)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(algorithm.description)
                        .font(.system(size: 12.5, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Complexity Badges
                    if let complexity = algorithm.complexity {
                        HStack(spacing: 8) {
                            AlgorithmComplexityBadge(
                                label: "Time",
                                value: complexity.time,
                                accentColor: accentColor
                            )
                            AlgorithmComplexityBadge(
                                label: "Space",
                                value: complexity.space,
                                accentColor: accentColor
                            )
                        }
                        .padding(.top, 3)
                    }
                }
                
                Spacer(minLength: 8)
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(accentColor.opacity(0.35))
                    .padding(.trailing, 16)
            }
        }
        .padding(.vertical, 12)
        .background(
            ZStack {
                // Base card fill
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(Color(.systemBackground))
                
                // Subtle accent gradient overlay
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(
                        LinearGradient(
                            colors: [
                                accentColor.opacity(0.03),
                                accentColor.opacity(0.01),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.18),
                            accentColor.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
        )
        .shadow(color: accentColor.opacity(0.06), radius: 10, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
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
                .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.8))
                .fixedSize()
            
            Text(value)
                .font(.system(size: 10.5, weight: .heavy, design: .monospaced))
                .foregroundColor(accentColor)
                .fixedSize()
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4.5)
        .background(
            Capsule()
                .fill(accentColor.opacity(0.06))
        )
        .overlay(
            Capsule()
                .stroke(accentColor.opacity(0.12), lineWidth: 0.6)
        )
    }
}

// MARK: - Reusable Algorithm Card Button Style
struct AlgorithmCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: configuration.isPressed)
    }
}
