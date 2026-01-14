//
//  PrefixSumView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct PrefixSumVisualizationView: View {
    @StateObject private var viewModel = PrefixSumViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Prefix Sum").font(Theme.Fonts.title).padding()
                Text("Precompute cumulative sums for range queries").font(Theme.Fonts.subtitle).foregroundColor(.secondary)
                
                HStack {
                    Button("Start") { viewModel.start() }.buttonStyle(.borderedProminent).disabled(!viewModel.canStart)
                    Button("Next") { viewModel.nextStep() }.buttonStyle(.borderedProminent).disabled(!viewModel.canNext)
                    Button("Reset") { viewModel.reset() }.buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("Prefix Sum")
    }
}
