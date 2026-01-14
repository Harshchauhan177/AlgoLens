//
//  SlidingWindowView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct SlidingWindowVisualizationView: View {
    @StateObject private var viewModel = SlidingWindowViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    VStack(spacing: Theme.Spacing.small) {
                        Text("Sliding Window")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        Text("Find maximum sum of fixed-size window")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    if !viewModel.isRunning {
                        VStack(spacing: Theme.Spacing.medium) {
                            TextField("Array (comma-separated)", text: $viewModel.arrayInput)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                            TextField("Window Size", text: $viewModel.windowSizeInput)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                            
                            if let error = viewModel.inputError {
                                Text(error).foregroundColor(.red).font(.caption)
                            }
                        }
                    }
                    
                    Text(viewModel.stepInfo).foregroundColor(.blue).padding()
                    Text(viewModel.finalResult).foregroundColor(.green).padding()
                    
                    HStack(spacing: Theme.Spacing.medium) {
                        Button("Start") { viewModel.start() }.buttonStyle(.borderedProminent).disabled(!viewModel.canStart)
                        Button("Next") { viewModel.nextStep() }.buttonStyle(.borderedProminent).disabled(!viewModel.canNext)
                        Button("Run Complete") { viewModel.runComplete() }.buttonStyle(.borderedProminent).disabled(!viewModel.canRunComplete)
                        Button("Reset") { viewModel.reset() }.buttonStyle(.bordered).disabled(!viewModel.canReset)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Sliding Window")
    }
}
