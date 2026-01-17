//
//  NQueensView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct NQueensView: View {
    @StateObject private var viewModel = NQueensViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Board Visualization
            ChessBoardView(board: viewModel.board)
                .frame(width: 320, height: 320)
                .padding()
            
            // Solution Counter
            if !viewModel.solutions.isEmpty {
                Text("Solution \(viewModel.currentSolutionIndex + 1) of \(viewModel.solutions.count)")
                    .font(.headline)
            }
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.showPreviousSolution) {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.solutions.isEmpty)
                
                Button(action: viewModel.showNextSolution) {
                    Image(systemName: "chevron.right")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.solutions.isEmpty)
                
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

struct ChessBoardView: View {
    let board: [[Int]]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<board.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<board.count, id: \.self) { col in
                        ChessCellView(
                            isQueen: board[row][col] == 1,
                            isLight: (row + col) % 2 == 0
                        )
                    }
                }
            }
        }
    }
}

struct ChessCellView: View {
    let isQueen: Bool
    let isLight: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isLight ? Color.white : Color.gray.opacity(0.5))
            
            if isQueen {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .border(Color.black.opacity(0.1))
    }
}

#Preview {
    NQueensView()
}
