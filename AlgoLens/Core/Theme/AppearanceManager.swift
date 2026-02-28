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
        }
    }
    
    var colorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }
    
    private init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}
