//
//  AboutAlgoLensView.swift
//  AlgoLens
//
//  Created on 28/02/26.
//

import SwiftUI

struct AboutAlgoLensView: View {
    @Environment(\.dismiss) private var dismiss
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        // App Icon & Name
                        VStack(spacing: Theme.Spacing.medium) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.purple.opacity(0.2), radius: 12, x: 0, y: 6)
                                
                                Image(systemName: "eye.circle.fill")
                                    .font(.system(size: 50, weight: .semibold))
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
                            
                            Text("AlgoLens")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            Text("Version \(appVersion) (\(buildNumber))")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.secondaryText)
                        }
                        .padding(.top, Theme.Spacing.extraLarge)
                        
                        // Description
                        VStack(spacing: Theme.Spacing.small) {
                            Text("Visualize. Learn. Master.")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            Text("AlgoLens is an interactive algorithm learning app that helps you understand data structures and algorithms through beautiful visualizations, step-by-step explanations, and quizzes.")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(Theme.Colors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Theme.Spacing.large)
                        }
                        .padding(Theme.Spacing.medium)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                                .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        // Features
                        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                            Text("Features")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            AboutFeatureRow(icon: "play.rectangle.fill", title: "Interactive Visualizations", description: "Watch algorithms come to life", color: .green)
                            AboutFeatureRow(icon: "book.fill", title: "Detailed Explanations", description: "Step-by-step algorithm breakdowns", color: .blue)
                            AboutFeatureRow(icon: "brain.head.profile", title: "Quizzes", description: "Test your understanding", color: .purple)
                            AboutFeatureRow(icon: "chart.bar.fill", title: "Progress Tracking", description: "Track your learning journey", color: .orange)
                        }
                        .padding(Theme.Spacing.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                                .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        // Footer
                        VStack(spacing: Theme.Spacing.small) {
                            Text("Made with ❤️ for algorithm enthusiasts")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.secondaryText)
                            
                            Text("© 2026 AlgoLens. All rights reserved.")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(Theme.Colors.secondaryText.opacity(0.7))
                        }
                        .padding(.top, Theme.Spacing.medium)
                        
                        Spacer(minLength: Theme.Spacing.extraLarge)
                    }
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
            }
        }
    }
}

// MARK: - About Feature Row
struct AboutFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
            }
        }
    }
}

#Preview {
    AboutAlgoLensView()
}
