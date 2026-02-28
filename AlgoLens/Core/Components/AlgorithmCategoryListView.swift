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
    @State private var headerAppeared = false
    @State private var accentLineWidth: CGFloat = 0
    
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
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: Header Section
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                            .opacity(headerAppeared ? 1 : 0)
                            .offset(y: headerAppeared ? 0 : -10)
                        
                        Text(subtitle)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                            .opacity(headerAppeared ? 1 : 0)
                            .offset(y: headerAppeared ? 0 : -6)
                        
                        // Animated decorative accent line
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: accentLineWidth, height: 4)
                            .padding(.top, 6)
                    }
                    .padding(.top, Theme.Spacing.medium)
                    .onAppear {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            headerAppeared = true
                        }
                        withAnimation(.easeOut(duration: 0.7).delay(0.25)) {
                            accentLineWidth = 56
                        }
                    }
                    
                    // MARK: Algorithm Count Badge
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "square.stack.3d.up.fill")
                                .font(.system(size: 11, weight: .bold))
                            Text("\(algorithms.count) algorithms")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(accentColor)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(accentColor.opacity(0.08))
                        )
                        .overlay(
                            Capsule()
                                .stroke(accentColor.opacity(0.15), lineWidth: 0.8)
                        )
                        
                        Spacer()
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    // MARK: Algorithm Cards
                    LazyVStack(spacing: 14) {
                        ForEach(Array(algorithms.enumerated()), id: \.element.id) { index, algorithm in
                            NavigationLink(value: algorithm) {
                                AlgorithmCardView(algorithm: algorithm, accentColor: accentColor)
                            }
                            .buttonStyle(AlgorithmCardButtonStyle())
                            .opacity(appearedCards.contains(index) ? 1 : 0)
                            .offset(y: appearedCards.contains(index) ? 0 : 20)
                            .onAppear {
                                withAnimation(
                                    .spring(response: 0.45, dampingFraction: 0.78)
                                    .delay(Double(index) * 0.055)
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
