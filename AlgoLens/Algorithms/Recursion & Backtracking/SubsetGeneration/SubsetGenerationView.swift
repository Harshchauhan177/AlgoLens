//
//  SubsetGenerationView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct SubsetGenerationView: View {
    @StateObject private var viewModel = SubsetGenerationViewModel()
    
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
                
                Text("Total Subsets: 2^\(viewModel.inputArray.count) = \(viewModel.subsets.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Divider()
            
            // Current Subset
            if !viewModel.subsets.isEmpty {
                VStack(spacing: 10) {
                    Text("Subset \(viewModel.currentSubsetIndex + 1) of \(viewModel.subsets.count)")
                        .font(.headline)
                    
                    if viewModel.subsets[viewModel.currentSubsetIndex].isEmpty {
                        Text("∅ (Empty Set)")
                            .font(.title)
                            .foregroundColor(.gray)
                            .frame(height: 60)
                    } else {
                        HStack(spacing: 10) {
                            ForEach(viewModel.subsets[viewModel.currentSubsetIndex], id: \.self) { num in
                                Text("\(num)")
                                    .font(.title)
                                    .frame(width: 60, height: 60)
                                    .background(Color.green.opacity(0.3))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
            }
            
            // All Subsets List
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(0..<viewModel.subsets.count, id: \.self) { index in
                        Text(viewModel.subsets[index].isEmpty ? "∅" : "[\(viewModel.subsets[index].map { "\($0)" }.joined(separator: ","))]")
                            .font(.caption)
                            .padding(8)
                            .background(index == viewModel.currentSubsetIndex ? Color.green.opacity(0.3) : Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 200)
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.previousSubset) {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.subsets.isEmpty)
                
                Button(action: viewModel.nextSubset) {
                    Image(systemName: "chevron.right")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.subsets.isEmpty)
                
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
    SubsetGenerationView()
}
