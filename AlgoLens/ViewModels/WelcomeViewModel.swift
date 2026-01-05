//
//  WelcomeViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI
import Combine

@MainActor
class WelcomeViewModel: ObservableObject {
    @Published var isNavigatingToHome = false
    
    // MARK: - User Actions
    func startLearning() {
        // Animate the transition
        withAnimation(.easeInOut(duration: 0.3)) {
            isNavigatingToHome = true
        }
        
        // In the future, this could handle:
        // - User onboarding checks
        // - Analytics tracking
        // - Loading initial data
        // - Checking for saved progress
    }
    
    // MARK: - Features (for future expansion)
    let features = [
        ("chart.bar.fill", "Data Structures"),
        ("function", "Algorithms"),
        ("eye.fill", "Visualizations")
    ]
}
