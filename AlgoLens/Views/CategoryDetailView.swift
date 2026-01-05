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
                    // Category Header
                    VStack(spacing: Theme.Spacing.medium) {
                        ZStack {
                            Circle()
                                .fill(categoryColor.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: category.icon)
                                .font(.system(size: 48))
                                .foregroundColor(categoryColor)
                        }
                        .padding(.top, Theme.Spacing.large)
                        
                        Text(category.name)
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text(category.description)
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    // Coming Soon Section
                    VStack(spacing: Theme.Spacing.medium) {
                        Image(systemName: "hammer.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.Colors.secondaryText.opacity(0.5))
                        
                        Text("Algorithm List Coming Soon")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("This category will contain detailed algorithm visualizations and explanations.")
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.extraLarge)
                    }
                    .padding(.vertical, Theme.Spacing.extraLarge)
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(category.name)
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

#Preview {
    NavigationStack {
        CategoryDetailView(
            category: AlgorithmCategory(
                name: "Sorting Algorithms",
                description: "Bubble, Quick, Merge, Heap, and more",
                icon: "arrow.up.arrow.down.circle.fill",
                color: .purple
            )
        )
    }
}
