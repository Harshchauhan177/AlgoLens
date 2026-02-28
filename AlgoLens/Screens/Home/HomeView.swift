//
//  HomeView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var animateCards = false
    
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
                        // Enhanced Header Section with Icon
                        VStack(spacing: Theme.Spacing.medium) {
                            // App Icon/Logo
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.blue.opacity(0.2), radius: 12, x: 0, y: 6)
                                
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.blue, Color.purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .padding(.top, Theme.Spacing.medium)
                            
                            VStack(spacing: Theme.Spacing.small) {
                                Text("Algorithms Explorer")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Text("Master algorithms through interactive visualizations")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, Theme.Spacing.large)
                            }
                        }
                        .padding(.top, Theme.Spacing.small)
                        
                        // Enhanced Search Bar
                        SearchBar(text: $viewModel.searchText)
                            .padding(.horizontal, Theme.Spacing.large)
                        
                        // Categories Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Categories")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Text("\(viewModel.filteredCategories.count) available")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.top, Theme.Spacing.small)
                        
                        // Enhanced Category Grid with Animation
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: Theme.Spacing.medium),
                                GridItem(.flexible(), spacing: Theme.Spacing.medium)
                            ],
                            spacing: Theme.Spacing.medium
                        ) {
                            ForEach(Array(viewModel.filteredCategories.enumerated()), id: \.element.id) { index, category in
                                NavigationLink(value: category) {
                                    EnhancedCategoryCard(category: category)
                                        .opacity(animateCards ? 1 : 0)
                                        .offset(y: animateCards ? 0 : 20)
                                        .animation(
                                            .spring(response: 0.6, dampingFraction: 0.8)
                                                .delay(Double(index) * 0.1),
                                            value: animateCards
                                        )
                                }
                                .buttonStyle(EnhancedCardButtonStyle())
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.bottom, Theme.Spacing.extraLarge)
                    }
                }
                .navigationDestination(for: AlgorithmCategory.self) { category in
                    CategoryDetailView(category: category)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation {
                    animateCards = true
                }
            }
        }
    }
}

// MARK: - Enhanced Search Bar
struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: Theme.Spacing.small + 2) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused ? .blue : Theme.Colors.secondaryText)
                .font(.system(size: 16, weight: .semibold))
            
            TextField("Search algorithms...", text: $text)
                .font(.system(size: 16, weight: .medium))
                .focused($isFocused)
            
            if !text.isEmpty {
                Button(action: { 
                    text = "" 
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.Colors.secondaryText)
                        .font(.system(size: 16))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, Theme.Spacing.medium + 2)
        .padding(.vertical, Theme.Spacing.medium)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.medium + 2)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium + 2)
                .stroke(isFocused ? Color.blue.opacity(0.4) : Color.clear, lineWidth: 2)
        )
        .shadow(color: isFocused ? Color.blue.opacity(0.15) : Color.black.opacity(0.06), radius: isFocused ? 12 : 8, x: 0, y: 4)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

// MARK: - Enhanced Category Card with Premium Design
struct EnhancedCategoryCard: View {
    let category: AlgorithmCategory
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Icon with gradient background + decorative ring
            ZStack {
                // Outer decorative ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.3),
                                categoryColor.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 68, height: 68)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.18),
                                categoryColor.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 58, height: 58)
                
                Image(systemName: category.icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
                Text(category.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                
                Text(category.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer(minLength: 0)
            
            // Pill-shaped "Explore" button
            HStack(spacing: 6) {
                Text("Explore")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(categoryColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(categoryColor.opacity(0.12))
            )
            .overlay(
                Capsule()
                    .stroke(categoryColor.opacity(0.2), lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            ZStack {
                // Base card background (dark mode aware)
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4)
                    .fill(Theme.Colors.cardBackground)
                
                // Decorative blob in top-right corner
                Circle()
                    .fill(categoryColor.opacity(0.06))
                    .frame(width: 100, height: 100)
                    .offset(x: 50, y: -40)
                    .clipped()
                
                // Subtle gradient overlay from category color
                LinearGradient(
                    colors: [
                        categoryColor.opacity(0.04),
                        Color.clear,
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4)
                .stroke(
                    LinearGradient(
                        colors: [
                            categoryColor.opacity(0.25),
                            categoryColor.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: categoryColor.opacity(0.12), radius: 16, x: 0, y: 8)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
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

// MARK: - Enhanced Card Button Style with Bounce
struct EnhancedCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    HomeView()
}
