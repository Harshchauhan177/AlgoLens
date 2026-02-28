//
//  WelcomeView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var logoAppeared = false
    @State private var textAppeared = false
    @State private var pillsAppeared = false
    @State private var buttonAppeared = false
    @State private var logoRotation = false
    @State private var buttonShimmer: CGFloat = -200
    
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
            
            // Ambient floating blobs
            GeometryReader { geo in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.blue.opacity(0.08), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .offset(x: -60, y: geo.size.height * 0.15)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.purple.opacity(0.06), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .offset(x: geo.size.width * 0.6, y: geo.size.height * 0.65)
            }
            .ignoresSafeArea()
            
            VStack(spacing: Theme.Spacing.extraLarge) {
                Spacer()
                
                // App Icon/Logo with animated ring
                ZStack {
                    // Rotating outer ring
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    Theme.Colors.primaryGradientStart.opacity(0.4),
                                    Theme.Colors.primaryGradientEnd.opacity(0.1),
                                    Theme.Colors.primaryGradientStart.opacity(0.3),
                                    Theme.Colors.primaryGradientEnd.opacity(0.05),
                                    Theme.Colors.primaryGradientStart.opacity(0.4)
                                ],
                                center: .center
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 130, height: 130)
                        .rotationEffect(.degrees(logoRotation ? 360 : 0))
                        .animation(
                            .linear(duration: 12).repeatForever(autoreverses: false),
                            value: logoRotation
                        )
                    
                    // Inner glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Theme.Colors.primaryGradientStart.opacity(0.15),
                                    Theme.Colors.primaryGradientEnd.opacity(0.05)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 55
                            )
                        )
                        .frame(width: 110, height: 110)
                    
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.system(size: 56, weight: .semibold))
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
                }
                .shadow(color: Theme.Colors.primaryGradientStart.opacity(0.25), radius: 24, x: 0, y: 12)
                .scaleEffect(logoAppeared ? 1 : 0.6)
                .opacity(logoAppeared ? 1 : 0)
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                        logoAppeared = true
                    }
                    logoRotation = true
                }
                
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
                .opacity(textAppeared ? 1 : 0)
                .offset(y: textAppeared ? 0 : 15)
                .onAppear {
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.25)) {
                        textAppeared = true
                    }
                }
                
                // Feature Pills — upgraded glassmorphic
                HStack(spacing: Theme.Spacing.medium) {
                    ForEach(Array(viewModel.features.enumerated()), id: \.element.1) { index, feature in
                        FeaturePill(icon: feature.0, title: feature.1)
                            .opacity(pillsAppeared ? 1 : 0)
                            .offset(y: pillsAppeared ? 0 : 20)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(0.4 + Double(index) * 0.1),
                                value: pillsAppeared
                            )
                    }
                }
                .padding(.top, Theme.Spacing.medium)
                .onAppear {
                    pillsAppeared = true
                }
                
                Spacer()
                
                // Primary Action Button with shimmer
                Button(action: {
                    viewModel.startLearning()
                }) {
                    ZStack {
                        HStack {
                            Text("Start Learning")
                                .font(Theme.Fonts.button)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
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
                        
                        // Shimmer sweep on button
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .fill(
                                LinearGradient(
                                    colors: [Color.clear, Color.white.opacity(0.2), Color.clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: buttonShimmer)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 2.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(1.5)
                                ) {
                                    buttonShimmer = 300
                                }
                            }
                    }
                    .shadow(color: Theme.Colors.primaryGradientStart.opacity(0.4), radius: 18, x: 0, y: 10)
                }
                .padding(.horizontal, Theme.Spacing.extraLarge)
                .padding(.bottom, Theme.Spacing.extraLarge)
                .scaleEffect(buttonAppeared ? 1 : 0.9)
                .opacity(buttonAppeared ? 1 : 0)
                .onAppear {
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.6)) {
                        buttonAppeared = true
                    }
                }
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
    
    @State private var ringRotation = false
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small + 2) {
            ZStack {
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                Theme.Colors.accent.opacity(0.3),
                                Theme.Colors.accent.opacity(0.05),
                                Theme.Colors.accent.opacity(0.2),
                                Theme.Colors.accent.opacity(0.05),
                                Theme.Colors.accent.opacity(0.3)
                            ],
                            center: .center
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 42, height: 42)
                    .rotationEffect(.degrees(ringRotation ? 360 : 0))
                    .animation(
                        .linear(duration: 15).repeatForever(autoreverses: false),
                        value: ringRotation
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.Colors.accent, Theme.Colors.accent.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .onAppear { ringRotation = true }
            
            Text(title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.medium)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(Theme.Colors.accent.opacity(0.03))
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .stroke(
                    LinearGradient(
                        colors: [
                            Theme.Colors.accent.opacity(0.15),
                            Color.white.opacity(0.1),
                            Theme.Colors.accent.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
        )
        .shadow(color: Theme.Colors.accent.opacity(0.08), radius: 10, x: 0, y: 5)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    WelcomeView()
}
