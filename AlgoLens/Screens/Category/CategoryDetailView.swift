//
//  CategoryDetailView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: AlgorithmCategory
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            // Route to specific category screen if available
            if category.name == "Searching Algorithms" {
                SearchingAlgorithmsView()
            } else if category.name == "Sorting Algorithms" {
                SortingAlgorithmsView()
            } else if category.name == "Array Algorithms" {
                ArrayAlgorithmsView()
            } else if category.name == "String Algorithms" {
                StringAlgorithmsView()
            } else if category.name == "Recursion & Backtracking" {
                RecursionCategoryView()
            } else if category.name == "Dynamic Programming" {
                DPAlgorithmsView()
            } else {
                // Placeholder for other categories
                CategoryPlaceholderView(category: category)
            }
        }
    }
}

// MARK: - Category Placeholder View
struct CategoryPlaceholderView: View {
    let category: AlgorithmCategory
    @State private var animateElements = false
    @State private var pulseAnimation = false
    
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
                VStack(spacing: Theme.Spacing.extraLarge) {
                    // Category Header with Animation
                    VStack(spacing: Theme.Spacing.medium + 4) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            categoryColor.opacity(0.15),
                                            categoryColor.opacity(0.25)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: categoryColor.opacity(0.3), radius: 20, x: 0, y: 10)
                                .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                                .animation(
                                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: pulseAnimation
                                )
                            
                            Image(systemName: category.icon)
                                .font(.system(size: 56, weight: .semibold))
                                .foregroundColor(categoryColor)
                        }
                        .padding(.top, Theme.Spacing.large)
                        .opacity(animateElements ? 1 : 0)
                        .offset(y: animateElements ? 0 : -20)
                        
                        VStack(spacing: Theme.Spacing.small) {
                            Text(category.name)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .opacity(animateElements ? 1 : 0)
                                .offset(y: animateElements ? 0 : 20)
                            
                            Text(category.description)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Theme.Colors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Theme.Spacing.large)
                                .opacity(animateElements ? 1 : 0)
                                .offset(y: animateElements ? 0 : 20)
                        }
                    }
                    
                    // Coming Soon Badge
                    HStack(spacing: Theme.Spacing.small) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14, weight: .semibold))
                        Text("COMING SOON")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .tracking(1.2)
                    }
                    .foregroundColor(categoryColor)
                    .padding(.horizontal, Theme.Spacing.medium + 4)
                    .padding(.vertical, Theme.Spacing.small)
                    .background(categoryColor.opacity(0.12))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(categoryColor.opacity(0.3), lineWidth: 1.5)
                    )
                    .opacity(animateElements ? 1 : 0)
                    .scaleEffect(animateElements ? 1 : 0.8)
                    
                    // Feature Preview Cards
                    VStack(spacing: Theme.Spacing.medium) {
                        FeaturePreviewCard(
                            icon: "play.circle.fill",
                            title: "Interactive Visualizations",
                            description: "Watch algorithms come to life with step-by-step animations",
                            color: .blue
                        )
                        .opacity(animateElements ? 1 : 0)
                        .offset(y: animateElements ? 0 : 30)
                        
                        FeaturePreviewCard(
                            icon: "doc.text.fill",
                            title: "Detailed Explanations",
                            description: "Learn with comprehensive guides and code examples",
                            color: .purple
                        )
                        .opacity(animateElements ? 1 : 0)
                        .offset(y: animateElements ? 0 : 30)
                        
                        FeaturePreviewCard(
                            icon: "brain.head.profile",
                            title: "Practice Quizzes",
                            description: "Test your understanding with interactive questions",
                            color: .green
                        )
                        .opacity(animateElements ? 1 : 0)
                        .offset(y: animateElements ? 0 : 30)
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.medium)
                    
                    // Construction Message
                    VStack(spacing: Theme.Spacing.medium) {
                        Image(systemName: "hammer.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [categoryColor, categoryColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("We're Building Something Great")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("This category is under active development. Check back soon for amazing algorithm visualizations!")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.vertical, Theme.Spacing.large)
                    .opacity(animateElements ? 1 : 0)
                    
                    Spacer(minLength: Theme.Spacing.large)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(category.name)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateElements = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pulseAnimation = true
            }
        }
    }
    
    private var categoryColor: Color {
        switch category.color {
        case .blue: return .blue
        case .purple: return .purple
        case .green: return .green
        case .orange: return .orange
        case .red: return .red
        case .pink: return .pink
        case .teal: return .teal
        case .indigo: return .indigo
        case .mint: return .mint
        case .cyan: return .cyan
        case .yellow: return .yellow
        case .brown: return .brown
        }
    }
}

// MARK: - Feature Preview Card
struct FeaturePreviewCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    @State private var appeared = false
    @State private var shimmerOffset: CGFloat = -300
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Icon with animated ring
            ZStack {
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                color.opacity(0.35),
                                color.opacity(0.08),
                                color.opacity(0.25),
                                color.opacity(0.05),
                                color.opacity(0.35)
                            ],
                            center: .center
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 54, height: 54)
                    .rotationEffect(.degrees(appeared ? 360 : 0))
                    .animation(
                        .linear(duration: 14).repeatForever(autoreverses: false),
                        value: appeared
                    )
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.2), color.opacity(0.05)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 22
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .onAppear { appeared = true }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(description)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(Theme.Spacing.medium)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(0.04),
                                Color.clear,
                                color.opacity(0.02)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                // Decorative blob
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.08), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 45
                        )
                    )
                    .frame(width: 70, height: 70)
                    .offset(x: 130, y: -25)
                
                // Shimmer
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(
                        LinearGradient(
                            colors: [Color.clear, Color.white.opacity(0.05), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerOffset)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 3.5)
                            .repeatForever(autoreverses: false)
                            .delay(1.5)
                        ) {
                            shimmerOffset = 400
                        }
                    }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(
                    LinearGradient(
                        colors: [
                            color.opacity(0.25),
                            color.opacity(0.06),
                            Color.white.opacity(0.1),
                            color.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: color.opacity(0.12), radius: 12, x: 0, y: 6)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview("Category Detail Placeholder") {
    let sampleCategory = AlgorithmCategory(
        name: "Searching Algorithms",
        description: "Algorithms that operate on graphs such as BFS, DFS, Dijkstra, and more.",
        icon: "network",
        color: .purple
    )
    return NavigationStack {
        CategoryDetailView(category: sampleCategory)
    }
}
