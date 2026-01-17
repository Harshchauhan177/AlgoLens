//
//  WordSearchView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct WordSearchView: View {
    @StateObject private var viewModel = WordSearchViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Word to Search
            VStack(spacing: 10) {
                Text("Search for: \(viewModel.word)")
                    .font(.title2.bold())
                
                TextField("Word", text: $viewModel.word)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 200)
            }
            .padding()
            
            // Grid Visualization
            WordSearchGridView(
                board: viewModel.board,
                path: viewModel.path
            )
            .frame(width: 320, height: 240)
            .padding()
            
            // Result
            if viewModel.found {
                Text("✓ Word Found!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            } else if !viewModel.path.isEmpty || viewModel.currentStep > 0 {
                Text("✗ Word Not Found")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.search) {
                    Text("Search")
                        .frame(width: 100)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: viewModel.reset) {
                    Text("Reset")
                        .frame(width: 100)
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct WordSearchGridView: View {
    let board: [[Character]]
    let path: [(Int, Int)]
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<board.count, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<board[row].count, id: \.self) { col in
                        WordSearchCellView(
                            character: board[row][col],
                            isInPath: path.contains(where: { $0.0 == row && $0.1 == col }),
                            pathIndex: path.firstIndex(where: { $0.0 == row && $0.1 == col })
                        )
                    }
                }
            }
        }
    }
}

struct WordSearchCellView: View {
    let character: Character
    let isInPath: Bool
    let pathIndex: Int?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isInPath ? Color.green.opacity(0.3) : Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
            
            VStack(spacing: 2) {
                Text(String(character))
                    .font(.title2.bold())
                    .foregroundColor(isInPath ? .green : .primary)
                
                if let index = pathIndex {
                    Text("\(index + 1)")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isInPath ? Color.green : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    WordSearchView()
}
