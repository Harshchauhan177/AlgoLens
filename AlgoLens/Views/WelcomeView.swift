//
//  WelcomeView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    
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
            
            VStack(spacing: Theme.Spacing.extraLarge) {
                Spacer()
                
                // App Icon/Logo
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Theme.Colors.primaryGradientStart,
                                Theme.Colors.primaryGradientEnd
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Theme.Colors.primaryGradientStart.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // Title and Subtitle
                VStack(spacing: Theme.Spacing.medium) {
                    Text("AlgoLens")
                        .font(Theme.Fonts.largeTitle)
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text("Visualize Data Structures & Algorithms")
                        .font(Theme.Fonts.subtitle)
                        .foregroundColor(Theme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.large)
                }
                
                // Feature Pills
                HStack(spacing: Theme.Spacing.medium) {
                    ForEach(viewModel.features, id: \.1) { icon, title in
                        FeaturePill(icon: icon, title: title)
                    }
                }
                .padding(.top, Theme.Spacing.medium)
                
                Spacer()
                
                // Primary Action Button
                Button(action: {
                    viewModel.startLearning()
                }) {
                    HStack {
                        Text("Start Learning")
                            .font(Theme.Fonts.button)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.medium)
                    .background(
                        LinearGradient(
                            colors: [
                                Theme.Colors.primaryGradientStart,
                                Theme.Colors.primaryGradientEnd
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(Theme.CornerRadius.large)
                    .shadow(color: Theme.Colors.primaryGradientStart.opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, Theme.Spacing.extraLarge)
                .padding(.bottom, Theme.Spacing.extraLarge)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isNavigatingToHome) {
            HomeView()
        }
    }
}

// MARK: - Supporting Views
struct FeaturePill: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Theme.Colors.accent)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.medium)
        .background(Color.white.opacity(0.7))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    WelcomeView()
}
