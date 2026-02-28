//
//  MainTabView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appearanceManager: AppearanceManager
    @State private var selectedTab: Tab = .home
    @Environment(\.colorScheme) private var colorScheme
    
    enum Tab {
        case home
        case profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(appearanceManager)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            ProfileView()
                .environmentObject(appearanceManager)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(Theme.Colors.primaryGradientEnd)
        .preferredColorScheme(appearanceManager.colorScheme)
        .onAppear {
            configureTabBarAppearance()
        }
        .onChange(of: appearanceManager.isDarkMode) { _ in
            configureTabBarAppearance()
        }
    }
    
    // MARK: - Tab Bar Appearance
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        if appearanceManager.isDarkMode {
            // Dark Mode: translucent dark background
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 0.92)
            appearance.shadowColor = UIColor.white.withAlphaComponent(0.06)
        } else {
            // Light Mode: translucent light background
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 1.0, alpha: 0.94)
            appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)
        }
        
        // Active (selected) tab item
        let selectedColor = UIColor(Theme.Colors.primaryGradientEnd)
        let normalItemAppearance = UITabBarItemAppearance()
        normalItemAppearance.selected.iconColor = selectedColor
        normalItemAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .bold)
        ]
        
        // Inactive (unselected) tab item
        let unselectedColor = appearanceManager.isDarkMode
            ? UIColor.white.withAlphaComponent(0.4)
            : UIColor.black.withAlphaComponent(0.35)
        normalItemAppearance.normal.iconColor = unselectedColor
        normalItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: unselectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance = normalItemAppearance
        appearance.inlineLayoutAppearance = normalItemAppearance
        appearance.compactInlineLayoutAppearance = normalItemAppearance
        
        // Apply background blur effect
        appearance.backgroundEffect = UIBlurEffect(
            style: appearanceManager.isDarkMode ? .systemChromeMaterialDark : .systemChromeMaterialLight
        )
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppearanceManager.shared)
}
