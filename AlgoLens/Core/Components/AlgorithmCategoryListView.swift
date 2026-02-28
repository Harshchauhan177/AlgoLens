//
//  AlgorithmCategoryListView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import SwiftUI

// MARK: - Reusable Category List Layout
struct AlgorithmCategoryListView: View {
    let title: String
    let subtitle: String
    let algorithms: [Algorithm]
    var accentColor: Color = .blue
    
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
                        Text(title)
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text(subtitle)
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Algorithm List
                    VStack(spacing: Theme.Spacing.medium) {
                        ForEach(algorithms) { algorithm in
                            NavigationLink(value: algorithm) {
                                AlgorithmCardView(algorithm: algorithm, accentColor: accentColor)
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
