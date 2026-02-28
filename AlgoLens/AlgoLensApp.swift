//
//  AlgoLensApp.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

@main
struct AlgoLensApp: App {
    @StateObject private var appearanceManager = AppearanceManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appearanceManager)
                .preferredColorScheme(appearanceManager.isDarkMode ? .dark : .light)
        }
    }
}
