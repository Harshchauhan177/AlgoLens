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
    
    @State private var appearedCards: Set<Int> = []
    
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
                    VStack(spacing: Theme.Spacing.small + 2) {
                        Text(title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text(subtitle)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                        
                        // Decorative accent line
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.6), accentColor.opacity(0.15)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 60, height: 4)
                            .padding(.top, 4)
                    }
                    .padding(.top, Theme.Spacing.medium)
                    
                    // Algorithm Count Badge
                    HStack {
                        Text("\(algorithms.count) algorithms")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(accentColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(accentColor.opacity(0.08))
                            .cornerRadius(Theme.CornerRadius.small + 2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    // Algorithm List
                    VStack(spacing: Theme.Spacing.medium - 2) {
                        ForEach(Array(algorithms.enumerated()), id: \.element.id) { index, algorithm in
                            NavigationLink(value: algorithm) {
                                AlgorithmCardView(algorithm: algorithm, accentColor: accentColor)
                            }
                            .buttonStyle(AlgorithmCardButtonStyle())
                            .opacity(appearedCards.contains(index) ? 1 : 0)
                            .offset(y: appearedCards.contains(index) ? 0 : 24)
                            .onAppear {
                                withAnimation(
                                    .spring(response: 0.5, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.06)
                                ) {
                                    _ = appearedCards.insert(index)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.extraLarge)
                }
            }
            .navigationDestination(for: Algorithm.self) { algorithm in
                AlgorithmVisualizationView(algorithm: algorithm)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
