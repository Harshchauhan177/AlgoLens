//
//  ExponentialSearchView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI

struct ExponentialSearchView: View {
    @StateObject private var viewModel = ExponentialSearchViewModel()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.95, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Exponential Search Visualization")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                
                Text("Coming Soon")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Exponential Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExponentialSearchView()
    }
}
