//
//  SudokuSolverView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct SudokuSolverView: View {
    @StateObject private var viewModel = SudokuSolverViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Sudoku Grid
            SudokuGridView(board: viewModel.board)
                .frame(width: 360, height: 360)
                .padding()
            
            // Status
            if viewModel.isSolved {
                Text("Sudoku Solved!")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.solve) {
                    Text("Solve")
                        .frame(width: 100)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSolved)
                
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

struct SudokuGridView: View {
    let board: [[Int]]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { col in
                        SudokuCellView(
                            value: board[row][col],
                            row: row,
                            col: col
                        )
                    }
                }
            }
        }
        .border(Color.black, width: 2)
    }
}

struct SudokuCellView: View {
    let value: Int
    let row: Int
    let col: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .border(Color.gray.opacity(0.3))
                .border(
                    Color.black,
                    width: (col % 3 == 0 ? 2 : 0) +
                           (row % 3 == 0 ? 2 : 0)
                )
            
            if value != 0 {
                Text("\(value)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(value != 0 ? .blue : .black)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    SudokuSolverView()
}
