//
//  DutchNationalFlagView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct DutchNationalFlagVisualizationView: View {
    @StateObject private var viewModel = DutchNationalFlagViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Dutch National Flag").font(Theme.Fonts.title).padding()
                Text("Sort array with three distinct values").font(Theme.Fonts.subtitle).foregroundColor(.secondary)
                
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
        .navigationTitle("Dutch National Flag")
    }
}
