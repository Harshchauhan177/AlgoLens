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
    }
}

#Preview {
    MainTabView()
}
