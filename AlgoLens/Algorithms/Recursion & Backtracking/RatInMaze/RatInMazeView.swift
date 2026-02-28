//
//  RatInMazeView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct RatInMazeVisualizationView: View {
    @StateObject private var viewModel = RatInMazeViewModel()
    @State private var showQuiz = false
    @State private var showPath = true
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Theme.Colors.backgroundGradientStart,
                    Theme.Colors.backgroundGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // Header Section
                    VStack(spacing: Theme.Spacing.small) {
                        Text("Rat in a Maze")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Find a path from start to destination using backtracking")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Statistics Panel
                    if viewModel.currentStep > 0 {
                        RatInMazeStatisticsPanel(
                            totalAttempts: viewModel.totalAttempts,
                            movementCount: viewModel.movementCount,
                            blockedCount: viewModel.blockedCount,
                            backtrackCount: viewModel.backtrackCount,
                            pathLength: viewModel.pathPositions.count
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Main Content Area
                    VStack(spacing: Theme.Spacing.medium) {
                        // Maze Header
                        VStack(spacing: Theme.Spacing.small) {
                            HStack {
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18, weight: .bold))
                                Text("Maze Grid")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Spacer()
                                
                                // Move Counter Badge
                                if viewModel.currentStep > 0 {
                                    HStack(spacing: 6) {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text("Step \(viewModel.currentStep)")
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.purple, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                                
                                // Toggle Control for Path
                                ToggleButton(
                                    icon: "arrow.triangle.turn.up.right.diamond",
                                    isOn: $showPath,
                                    color: .green
                                )
                            }
                            
                            // Algorithm Progress
                            if viewModel.currentStep > 0 && !viewModel.isCompleted {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Algorithm Progress")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Theme.Colors.secondaryText)
                                        Spacer()
                                        Text("Position: (\(viewModel.currentPosition.row), \(viewModel.currentPosition.col))")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.purple)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                            
                                            let maxSteps = viewModel.n * viewModel.n * 2
                                            let progress = min(Double(viewModel.currentStep) / Double(maxSteps), 1.0)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.blue, Color.green, Color.purple],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.currentStep)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                                .padding(.top, 4)
                            }
                            
                            // Completion Progress Bar
                            if viewModel.isCompleted {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.green)
                                        Text("Destination Reached!")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.green)
                                        Spacer()
                                        Text("100%")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.green)
                                    }
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.green, Color.green.opacity(0.7)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(height: 8)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        // Maze Grid with enhanced visualization
                        EnhancedMazeGridView(
                            maze: viewModel.maze,
                            path: showPath ? viewModel.path : Array(repeating: Array(repeating: 0, count: viewModel.n), count: viewModel.n),
                            n: viewModel.n,
                            currentPosition: viewModel.currentPosition,
                            tryingPosition: viewModel.tryingPosition,
                            blockedPosition: viewModel.blockedPosition,
                            backtrackingFrom: viewModel.backtrackingFrom,
                            pathPositions: showPath ? viewModel.pathPositions : []
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    // Step Information Panel
                    if !viewModel.currentStepDescription.isEmpty {
                        RatInMazeStepPanel(
                            currentStep: viewModel.currentStep,
                            stepDescription: viewModel.currentStepDescription,
                            isCompleted: viewModel.isCompleted
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    
                    // Solution Navigation (when completed)
                    if viewModel.isCompleted && viewModel.solutions.count > 1 {
                        SolutionNavigationPanel(
                            currentIndex: viewModel.currentSolutionIndex,
                            totalSolutions: viewModel.solutions.count,
                            onPrevious: viewModel.showPreviousSolution,
                            onNext: viewModel.showNextSolution
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Control Buttons
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(
                                title: "Start",
                                icon: "play.fill",
                                color: .green,
                                isEnabled: viewModel.canStart
                            ) {
                                viewModel.start()
                            }
                            
                            EnhancedControlButton(
                                title: "Next Step",
                                icon: "forward.fill",
                                color: .blue,
                                isEnabled: viewModel.canNext
                            ) {
                                viewModel.nextStep()
                            }
                        }
                        
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(
                                title: "Run Complete",
                                icon: "forward.end.fill",
                                color: .purple,
                                isEnabled: viewModel.canRunComplete
                            ) {
                                viewModel.runComplete()
                            }
                            
                            EnhancedControlButton(
                                title: "Reset",
                                icon: "arrow.counterclockwise",
                                color: .red,
                                isEnabled: viewModel.canReset
                            ) {
                                viewModel.reset()
                            }
                        }
                        
                        // Take Quiz Button
                        if viewModel.isCompleted {
                            Button(action: {
                                showQuiz = true
                            }) {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Take Quiz")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.Spacing.medium + 2)
                                .background(
                                    LinearGradient(
                                        colors: [Color.pink, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(Theme.CornerRadius.large)
                                .shadow(color: Color.pink.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.bottom, Theme.Spacing.large)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Rat in Maze")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Rat in a Maze",
                description: "Classic backtracking algorithm for pathfinding",
                icon: "figure.walk",
                complexity: Algorithm.Complexity(time: "O(2^(N²))", space: "O(N²)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Enhanced Maze Grid View
struct EnhancedMazeGridView: View {
    let maze: [[Int]]
    let path: [[Int]]
    let n: Int
    let currentPosition: RatPosition
    let tryingPosition: RatPosition?
    let blockedPosition: RatPosition?
    let backtrackingFrom: RatPosition?
    let pathPositions: [RatPosition]
    
    private var cellSize: CGFloat {
        let maxSize: CGFloat = 45
        let minSize: CGFloat = 30
        let calculatedSize = 320 / CGFloat(n)
        return min(maxSize, max(minSize, calculatedSize))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Column indices
            HStack(spacing: 0) {
                Color.clear.frame(width: 24, height: 20)
                ForEach(0..<n, id: \.self) { col in
                    Text("\(col)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                        .frame(width: cellSize, height: 20)
                }
            }
            
            HStack(spacing: 0) {
                // Row indices
                VStack(spacing: 0) {
                    ForEach(0..<n, id: \.self) { row in
                        Text("\(row)")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.gray)
                            .frame(width: 24, height: cellSize)
                    }
                }
                
                // Maze grid
                VStack(spacing: 0) {
                    ForEach(0..<n, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<n, id: \.self) { col in
                                EnhancedMazeCellView(
                                    row: row,
                                    col: col,
                                    isOpen: maze[row][col] == 1,
                                    isPath: path[row][col] == 1,
                                    isStart: row == 0 && col == 0,
                                    isEnd: row == n - 1 && col == n - 1,
                                    isCurrent: currentPosition.row == row && currentPosition.col == col,
                                    isTrying: tryingPosition?.row == row && tryingPosition?.col == col,
                                    isBlocked: blockedPosition?.row == row && blockedPosition?.col == col,
                                    isBacktracking: backtrackingFrom?.row == row && backtrackingFrom?.col == col,
                                    cellSize: cellSize
                                )
                            }
                        }
                    }
                }
                .frame(width: cellSize * CGFloat(n), height: cellSize * CGFloat(n))
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.cardSurfaceStrong)
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Enhanced Maze Cell View
struct EnhancedMazeCellView: View {
    let row: Int
    let col: Int
    let isOpen: Bool
    let isPath: Bool
    let isStart: Bool
    let isEnd: Bool
    let isCurrent: Bool
    let isTrying: Bool
    let isBlocked: Bool
    let isBacktracking: Bool
    let cellSize: CGFloat
    
    var body: some View {
        ZStack {
            // Base cell color
            Rectangle()
                .fill(cellBackgroundColor)
            
            // Path overlay
            if isPath && !isStart && !isEnd {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
            }
            
            // Cell content
            if isTrying {
                // Trying animation
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: cellSize * 0.7, height: cellSize * 0.7)
                    .scaleEffect(1.2)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isTrying)
                
                Image(systemName: "figure.walk")
                    .font(.system(size: cellSize * 0.5, weight: .bold))
                    .foregroundColor(.blue.opacity(0.5))
            } else if isBlocked {
                // Blocked animation
                Circle()
                    .fill(Color.red.opacity(0.4))
                    .frame(width: cellSize * 0.8, height: cellSize * 0.8)
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: cellSize * 0.6, weight: .bold))
                    .foregroundColor(.red)
                    .modifier(ShakeEffect(animatableData: isBlocked ? 1 : 0))
            } else if isBacktracking {
                // Backtracking animation
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: cellSize * 0.5, weight: .bold))
                    .foregroundColor(.orange)
                    .scaleEffect(0.8)
                    .opacity(0.7)
            } else if isStart {
                // Start position
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.blue.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: cellSize * 0.5
                            )
                        )
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                    
                    Image(systemName: "figure.walk")
                        .font(.system(size: cellSize * 0.5, weight: .bold))
                        .foregroundColor(.blue)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
            } else if isEnd {
                // End position
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.red.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: cellSize * 0.5
                            )
                        )
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                    
                    Image(systemName: "flag.fill")
                        .font(.system(size: cellSize * 0.5, weight: .bold))
                        .foregroundColor(.red)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
            } else if isCurrent && !isStart && !isEnd {
                // Current position
                Image(systemName: "figure.walk")
                    .font(.system(size: cellSize * 0.5, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            // Cell border
            Rectangle()
                .strokeBorder(Color.black.opacity(0.2), lineWidth: 0.5)
        }
        .frame(width: cellSize, height: cellSize)
    }
    
    private var cellBackgroundColor: Color {
        if isBlocked {
            return Color.red.opacity(0.2)
        } else if isBacktracking {
            return Color.orange.opacity(0.2)
        } else if isTrying {
            return Color.blue.opacity(0.15)
        } else if !isOpen {
            return Color(.label).opacity(0.8)
        } else {
            return Color(.systemBackground)
        }
    }
}

// MARK: - Statistics Panel
struct RatInMazeStatisticsPanel: View {
    let totalAttempts: Int
    let movementCount: Int
    let blockedCount: Int
    let backtrackCount: Int
    let pathLength: Int
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.purple)
                Text("Algorithm Statistics")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            HStack(spacing: Theme.Spacing.medium) {
                StatBadge(label: "Attempts", value: "\(totalAttempts)", icon: "number", color: .blue)
                StatBadge(label: "Moves", value: "\(movementCount)", icon: "arrow.right.circle.fill", color: .green)
                StatBadge(label: "Blocked", value: "\(blockedCount)", icon: "xmark.circle.fill", color: .red)
                StatBadge(label: "Backtracks", value: "\(backtrackCount)", icon: "arrow.uturn.backward.circle.fill", color: .orange)
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.cardSurface)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Step Information Panel
struct RatInMazeStepPanel: View {
    let currentStep: Int
    let stepDescription: String
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack {
                Image(systemName: isCompleted ? "checkmark.seal.fill" : "info.circle.fill")
                    .foregroundColor(isCompleted ? .green : .blue)
                Text("Current Action")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
                
                Text("Step \(currentStep)")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.purple)
                    .cornerRadius(12)
            }
            
            Text(stepDescription)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.Spacing.medium)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(Theme.CornerRadius.small)
        }
        .padding(Theme.Spacing.medium)
        .background(Theme.Colors.cardSurface)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        RatInMazeVisualizationView()
    }
}
