//
//  SearchingAlgorithmsView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct SearchingAlgorithmsView: View {
    @StateObject private var viewModel = SearchingAlgorithmsViewModel()
    
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
                        Text("Searching Algorithms")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Understand how data is searched step by step")
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
                                AlgorithmCard(algorithm: algorithm)
                            }
                            .buttonStyle(AlgorithmCardButtonStyle())
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.large)
                }
            }
            .navigationDestination(for: Algorithm.self) { algorithm in
                AlgorithmVisualizationView(algorithm: algorithm)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Algorithm Card
struct AlgorithmCard: View {
    let algorithm: Algorithm
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: algorithm.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
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
                        ComplexityBadge(label: "Time", value: complexity.time)
                        ComplexityBadge(label: "Space", value: complexity.space)
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

// MARK: - Complexity Badge
struct ComplexityBadge: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label + ":")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            Text(value)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.08))
        .cornerRadius(6)
    }
}

// MARK: - Algorithm Card Button Style
struct AlgorithmCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        SearchingAlgorithmsView()
    }
}
