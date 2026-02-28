//
//  ProfileView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import SwiftUI
import StoreKit

struct ProfileView: View {
    @StateObject private var progress = UserProgressManager.shared
    @State private var animateContent = false
    @State private var showResetAlert = false
    @State private var showAboutSheet = false
    @State private var selectedSection: ProfileSection = .overview
    @Environment(\.requestReview) private var requestReview
    
    enum ProfileSection: String, CaseIterable {
        case overview = "Overview"
        case categories = "Categories"
        case quizzes = "Quizzes"
    }
    
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
                        // Profile Header
                        profileHeader
                        
                        // Streak & Days Banner
                        streakBanner
                        
                        // Quick Stats
                        quickStats
                        
                        // Section Picker
                        sectionPicker
                        
                        // Section Content
                        switch selectedSection {
                        case .overview:
                            overviewSection
                        case .categories:
                            categoriesSection
                        case .quizzes:
                            quizzesSection
                        }
                        
                        // Settings Section
                        settingsSection
                        
                        Spacer(minLength: Theme.Spacing.extraLarge)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                    animateContent = true
                }
            }
            .alert("Reset All Progress?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    withAnimation {
                        progress.resetAllProgress()
                    }
                }
            } message: {
                Text("This will erase all your learning progress, quiz history, and streak data. This action cannot be undone.")
            }
            .sheet(isPresented: $showAboutSheet) {
                AboutAlgoLensView()
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            ZStack {
                // Outer ring showing overall progress
                Circle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 5)
                    .frame(width: 108, height: 108)
                
                Circle()
                    .trim(from: 0, to: animateContent ? overallProgress : 0)
                    .stroke(
                        LinearGradient(
                            colors: [Theme.Colors.primaryGradientStart, Theme.Colors.primaryGradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: 108, height: 108)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.2).delay(0.3), value: animateContent)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)
                    .shadow(color: Color.purple.opacity(0.2), radius: 12, x: 0, y: 6)
                
                Image(systemName: profileIcon)
                    .font(.system(size: 48, weight: .semibold))
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
            .scaleEffect(animateContent ? 1 : 0.7)
            .opacity(animateContent ? 1 : 0)
            
            VStack(spacing: Theme.Spacing.small) {
                Text(profileTitle)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(profileSubtitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                
                // Progress percentage
                Text("\(Int(overallProgress * 100))% Complete")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.Colors.primaryGradientEnd)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.primaryGradientEnd.opacity(0.1))
                    .cornerRadius(12)
            }
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 10)
        }
        .padding(.top, Theme.Spacing.large)
    }
    
    // MARK: - Streak Banner
    private var streakBanner: some View {
        HStack(spacing: Theme.Spacing.large) {
            // Streak
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(progress.currentStreak)")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Text("Day Streak")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
            }
            
            Divider()
                .frame(height: 40)
            
            // Days Learning
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(progress.daysSinceFirstLaunch)")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Text(progress.daysSinceFirstLaunch == 1 ? "Day" : "Days")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
            }
            
            Divider()
                .frame(height: 40)
            
            // Best Streak
            HStack(spacing: 10) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.yellow)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(progress.longestStreak)")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    Text("Best Streak")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
            }
        }
        .padding(.vertical, Theme.Spacing.medium)
        .padding(.horizontal, Theme.Spacing.medium)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.orange.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, Theme.Spacing.large)
        .opacity(animateContent ? 1 : 0)
        .offset(y: animateContent ? 0 : 12)
    }
    
    // MARK: - Quick Stats
    private var quickStats: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Your Progress")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .padding(.horizontal, Theme.Spacing.large)
            
            HStack(spacing: Theme.Spacing.medium) {
                ProfileStatCard(
                    icon: "eye.fill",
                    value: "\(progress.viewedAlgorithms.count)",
                    label: "Explored",
                    total: "\(progress.totalAlgorithmsAvailable)",
                    color: .blue
                )
                ProfileStatCard(
                    icon: "play.circle.fill",
                    value: "\(progress.visualizationsStarted)",
                    label: "Visualized",
                    total: nil,
                    color: .green
                )
                ProfileStatCard(
                    icon: "checkmark.circle.fill",
                    value: "\(progress.quizzesCompleted)",
                    label: "Quizzes",
                    total: nil,
                    color: .purple
                )
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .opacity(animateContent ? 1 : 0)
        .offset(y: animateContent ? 0 : 15)
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        HStack(spacing: Theme.Spacing.small) {
            ForEach(ProfileSection.allCases, id: \.self) { section in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedSection = section
                    }
                }) {
                    Text(section.rawValue)
                        .font(.system(size: 14, weight: selectedSection == section ? .bold : .semibold, design: .rounded))
                        .foregroundColor(selectedSection == section ? .white : Theme.Colors.secondaryText)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .padding(.vertical, Theme.Spacing.small + 2)
                        .background(
                            selectedSection == section ?
                            AnyShapeStyle(LinearGradient(
                                colors: [Theme.Colors.primaryGradientStart, Theme.Colors.primaryGradientEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )) : AnyShapeStyle(Color.clear)
                        )
                        .cornerRadius(Theme.CornerRadius.medium)
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium + 2)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, Theme.Spacing.large)
        .opacity(animateContent ? 1 : 0)
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Algorithms Explored vs Total
            OverviewCard(
                icon: "function",
                title: "Algorithms Explored",
                value: "\(progress.viewedAlgorithms.count) / \(progress.totalAlgorithmsAvailable)",
                progress: progress.totalAlgorithmsAvailable > 0 ? Double(progress.viewedAlgorithms.count) / Double(progress.totalAlgorithmsAvailable) : 0,
                color: .blue
            )
            
            // Unique Visualizations
            OverviewCard(
                icon: "play.rectangle.fill",
                title: "Unique Visualizations",
                value: "\(progress.visualizationAlgorithms.count) / \(progress.totalAlgorithmsAvailable)",
                progress: progress.totalAlgorithmsAvailable > 0 ? Double(progress.visualizationAlgorithms.count) / Double(progress.totalAlgorithmsAvailable) : 0,
                color: .green
            )
            
            // Quiz Accuracy
            OverviewCard(
                icon: "brain.head.profile",
                title: "Quiz Accuracy",
                value: progress.totalQuizQuestions > 0 ? "\(Int(progress.overallQuizPercentage))%" : "No quizzes yet",
                progress: progress.overallQuizPercentage / 100,
                color: .purple
            )
            
            // Categories Explored
            OverviewCard(
                icon: "square.grid.2x2.fill",
                title: "Categories Explored",
                value: "\(progress.totalCategoriesExplored) / \(AlgorithmCategory.allCategories.count)",
                progress: Double(progress.totalCategoriesExplored) / Double(AlgorithmCategory.allCategories.count),
                color: .orange
            )
        }
        .padding(.horizontal, Theme.Spacing.large)
        .transition(.opacity.combined(with: .move(edge: .leading)))
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            ForEach(AlgorithmCategory.allCategories) { category in
                CategoryProgressCard(
                    category: category,
                    viewed: progress.algorithmsViewedInCategory(category.name),
                    total: progress.totalAlgorithmsInCategory(category.name),
                    progress: progress.categoryProgress(category.name)
                )
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
    
    // MARK: - Quizzes Section
    private var quizzesSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            if progress.quizHistory.isEmpty {
                // Empty State
                VStack(spacing: Theme.Spacing.medium) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(Theme.Colors.secondaryText.opacity(0.4))
                    
                    Text("No Quizzes Yet")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text("Complete quizzes after exploring algorithms to see your history here.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, Theme.Spacing.extraLarge)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
                )
            } else {
                // Quiz summary header
                HStack(spacing: Theme.Spacing.medium) {
                    QuizSummaryPill(
                        label: "Total",
                        value: "\(progress.quizzesCompleted)",
                        color: .blue
                    )
                    QuizSummaryPill(
                        label: "Avg Score",
                        value: "\(Int(progress.overallQuizPercentage))%",
                        color: progress.overallQuizPercentage >= 70 ? .green : .orange
                    )
                    QuizSummaryPill(
                        label: "Correct",
                        value: "\(progress.totalQuizScore)/\(progress.totalQuizQuestions)",
                        color: .purple
                    )
                }
                
                // Recent Quiz History
                ForEach(progress.recentQuizzes) { entry in
                    QuizHistoryCard(entry: entry)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Settings")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .padding(.horizontal, Theme.Spacing.large)
            
            VStack(spacing: 0) {
                Button(action: { showAboutSheet = true }) {
                    ProfileSettingsRow(icon: "info.circle.fill", title: "About AlgoLens", subtitle: "Version 1.0", color: .blue)
                }
                
                Divider().padding(.leading, 56)
                
                Button(action: { showResetAlert = true }) {
                    ProfileSettingsRow(icon: "arrow.counterclockwise.circle.fill", title: "Reset Progress", subtitle: "Clear all learning data", color: .red)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            .padding(.horizontal, Theme.Spacing.large)
        }
        .opacity(animateContent ? 1 : 0)
        .offset(y: animateContent ? 0 : 20)
    }
    
    // MARK: - Computed Helpers
    
    private var overallProgress: Double {
        guard progress.totalAlgorithmsAvailable > 0 else { return 0 }
        return Double(progress.viewedAlgorithms.count) / Double(progress.totalAlgorithmsAvailable)
    }
    
    private var profileTitle: String {
        let viewed = progress.viewedAlgorithms.count
        if viewed == 0 { return "Newcomer" }
        if viewed < 5 { return "Beginner" }
        if viewed < 15 { return "Explorer" }
        if viewed < 25 { return "Learner" }
        if viewed < progress.totalAlgorithmsAvailable { return "Advanced" }
        return "Algorithm Master"
    }
    
    private var profileSubtitle: String {
        let viewed = progress.viewedAlgorithms.count
        if viewed == 0 { return "Start exploring algorithms!" }
        if viewed < 5 { return "Just getting started 🌱" }
        if viewed < 15 { return "Making great progress! 🚀" }
        if viewed < 25 { return "You're on fire! 🔥" }
        if viewed < progress.totalAlgorithmsAvailable { return "Almost there! 💪" }
        return "You've mastered them all! 🏆"
    }
    
    private var profileIcon: String {
        let viewed = progress.viewedAlgorithms.count
        if viewed == 0 { return "person.crop.circle" }
        if viewed < 5 { return "person.crop.circle.fill" }
        if viewed < 15 { return "brain.head.profile" }
        if viewed < 25 { return "brain" }
        return "crown.fill"
    }
}

// MARK: - Profile Stat Card
struct ProfileStatCard: View {
    let icon: String
    let value: String
    let label: String
    let total: String?
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.15), color.opacity(0.05)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 22
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                if let total = total {
                    Text("of \(total)")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
            }
            
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(
                    LinearGradient(
                        colors: [color.opacity(0.2), Color.white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Overview Card
struct OverviewCard: View {
    let icon: String
    let title: String
    let value: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small + 2) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.12))
                        .frame(width: 34, height: 34)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text(value)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
            }
            
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(geo.size.width * CGFloat(min(progress, 1.0)), 0), height: 8)
                        .animation(.easeInOut(duration: 0.8), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(Theme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(Color(.separator).opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Category Progress Card
struct CategoryProgressCard: View {
    let category: AlgorithmCategory
    let viewed: Int
    let total: Int
    let progress: Double
    
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
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small + 2) {
            HStack {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.12))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                        .lineLimit(1)
                    
                    Text("\(viewed) of \(total) algorithms explored")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
                
                Spacer()
                
                // Circular progress
                ZStack {
                    Circle()
                        .stroke(categoryColor.opacity(0.15), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            categoryColor,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.8), value: progress)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(categoryColor)
                }
            }
            
            // Linear progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(categoryColor.opacity(0.1))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(geo.size.width * CGFloat(min(progress, 1.0)), 0), height: 6)
                        .animation(.easeInOut(duration: 0.8), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(Theme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .stroke(
                    LinearGradient(
                        colors: [categoryColor.opacity(0.2), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: categoryColor.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Quiz Summary Pill
struct QuizSummaryPill: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.small + 4)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Quiz History Card
struct QuizHistoryCard: View {
    let entry: QuizHistoryEntry
    
    private var scoreColor: Color {
        if entry.percentage >= 90 { return .green }
        if entry.percentage >= 70 { return .blue }
        if entry.percentage >= 50 { return .orange }
        return .red
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            // Score Circle
            ZStack {
                Circle()
                    .stroke(scoreColor.opacity(0.2), lineWidth: 3)
                    .frame(width: 48, height: 48)
                
                Circle()
                    .trim(from: 0, to: CGFloat(entry.percentage / 100))
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(entry.percentage))%")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundColor(scoreColor)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.algorithmName)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineLimit(1)
                
                Text("\(entry.score)/\(entry.totalQuestions) correct • \(entry.categoryName)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(entry.date.formatted(.relative(presentation: .named)))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .padding(Theme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .stroke(Color(.separator).opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Profile Settings Row
struct ProfileSettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.12))
                    .frame(width: 34, height: 34)
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.Colors.secondaryText.opacity(0.5))
        }
        .padding(.horizontal, Theme.Spacing.medium)
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView()
}
