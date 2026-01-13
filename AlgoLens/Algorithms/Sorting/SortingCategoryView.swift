//
//  SortingCategoryView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI

struct SortingAlgorithmsView: View {
    @StateObject private var viewModel = SortingAlgorithmsViewModel()
    
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
                        Text("Sorting Algorithms")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Learn how data is organized step by step")
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

#Preview {
    NavigationStack {
        SortingAlgorithmsView()
    }
}
