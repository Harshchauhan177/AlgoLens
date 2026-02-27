//
//  DynamicProgrammingCategoryView.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import SwiftUI

struct DynamicProgrammingCategoryView: View {
    @StateObject private var viewModel = DynamicProgrammingViewModel()
    
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
                        Text("Dynamic Programming")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Master optimization through memoization and tabulation")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Algorithm List
                    VStack(spacing: Theme.Spacing.medium) {
                        ForEach(viewModel.algorithms) { algorithm in
                            NavigationLink(value: algorithm) {
                                DPAlgorithmCard(algorithm: algorithm)
                            }
                            .buttonStyle(DPAlgorithmCardButtonStyle())
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.large)
                }
            }
            .navigationDestination(for: Algorithm.self) { algorithm in
                destinationView(for: algorithm)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func destinationView(for algorithm: Algorithm) -> some View {
        // Convert DPAlgorithm to Algorithm for AlgorithmDetailView
        let searchAlgorithm = Algorithm(
            name: algorithm.name,
            description: algorithm.description,
            icon: algorithm.icon,
            complexity: algorithm.complexity.map { 
                Algorithm.Complexity(time: $0.time, space: $0.space) 
            },
            category: algorithm.category
        )
        
        AlgorithmDetailView(algorithm: searchAlgorithm)
    }
}

// MARK: - DP Algorithm Card
struct DPAlgorithmCard: View {
    let algorithm: Algorithm
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: algorithm.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.yellow)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small / 2) {
                Text(algorithm.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(algorithm.description)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(2)
                
                // Complexity Badge (if available)
                if let complexity = algorithm.complexity {
                    HStack(spacing: Theme.Spacing.small) {
                        DPComplexityBadge(label: "Time", value: complexity.time)
                        DPComplexityBadge(label: "Space", value: complexity.space)
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

// MARK: - DP Complexity Badge
struct DPComplexityBadge: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label + ":")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            Text(value)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.yellow)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.yellow.opacity(0.08))
        .cornerRadius(6)
    }
}

// MARK: - DP Algorithm Card Button Style
struct DPAlgorithmCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        DynamicProgrammingCategoryView()
    }
}
