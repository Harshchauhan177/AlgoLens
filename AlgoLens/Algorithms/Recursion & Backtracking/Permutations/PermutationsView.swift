//
//  PermutationsView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct PermutationsView: View {
    @StateObject private var viewModel = PermutationsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Input Array Display
            VStack(spacing: 10) {
                Text("Input Array")
                    .font(.headline)
                
                HStack(spacing: 10) {
                    ForEach(viewModel.inputArray, id: \.self) { num in
                        Text("\(num)")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            Divider()
            
            // Current Permutation
            if !viewModel.permutations.isEmpty {
                VStack(spacing: 10) {
                    Text("Permutation \(viewModel.currentPermutationIndex + 1) of \(viewModel.permutations.count)")
                        .font(.headline)
                    
                    HStack(spacing: 10) {
                        ForEach(viewModel.permutations[viewModel.currentPermutationIndex], id: \.self) { num in
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
            
            // All Permutations List
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(0..<viewModel.permutations.count, id: \.self) { index in
                        Text(viewModel.permutations[index].map { "\($0)" }.joined(separator: ", "))
                            .font(.caption)
                            .padding(8)
                            .background(index == viewModel.currentPermutationIndex ? Color.green.opacity(0.3) : Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 200)
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.previousPermutation) {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.permutations.isEmpty)
                
                Button(action: viewModel.nextPermutation) {
                    Image(systemName: "chevron.right")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.permutations.isEmpty)
                
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
    PermutationsView()
}
