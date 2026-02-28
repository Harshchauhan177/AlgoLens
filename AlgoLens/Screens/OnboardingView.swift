//
//  OnboardingView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

// MARK: - Onboarding Page Model
private struct OnboardingPage {
    let systemImage: String
    let title: String
    let subtitle: String
    let accentColor: Color
    let secondaryColor: Color
}

// MARK: - Floating Particle Model
private struct FloatingParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let opacity: Double
    let speed: Double
    let delay: Double
}

// MARK: - OnboardingView
struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var particles: [FloatingParticle] = []
    @State private var animateParticles = false
    @State private var titleAppeared = false
    @State private var buttonsAppeared = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            systemImage: "sparkles",
            title: "See Algorithms\nCome Alive",
            subtitle: "Watch step-by-step visualizations that turn abstract concepts into something you can actually feel and understand.",
            accentColor: Color(red: 0.3, green: 0.55, blue: 1.0),
            secondaryColor: Color(red: 0.5, green: 0.3, blue: 0.95)
        ),
        OnboardingPage(
            systemImage: "brain.head.profile",
            title: "Practice with\nSmart Quizzes",
            subtitle: "Reinforce your intuition with quick, focused quizzes tailored to each algorithm you explore.",
            accentColor: Color(red: 0.6, green: 0.3, blue: 0.9),
            secondaryColor: Color(red: 0.85, green: 0.3, blue: 0.7)
        ),
        OnboardingPage(
            systemImage: "chart.bar.fill",
            title: "Track Your\nProgress",
            subtitle: "Build confidence as you move from basics to advanced patterns across arrays, strings, recursion, DP and more.",
            accentColor: Color(red: 0.2, green: 0.8, blue: 0.6),
            secondaryColor: Color(red: 0.3, green: 0.55, blue: 1.0)
        )
    ]
    
    private var currentAccent: Color {
        pages[currentPage].accentColor
    }
    
    private var currentSecondary: Color {
        pages[currentPage].secondaryColor
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Animated Background
                animatedBackground(size: geo.size)
                
                VStack(spacing: 0) {
                    // MARK: - Top Bar
                    topBar
                    
                    Spacer(minLength: 0)
                    
                    // MARK: - Welcome Title
                    welcomeTitle
                        .padding(.bottom, 8)
                    
                    // MARK: - Page Content
                    pageContent(size: geo.size)
                    
                    // MARK: - Progress Indicator
                    progressIndicator
                        .padding(.top, Theme.Spacing.large)
                    
                    Spacer(minLength: 0)
                    
                    // MARK: - Bottom Buttons
                    bottomButtons
                }
            }
        }
        .onAppear {
            generateParticles()
            withAnimation(.easeOut(duration: 0.8)) {
                animateParticles = true
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.75).delay(0.2)) {
                titleAppeared = true
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.5)) {
                buttonsAppeared = true
            }
        }
    }
    
    // MARK: - Animated Background
    @ViewBuilder
    private func animatedBackground(size: CGSize) -> some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Theme.Colors.backgroundGradientStart,
                    Theme.Colors.backgroundGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Accent glow blobs
            Circle()
                .fill(
                    RadialGradient(
                        colors: [currentAccent.opacity(0.15), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: -80, y: -size.height * 0.2)
                .animation(.easeInOut(duration: 0.8), value: currentPage)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [currentSecondary.opacity(0.1), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 180
                    )
                )
                .frame(width: 350, height: 350)
                .offset(x: 100, y: size.height * 0.25)
                .animation(.easeInOut(duration: 0.8).delay(0.1), value: currentPage)
            
            // Floating particles
            ForEach(particles) { particle in
                Circle()
                    .fill(currentAccent.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .offset(y: animateParticles ? -30 : 30)
                    .animation(
                        .easeInOut(duration: particle.speed)
                        .repeatForever(autoreverses: true)
                        .delay(particle.delay),
                        value: animateParticles
                    )
            }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            // Step counter
            Text("\(currentPage + 1) of \(pages.count)")
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(currentAccent)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(currentAccent.opacity(0.1))
                        .overlay(
                            Capsule()
                                .stroke(currentAccent.opacity(0.2), lineWidth: 1)
                        )
                )
                .animation(.easeInOut(duration: 0.3), value: currentPage)
            
            Spacer()
            
            // Skip button (hidden on last page)
            if currentPage < pages.count - 1 {
                Button(action: {
                    hapticLight()
                    completeOnboarding()
                }) {
                    Text("Skip")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .padding(.vertical, Theme.Spacing.small)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .padding(.top, Theme.Spacing.medium + 4)
        .padding(.horizontal, Theme.Spacing.large)
        .animation(.easeInOut(duration: 0.3), value: currentPage)
    }
    
    // MARK: - Welcome Title
    private var welcomeTitle: some View {
        VStack(spacing: 4) {
            Text("Welcome to")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
            
            HStack(spacing: 8) {
                Image(systemName: "eye.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [currentAccent, currentSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                Text("AlgoLens")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.Colors.primaryText, Theme.Colors.primaryText.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        }
        .scaleEffect(titleAppeared ? 1 : 0.85)
        .opacity(titleAppeared ? 1 : 0)
    }
    
    // MARK: - Page Content
    @ViewBuilder
    private func pageContent(size: CGSize) -> some View {
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                OnboardingPageContentView(
                    page: page,
                    isActive: currentPage == index
                )
                .tag(index)
                .padding(.horizontal, Theme.Spacing.large + 4)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: min(size.height * 0.52, 420))
    }
    
    // MARK: - Progress Indicator
    private var progressIndicator: some View {
        VStack(spacing: Theme.Spacing.small + 2) {
            // Segmented progress bar
            HStack(spacing: 6) {
                ForEach(pages.indices, id: \.self) { index in
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            // Track
                            Capsule()
                                .fill(Color.gray.opacity(0.15))
                            
                            // Fill
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [currentAccent, currentSecondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: index < currentPage ? geo.size.width :
                                        (index == currentPage ? geo.size.width : 0))
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                        }
                    }
                    .frame(height: 4)
                }
            }
            .padding(.horizontal, Theme.Spacing.extraLarge + 8)
        }
    }
    
    // MARK: - Bottom Buttons
    private var bottomButtons: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack(spacing: Theme.Spacing.medium) {
                // Back button (shown after first page)
                if currentPage > 0 {
                    Button(action: {
                        hapticLight()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            currentPage -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.Colors.primaryText)
                            .frame(width: 52, height: 52)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .stroke(currentAccent.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.6)).combined(with: .move(edge: .leading)))
                }
                
                // Primary action button
                Button(action: {
                    hapticMedium()
                    handlePrimaryAction()
                }) {
                    HStack(spacing: Theme.Spacing.small) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        Image(systemName: currentPage == pages.count - 1 ? "arrow.right.circle.fill" : "arrow.right")
                            .font(.system(size: currentPage == pages.count - 1 ? 20 : 16, weight: .semibold))
                            .symbolEffect(.bounce, value: currentPage)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        ZStack {
                            LinearGradient(
                                colors: [currentAccent, currentSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            
                            // Shimmer
                            if currentPage == pages.count - 1 {
                                ShimmerOverlay()
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: currentAccent.opacity(0.4), radius: 20, x: 0, y: 10)
                    .shadow(color: currentSecondary.opacity(0.2), radius: 8, x: 0, y: 4)
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge + 8)
        .opacity(buttonsAppeared ? 1 : 0)
        .offset(y: buttonsAppeared ? 0 : 30)
    }
    
    // MARK: - Actions
    private func handlePrimaryAction() {
        if currentPage < pages.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.3)) {
            hasSeenOnboarding = true
        }
    }
    
    // MARK: - Particles
    private func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        particles = (0..<18).map { _ in
            FloatingParticle(
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: 0...screenHeight),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.06...0.2),
                speed: Double.random(in: 2.5...5.0),
                delay: Double.random(in: 0...2)
            )
        }
    }
    
    // MARK: - Haptics
    private func hapticLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func hapticMedium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

