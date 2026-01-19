//
//  NQueensView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct NQueensVisualizationView: View {
    @StateObject private var viewModel = NQueensViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    @State private var showThreatLines = true
    
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
                        Text("N-Queens Problem")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Place N queens on a chessboard with no conflicts")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if viewModel.currentStep == 0 && !viewModel.isAnimating {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Configuration")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Board Size Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Board Size (4-8)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 4", text: $viewModel.boardSizeInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .keyboardType(.numberPad)
                                    .padding(Theme.Spacing.medium)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.boardSizeInput) { _ in
                                        viewModel.updateFromInputs()
                                    }
                            }
                            
                            // Error Message
                            if let error = viewModel.inputError {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                    Text(error)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.orange)
                                }
                                .padding(Theme.Spacing.small)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.small)
                            }
                            
                            // Info about solutions
                            if !viewModel.solutions.isEmpty {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.green)
                                    Text("\(viewModel.solutions.count) possible solution\(viewModel.solutions.count == 1 ? "" : "s") exist")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.green)
                                }
                                .padding(Theme.Spacing.small)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.small)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Statistics Panel
                    if viewModel.currentStep > 0 {
                        NQueensStatisticsPanel(
                            totalAttempts: viewModel.totalAttempts,
                            placementCount: viewModel.placementCount,
                            conflictCount: viewModel.conflictCount,
                            backtrackCount: viewModel.backtrackCount,
                            currentRow: viewModel.currentRow,
                            boardSize: viewModel.n
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Main Content Area
                    VStack(spacing: Theme.Spacing.medium) {
                        // Board Header
                        VStack(spacing: Theme.Spacing.small) {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 18, weight: .bold))
                                Text("Chessboard")
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
                                
                                // Toggle Control for Threat Lines
                                ToggleButton(
                                    icon: "line.diagonal",
                                    isOn: $showThreatLines,
                                    color: .red
                                )
                            }
                            
                            // Algorithm Progress Bar
                            if viewModel.currentStep > 0 && !viewModel.isCompleted && viewModel.n > 0 {
                                let totalExpectedSteps = viewModel.n * viewModel.n * 2 // Rough estimate
                                let progress = min(Double(viewModel.currentStep) / Double(totalExpectedSteps), 1.0)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Algorithm Progress")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Theme.Colors.secondaryText)
                                        Spacer()
                                        Text("Row \(viewModel.currentRow + 1)/\(viewModel.n)")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.purple)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.purple, Color.blue, Color.green],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * CGFloat(min(Double(viewModel.currentRow + 1) / Double(viewModel.n), 1.0)), height: 8)
                                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.currentRow)
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
                                        Text("Solution Complete!")
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
                        
                        // Chessboard with enhanced visualization
                        EnhancedChessBoardView(
                            board: viewModel.board,
                            n: viewModel.n,
                            queens: viewModel.queens,
                            tryingPosition: viewModel.tryingPosition,
                            conflictPosition: viewModel.conflictPosition,
                            backtrackingFrom: viewModel.backtrackingFrom,
                            currentRow: viewModel.currentRow,
                            currentCol: viewModel.currentCol,
                            threatLines: showThreatLines ? viewModel.threatLines : [],
                            conflictLines: viewModel.conflictLines
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    // Step Information Panel
                    if !viewModel.currentStepDescription.isEmpty {
                        NQueensStepPanel(
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
                                isInputFocused = false
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
                                isInputFocused = false
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
            .onTapGesture {
                isInputFocused = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("N-Queens")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "N-Queens Problem",
                description: "Classic backtracking algorithm for placing queens",
                icon: "crown.fill",
                complexity: Algorithm.Complexity(time: "O(N!)", space: "O(N)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Enhanced Chessboard View
struct EnhancedChessBoardView: View {
    let board: [[Int]]
    let n: Int
    let queens: [QueenPosition]
    let tryingPosition: QueenPosition?
    let conflictPosition: QueenPosition?
    let backtrackingFrom: QueenPosition?
    let currentRow: Int
    let currentCol: Int
    let threatLines: [ThreatLine]
    let conflictLines: [ThreatLine]
    
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
                
                // Chessboard
                ZStack {
                    // Base board
                    VStack(spacing: 0) {
                        ForEach(0..<n, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<n, id: \.self) { col in
                                    EnhancedChessCellView(
                                        row: row,
                                        col: col,
                                        isLight: (row + col) % 2 == 0,
                                        isCurrentRow: row == currentRow,
                                        isCurrentCol: col == currentCol,
                                        hasQueen: queens.contains { $0.row == row && $0.col == col },
                                        isTrying: tryingPosition?.row == row && tryingPosition?.col == col,
                                        isConflict: conflictPosition?.row == row && conflictPosition?.col == col,
                                        isBacktracking: backtrackingFrom?.row == row && backtrackingFrom?.col == col,
                                        isThreatened: threatLines.contains { $0.to.row == row && $0.to.col == col },
                                        queen: queens.first { $0.row == row && $0.col == col },
                                        cellSize: cellSize
                                    )
                                }
                            }
                        }
                    }
                    
                    // Threat Lines Layer - Fixed positioning
                    if !threatLines.isEmpty {
                        Canvas { context, size in
                            // Calculate the actual board dimensions
                            let boardWidth = cellSize * CGFloat(n)
                            let boardHeight = cellSize * CGFloat(n)
                            
                            for line in threatLines {
                                // Calculate center positions of cells
                                let fromX = CGFloat(line.from.col) * cellSize + cellSize / 2
                                let fromY = CGFloat(line.from.row) * cellSize + cellSize / 2
                                let toX = CGFloat(line.to.col) * cellSize + cellSize / 2
                                let toY = CGFloat(line.to.row) * cellSize + cellSize / 2
                                
                                var path = Path()
                                path.move(to: CGPoint(x: fromX, y: fromY))
                                path.addLine(to: CGPoint(x: toX, y: toY))
                                
                                context.stroke(
                                    path,
                                    with: .color(.red.opacity(0.15)),
                                    lineWidth: 1.5
                                )
                            }
                        }
                        .frame(width: cellSize * CGFloat(n), height: cellSize * CGFloat(n))
                    }
                    
                    // Conflict Lines Layer - Fixed positioning
                    if !conflictLines.isEmpty {
                        Canvas { context, size in
                            // Calculate the actual board dimensions
                            let boardWidth = cellSize * CGFloat(n)
                            let boardHeight = cellSize * CGFloat(n)
                            
                            for line in conflictLines {
                                // Calculate center positions of cells
                                let fromX = CGFloat(line.from.col) * cellSize + cellSize / 2
                                let fromY = CGFloat(line.from.row) * cellSize + cellSize / 2
                                let toX = CGFloat(line.to.col) * cellSize + cellSize / 2
                                let toY = CGFloat(line.to.row) * cellSize + cellSize / 2
                                
                                var path = Path()
                                path.move(to: CGPoint(x: fromX, y: fromY))
                                path.addLine(to: CGPoint(x: toX, y: toY))
                                
                                context.stroke(
                                    path,
                                    with: .color(.red.opacity(0.8)),
                                    lineWidth: 3
                                )
                            }
                        }
                        .frame(width: cellSize * CGFloat(n), height: cellSize * CGFloat(n))
                    }
                }
                .frame(width: cellSize * CGFloat(n), height: cellSize * CGFloat(n))
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.95))
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Enhanced Chess Cell View
struct EnhancedChessCellView: View {
    let row: Int
    let col: Int
    let isLight: Bool
    let isCurrentRow: Bool
    let isCurrentCol: Bool
    let hasQueen: Bool
    let isTrying: Bool
    let isConflict: Bool
    let isBacktracking: Bool
    let isThreatened: Bool
    let queen: QueenPosition?
    let cellSize: CGFloat
    
    var body: some View {
        ZStack {
            // Base cell color
            Rectangle()
                .fill(cellBackgroundColor)
            
            // Highlight overlays
            if isCurrentRow || isCurrentCol {
                Rectangle()
                    .fill(Color.blue.opacity(0.08))
            }
            
            if isThreatened && !hasQueen {
                Rectangle()
                    .fill(Color.red.opacity(0.08))
            }
            
            // Cell content
            if isTrying {
                // Trying animation
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: cellSize * 0.7, height: cellSize * 0.7)
                    .scaleEffect(1.2)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isTrying)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: cellSize * 0.5, weight: .bold))
                    .foregroundColor(.blue.opacity(0.5))
            } else if isConflict {
                // Conflict animation
                Circle()
                    .fill(Color.red.opacity(0.4))
                    .frame(width: cellSize * 0.8, height: cellSize * 0.8)
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: cellSize * 0.6, weight: .bold))
                    .foregroundColor(.red)
                    .modifier(ShakeEffect(animatableData: isConflict ? 1 : 0))
            } else if isBacktracking {
                // Backtracking animation
                Image(systemName: "crown.fill")
                    .font(.system(size: cellSize * 0.5, weight: .bold))
                    .foregroundColor(.orange.opacity(0.6))
                    .scaleEffect(0.8)
                    .opacity(0.5)
            } else if hasQueen {
                // Placed queen
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.yellow.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: cellSize * 0.5
                            )
                        )
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: cellSize * 0.5, weight: .bold))
                        .foregroundColor(.yellow)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            // Cell border
            Rectangle()
                .strokeBorder(Color.black.opacity(0.1), lineWidth: 0.5)
        }
        .frame(width: cellSize, height: cellSize)
    }
    
    private var cellBackgroundColor: Color {
        if isConflict {
            return Color.red.opacity(0.2)
        } else if isBacktracking {
            return Color.orange.opacity(0.2)
        } else if isTrying {
            return Color.blue.opacity(0.15)
        } else {
            return isLight ? Color(white: 0.95) : Color(white: 0.75)
        }
    }
}

