//
//  SubarraySumView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct SubarraySumVisualizationView: View {
    @StateObject private var viewModel = SubarraySumViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Subarray Sum").font(Theme.Fonts.title).padding()
                Text("Find subarrays with given sum using hashing").font(Theme.Fonts.subtitle).foregroundColor(.secondary)
                
                if !viewModel.resultInfo.isEmpty {
                    Text(viewModel.resultInfo).foregroundColor(.green).padding()
                }
                
                HStack {
                    Button("Start") { viewModel.start() }.buttonStyle(.borderedProminent).disabled(!viewModel.canStart)
                    Button("Reset") { viewModel.reset() }.buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("Subarray Sum")
    }
}