// MARK: - Page Content View
private struct OnboardingPageContentView: View {
    let page: OnboardingPage
    let isActive: Bool
    
    @State private var iconScale: CGFloat = 0.6
    @State private var iconRotation: Double = -10
    @State private var ringScale: CGFloat = 0.8
    @State private var ringRotation: Double = 0
    @State private var cardOffset: CGFloat = 30
    @State private var cardOpacity: Double = 0
    @State private var orbsVisible = false
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large + 4) {
            // MARK: - Animated Icon
            ZStack {
                // Outer pulsing ring
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                page.accentColor.opacity(0.4),
                                page.secondaryColor.opacity(0.1),
                                page.accentColor.opacity(0.3),
                                page.secondaryColor.opacity(0.05),
                                page.accentColor.opacity(0.4)
                            ],
                            center: .center
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(ringScale)
                    .rotationEffect(.degrees(ringRotation))
                
                // Middle glow ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                page.accentColor.opacity(0.25),
                                page.secondaryColor.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(ringScale)
                    .rotationEffect(.degrees(-ringRotation * 0.7))
                
                // Radial glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                page.accentColor.opacity(0.2),
                                page.secondaryColor.opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                // Floating orbs
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    page.accentColor.opacity(0.6),
                                    page.secondaryColor.opacity(0.3)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 8, height: 8)
                        .offset(
                            x: cos(Double(i) * 2.094) * (orbsVisible ? 64 : 40),
                            y: sin(Double(i) * 2.094) * (orbsVisible ? 64 : 40)
                        )
                        .opacity(orbsVisible ? 0.8 : 0)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.3),
                            value: orbsVisible
                        )
                }
                
                // Main icon circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [page.accentColor, page.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)
                    .shadow(color: page.accentColor.opacity(0.4), radius: 24, x: 0, y: 12)
                    .overlay(
                        // Inner highlight
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.25), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                    )
                    .overlay(
                        Image(systemName: page.systemImage)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                    )
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
            }
            .onAppear {
                // Icon entrance
                withAnimation(.spring(response: 0.7, dampingFraction: 0.65)) {
                    iconScale = 1.0
                    iconRotation = 0
                }
                // Ring animation
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                    ringScale = 1.0
                }
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    ringRotation = 360
                }
                // Orbs
                withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                    orbsVisible = true
                }
            }
            .onChange(of: isActive) { active in
                if active {
                    iconScale = 0.6
                    iconRotation = -10
                    cardOffset = 30
                    cardOpacity = 0
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
                        iconScale = 1.0
                        iconRotation = 0
                    }
                    withAnimation(.easeOut(duration: 0.4).delay(0.15)) {
                        cardOffset = 0
                        cardOpacity = 1
                    }
                }
            }
            
            // MARK: - Text Content Card
            VStack(spacing: Theme.Spacing.medium + 4) {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                Text(page.subtitle)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, Theme.Spacing.extraLarge)
            .padding(.horizontal, Theme.Spacing.large + 4)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.extraLarge + 4)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.extraLarge + 4)
                        .fill(Theme.Colors.cardSurface.opacity(0.3))
                    
                    // Subtle accent tint in card
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.extraLarge + 4)
                        .fill(
                            LinearGradient(
                                colors: [
                                    page.accentColor.opacity(0.04),
                                    Color.clear,
                                    page.secondaryColor.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.extraLarge + 4)
                    .stroke(
                        LinearGradient(
                            colors: [
                                page.accentColor.opacity(0.3),
                                Color.white.opacity(0.1),
                                page.secondaryColor.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: page.accentColor.opacity(0.1), radius: 20, x: 0, y: 10)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            .offset(y: cardOffset)
            .opacity(cardOpacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.45).delay(0.2)) {
                    cardOffset = 0
                    cardOpacity = 1
                }
            }
        }
    }
}

// MARK: - Shimmer Overlay for CTA
private struct ShimmerOverlay: View {
    @State private var offset: CGFloat = -200
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [Color.clear, Color.white.opacity(0.15), Color.clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .offset(x: offset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.5)
                    .repeatForever(autoreverses: false)
                    .delay(0.5)
                ) {
                    offset = 300
                }
            }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}

