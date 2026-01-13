//
//  HeapSortView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI

struct HeapSortVisualizationView: View {
    @StateObject private var viewModel = HeapSortViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Theme.Colors.backgroundGradientStart,
                    Theme.Colors.backgroundGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: Theme.Spacing.large) {
                VStack(spacing: Theme.Spacing.medium) {
                    Text("Heap Sort Visualization")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        ForEach(Array(viewModel.array.enumerated()), id: \.offset) { index, value in
                            VStack {
                                Text("\(value)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(barColor(for: index))
                                    .frame(width: 50, height: CGFloat(value) * 15)
                            }
                            .animation(.spring(response: 0.3), value: viewModel.array)
                        }
                    }
                    .frame(height: 250)
                    .padding()
                }
                
                VStack(spacing: Theme.Spacing.medium) {
                    HStack(spacing: Theme.Spacing.medium) {
                        Button(action: {
                            if viewModel.isAnimating {
                                viewModel.stopAnimation()
                            } else {
                                viewModel.startAnimation()
                            }
                        }) {
                            HStack {
                                Image(systemName: viewModel.isAnimating ? "pause.fill" : "play.fill")
                                Text(viewModel.isAnimating ? "Pause" : "Start")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            viewModel.stopAnimation()
                            viewModel.resetArray()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Reset")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Speed: \(String(format: "%.1fx", viewModel.speed))")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Slider(value: $viewModel.speed, in: 0.5...3.0, step: 0.5)
                            .tint(.blue)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Heap Sort")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func barColor(for index: Int) -> Color {
        if viewModel.sortedIndices.contains(index) {
            return .green
        } else if viewModel.heapifyingIndices.contains(index) {
            return .orange
        } else {
            return .blue
        }
    }
}

#Preview {
    NavigationStack {
        HeapSortVisualizationView()
    }
}
