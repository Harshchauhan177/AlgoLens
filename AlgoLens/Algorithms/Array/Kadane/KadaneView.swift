//
//  KadaneView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct KadaneVisualizationView: View {
    @StateObject private var viewModel = KadaneViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Kadane's Algorithm").font(Theme.Fonts.title).padding()
                Text("Find maximum sum subarray").font(Theme.Fonts.subtitle).foregroundColor(.secondary)
                
                if !viewModel.stepInfo.isEmpty {
                    Text(viewModel.stepInfo).foregroundColor(.blue).padding()
                }
                
                HStack {
                    Button("Start") { viewModel.start() }.buttonStyle(.borderedProminent).disabled(!viewModel.canStart)
                    Button("Next") { viewModel.nextStep() }.buttonStyle(.borderedProminent).disabled(!viewModel.canNext)
                    Button("Reset") { viewModel.reset() }.buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("Kadane's Algorithm")
    }
}
