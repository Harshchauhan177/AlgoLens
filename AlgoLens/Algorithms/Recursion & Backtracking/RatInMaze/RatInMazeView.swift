//
//  RatInMazeView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct RatInMazeView: View {
    @StateObject private var viewModel = RatInMazeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Maze Visualization
            MazeGridView(maze: viewModel.maze, path: viewModel.path)
                .frame(width: 320, height: 320)
                .padding()
            
            // Solution Info
            if !viewModel.solutions.isEmpty {
                VStack(spacing: 10) {
                    Text("Solution \(viewModel.currentSolutionIndex + 1) of \(viewModel.solutions.count)")
                        .font(.headline)
                    
                    Text("Path: \(viewModel.solutions[viewModel.currentSolutionIndex])")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            } else {
                Text("No solution found")
                    .foregroundColor(.red)
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

struct MazeGridView: View {
    let maze: [[Int]]
    let path: [[Int]]
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<maze.count, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<maze[row].count, id: \.self) { col in
                        MazeCellView(
                            isOpen: maze[row][col] == 1,
                            isPath: path[row][col] == 1,
                            isStart: row == 0 && col == 0,
                            isEnd: row == maze.count - 1 && col == maze[row].count - 1
                        )
                    }
                }
            }
        }
    }
}

struct MazeCellView: View {
    let isOpen: Bool
    let isPath: Bool
    let isStart: Bool
    let isEnd: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isOpen ? Color.white : Color.black)
            
            if isPath {
                Rectangle()
                    .fill(Color.green.opacity(0.5))
            }
            
            if isStart {
                Image(systemName: "figure.walk")
                    .foregroundColor(.blue)
            }
            
            if isEnd {
                Image(systemName: "flag.fill")
                    .foregroundColor(.red)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .border(Color.gray.opacity(0.3))
    }
}

#Preview {
    RatInMazeView()
}
