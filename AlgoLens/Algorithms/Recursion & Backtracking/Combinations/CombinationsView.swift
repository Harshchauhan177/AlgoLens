//
//  CombinationsView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct CombinationsView: View {
    @StateObject private var viewModel = CombinationsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Parameters
            VStack(spacing: 15) {
                Text("C(\(viewModel.n), \(viewModel.k))")
                    .font(.title2.bold())
                
                HStack(spacing: 30) {
                    VStack {
                        Text("n = \(viewModel.n)")
                            .font(.headline)
                        Stepper("", value: $viewModel.n, in: 1...10, onEditingChanged: { _ in
                            viewModel.updateParameters()
                        })
                        .labelsHidden()
                    }
                    
                    VStack {
                        Text("k = \(viewModel.k)")
                            .font(.headline)
                        Stepper("", value: $viewModel.k, in: 1...viewModel.n, onEditingChanged: { _ in
                            viewModel.updateParameters()
                        })
                        .labelsHidden()
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            Divider()
            
            // Current Combination
            if !viewModel.combinations.isEmpty {
                VStack(spacing: 10) {
                    Text("Combination \(viewModel.currentCombinationIndex + 1) of \(viewModel.combinations.count)")
                        .font(.headline)
                    
                    HStack(spacing: 10) {
                        ForEach(viewModel.combinations[viewModel.currentCombinationIndex], id: \.self) { num in
                            Text("\(num)")
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            
            // All Combinations List
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(0..<viewModel.combinations.count, id: \.self) { index in
                        Text("[\(viewModel.combinations[index].map { "\($0)" }.joined(separator: ","))]")
                            .font(.caption)
                            .padding(8)
                            .background(index == viewModel.currentCombinationIndex ? Color.green.opacity(0.3) : Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 200)
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.previousCombination) {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.combinations.isEmpty)
                
                Button(action: viewModel.nextCombination) {
                    Image(systemName: "chevron.right")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.combinations.isEmpty)
                
                Button(action: viewModel.reset) {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(width: 44, height: 44)
                }
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CombinationsView()
}
