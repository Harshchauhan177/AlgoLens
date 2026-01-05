//
//  HomeView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
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
                            Text("Algorithms Explorer")
                                .font(Theme.Fonts.largeTitle)
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            Text("Choose a category to visualize")
                                .font(Theme.Fonts.subtitle)
                                .foregroundColor(Theme.Colors.secondaryText)
                        }
                        .padding(.top, Theme.Spacing.large)
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        // Search Bar
                        SearchBar(text: $viewModel.searchText)
                            .padding(.horizontal, Theme.Spacing.large)
                        
                        // Category Grid
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: Theme.Spacing.medium),
                                GridItem(.flexible(), spacing: Theme.Spacing.medium)
                            ],
                            spacing: Theme.Spacing.medium
                        ) {
                            ForEach(viewModel.filteredCategories) { category in
                                NavigationLink(value: category) {
                                    CategoryCard(category: category)
                                }
                                .buttonStyle(CardButtonStyle())
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.bottom, Theme.Spacing.large)
                    }
                }
                .navigationDestination(for: AlgorithmCategory.self) { category in
                    CategoryDetailView(category: category)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.Colors.secondaryText)
            
            TextField("Search algorithms...", text: $text)
                .font(Theme.Fonts.body)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.Colors.secondaryText)
                }
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.8))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: AlgorithmCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            // Icon
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.icon)
                    .font(.system(size: 28))
                    .foregroundColor(categoryColor)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text(category.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                
                Text(category.description)
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
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

// MARK: - Card Button Style
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    HomeView()
}
