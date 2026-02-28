//
//  AppearanceManager.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import SwiftUI
import Combine

class AppearanceManager: ObservableObject {
    static let shared = AppearanceManager()
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            UserDefaults.standard.set(true, forKey: "hasSetAppearance")
        }
    }
    
    var colorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }
    
    private init() {
        if UserDefaults.standard.bool(forKey: "hasSetAppearance") {
            self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        } else {
            // First launch: detect system appearance
            self.isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
}
