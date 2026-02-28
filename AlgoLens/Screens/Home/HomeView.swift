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
    @State private var appeared = false
    @State private var shimmerOffset: CGFloat = -200
    @State private var iconBounce = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top Row: Icon + Decorative dots
            HStack(alignment: .top) {
                // Animated icon with layered rings
                ZStack {
                    // Rotating angular gradient ring
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    categoryColor.opacity(0.4),
                                    categoryColor.opacity(0.08),
                                    categoryColor.opacity(0.3),
                                    categoryColor.opacity(0.05),
                                    categoryColor.opacity(0.4)
                                ],
                                center: .center
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: 68, height: 68)
                        .rotationEffect(.degrees(appeared ? 360 : 0))
                        .animation(
                            .linear(duration: 12).repeatForever(autoreverses: false),
                            value: appeared
                        )
                    
                    // Inner radial glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    categoryColor.opacity(0.22),
                                    categoryColor.opacity(0.06)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.65)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(iconBounce ? 1.12 : 1.0)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.5),
                            value: iconBounce
                        )
                }
                .onAppear {
                    appeared = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        iconBounce = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            iconBounce = false
                        }
                    }
                }
                
                Spacer()
                
                // Decorative floating dots
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(categoryColor.opacity(0.15 + Double(i) * 0.1))
                            .frame(width: 6 - CGFloat(i), height: 6 - CGFloat(i))
                    }
                }
                .padding(.top, 6)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 7) {
                Text(category.name)
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                
                Text(category.description)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer(minLength: 0)
            
            // Filled capsule "Explore" CTA
            HStack(spacing: 0) {
                HStack(spacing: 6) {
                    Text("Explore")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .heavy))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: categoryColor.opacity(0.35), radius: 6, x: 0, y: 3)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            ZStack {
                // Frosted glass base
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4)
                    .fill(.ultraThinMaterial)
                
                // Subtle gradient tint
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4)
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.05),
                                Color.clear,
                                categoryColor.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Decorative blob top-right
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [categoryColor.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 100, height: 100)
                    .offset(x: 50, y: -40)
                
                // Decorative blob bottom-left
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [categoryColor.opacity(0.06), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 70, height: 70)
                    .offset(x: -35, y: 50)
                
                // Shimmer sweep
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.06),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerOffset)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 3)
                            .repeatForever(autoreverses: false)
                            .delay(1)
                        ) {
                            shimmerOffset = 250
                        }
                    }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large + 4)
                .stroke(
                    LinearGradient(
                        colors: [
                            categoryColor.opacity(0.35),
                            categoryColor.opacity(0.08),
                            Color.white.opacity(0.15),
                            categoryColor.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
        .shadow(color: categoryColor.opacity(0.18), radius: 18, x: 0, y: 8)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