// MARK: - Shake Effect
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 5 * sin(animatableData * .pi * 5), y: 0))
    }
}

// MARK: - Statistics Panel
struct NQueensStatisticsPanel: View {
    let totalAttempts: Int
    let placementCount: Int
    let conflictCount: Int
    let backtrackCount: Int
    let currentRow: Int
    let boardSize: Int
    
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
                StatBadge(label: "Placed", value: "\(placementCount)", icon: "checkmark.circle.fill", color: .green)
                StatBadge(label: "Conflicts", value: "\(conflictCount)", icon: "xmark.circle.fill", color: .red)
                StatBadge(label: "Backtracks", value: "\(backtrackCount)", icon: "arrow.uturn.backward.circle.fill", color: .orange)
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Step Information Panel
struct NQueensStepPanel: View {
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
        .background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Solution Navigation Panel
struct SolutionNavigationPanel: View {
    let currentIndex: Int
    let totalSolutions: Int
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Browse All Solutions")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            HStack(spacing: Theme.Spacing.large) {
                Button(action: onPrevious) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 24))
                        // Text("Previous")
                        //     .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                
                VStack(spacing: 4) {
                    Text("Solution")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(currentIndex + 1) / \(totalSolutions)")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                }
                
                Button(action: onNext) {
                    HStack(spacing: 8) {
                        // Text("Next")
                        //     .font(.system(size: 15, weight: .semibold))
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 24))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
        .padding(Theme.Spacing.medium)
        .background(
            LinearGradient(
                colors: [Color.yellow.opacity(0.1), Color.orange.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(Theme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .stroke(Color.yellow.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: Color.yellow.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Toggle Button
struct ToggleButton: View {
    let icon: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isOn ? .white : color)
                .frame(width: 32, height: 32)
                .background(isOn ? color : color.opacity(0.15))
                .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationStack {
        NQueensVisualizationView()
    }
}
