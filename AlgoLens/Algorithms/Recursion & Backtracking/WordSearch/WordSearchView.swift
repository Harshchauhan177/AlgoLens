//
//  WordSearchView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct WordSearchVisualizationView: View {
    @StateObject private var viewModel = WordSearchViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    
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
                        Text("Word Search")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Find if a word exists in a 2D grid using backtracking")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if !viewModel.isAnimating {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Word Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Word to Search")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., ABCCED", text: $viewModel.wordInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .padding(Theme.Spacing.medium)
                                    .background(Theme.Colors.cardSurface)
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.wordInput) { _ in
                                        viewModel.updateFromInputs()
                                    }
                            }
                            
                            // Board Info
                            HStack {
                                Image(systemName: "square.grid.3x3")
                                    .foregroundColor(.blue)
                                Text("Board: 3x4 grid with letters")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                            }
                            .padding(Theme.Spacing.small)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.05))
                            .cornerRadius(Theme.CornerRadius.small)
                            
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
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Grid Visualization Area
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack {
                            Text("Board Grid")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            Spacer()
                            
                            if viewModel.isAnimating || viewModel.isCompleted {
                                Text("Target: \(viewModel.word)")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.purple)
                                    .padding(.horizontal, Theme.Spacing.medium)
                                    .padding(.vertical, Theme.Spacing.small)
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(Theme.CornerRadius.small)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        WordSearchGridView(
                            board: viewModel.board,
                            path: viewModel.path,
                            currentCell: viewModel.currentCell,
                            viewModel: viewModel
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .padding(.vertical, Theme.Spacing.small)
                    }
                    
                    // Step Information Panel
                    if viewModel.isAnimating || viewModel.isCompleted {
                        WordSearchStepInformationPanel(
                            currentStep: viewModel.currentStep,
                            currentDepth: viewModel.currentDepth,
                            wordLength: viewModel.word.count,
                            totalBacktracks: viewModel.totalBacktracks,
                            stepDescription: viewModel.stepDescription,
                            finalResult: viewModel.finalResult,
                            isCompleted: viewModel.isCompleted,
                            found: viewModel.found
                        )
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .move(edge: .top)))
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
                                icon: "play.circle.fill",
                                color: .purple,
                                isEnabled: viewModel.canRunComplete
                            ) {
                                isInputFocused = false
                                viewModel.runComplete()
                            }
                            
                            EnhancedControlButton(
                                title: "Reset",
                                icon: "arrow.counterclockwise",
                                color: .orange,
                                isEnabled: viewModel.canReset
                            ) {
                                viewModel.reset()
                            }
                        }
                        
                        // Take Quiz Button (shown when completed)
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
        .navigationTitle("Word Search")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Word Search",
                description: "Find if a word exists in a 2D grid using backtracking",
                icon: "square.grid.3x3.fill",
                complexity: Algorithm.Complexity(time: "O(m×n×4^L)", space: "O(L)"),
                category: AlgorithmCategory.allCategories[3]
            ))
        }
    }
}

// MARK: - Word Search Step Information Panel
struct WordSearchStepInformationPanel: View {
    let currentStep: Int
    let currentDepth: Int
    let wordLength: Int
    let totalBacktracks: Int
    let stepDescription: String
    let finalResult: String
    let isCompleted: Bool
    let found: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Step Information")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            
            VStack(spacing: Theme.Spacing.small) {
                // Current State
                if !isCompleted {
                    InfoRow(label: "Current Depth", value: "\(currentDepth)/\(wordLength)", icon: "arrow.down.circle.fill", color: .purple)
                    InfoRow(label: "Steps Taken", value: "\(currentStep)", icon: "number.circle.fill", color: .blue)
                    InfoRow(label: "Backtracks", value: "\(totalBacktracks)", icon: "arrow.uturn.backward.circle.fill", color: .orange)
                    
                    if !stepDescription.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: getStepIcon())
                                .foregroundColor(getStepColor())
                            Text(stepDescription)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                            Spacer()
                        }
                    }
                }
                
                // Final Result
                if !finalResult.isEmpty {
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack {
                        Image(systemName: found ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(found ? .green : .red)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(found ? .green : .red)
                        
                        Spacer()
                    }
                }
            }
            .padding(Theme.Spacing.medium)
            .background(Theme.Colors.cardSurface)
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
    private func getStepIcon() -> String {
        if stepDescription.contains("✓") && stepDescription.contains("found!") {
            return "star.fill"
        } else if stepDescription.contains("✓") {
            return "checkmark.circle.fill"
        } else if stepDescription.contains("✗") {
            return "xmark.circle.fill"
        } else if stepDescription.contains("↩️") {
            return "arrow.uturn.backward.circle.fill"
        } else if stepDescription.contains("⚠️") {
            return "exclamationmark.triangle.fill"
        } else {
            return "magnifyingglass.circle.fill"
        }
    }
    
    private func getStepColor() -> Color {
        if stepDescription.contains("✓") && stepDescription.contains("found!") {
            return .green
        } else if stepDescription.contains("✓") {
            return .green
        } else if stepDescription.contains("✗") {
            return .red
        } else if stepDescription.contains("↩️") {
            return .orange
        } else if stepDescription.contains("⚠️") {
            return .yellow
        } else {
            return .blue
        }
    }
}

// MARK: - Word Search Grid View
struct WordSearchGridView: View {
    let board: [[Character]]
    let path: [(Int, Int)]
    let currentCell: (Int, Int)?
    let viewModel: WordSearchViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<board.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<board[row].count, id: \.self) { col in
                        WordSearchCellView(
                            character: board[row][col],
                            row: row,
                            col: col,
                            state: viewModel.cellState(row: row, col: col),
                            pathIndex: path.firstIndex(where: { $0.0 == row && $0.1 == col })
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Word Search Cell View
struct WordSearchCellView: View {
    let character: Character
    let row: Int
    let col: Int
    let state: WordSearchViewModel.CellState
    let pathIndex: Int?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(width: 70, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
            
            VStack(spacing: 4) {
                Text(String(character))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                
                Text("(\(row),\(col))")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(coordinateColor)
                
                if let index = pathIndex {
                    Text("Step \(index + 1)")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .cornerRadius(4)
                }
            }
        }
        .scaleEffect(state == .current ? 1.08 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: state)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .unchecked:
            return Theme.Colors.cardSurfaceStrong
        case .active:
            return Color.blue.opacity(0.08)
        case .visited:
            return Color.gray.opacity(0.12)
        case .current:
            return Color.orange.opacity(0.2)
        case .inPath:
            return Color.green.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch state {
        case .unchecked:
            return Theme.Colors.primaryText
        case .active:
            return .blue
        case .visited:
            return .gray
        case .current:
            return .orange
        case .inPath:
            return .green
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .unchecked:
            return Color.gray.opacity(0.25)
        case .active:
            return .blue.opacity(0.4)
        case .visited:
            return .gray.opacity(0.5)
        case .current:
            return .orange
        case .inPath:
            return .green
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .current:
            return 3.5
        case .inPath:
            return 3
        case .visited:
            return 2
        case .active:
            return 2
        default:
            return 1.5
        }
    }
    
    private var shadowColor: Color {
        switch state {
        case .current:
            return Color.orange.opacity(0.5)
        case .inPath:
            return Color.green.opacity(0.4)
        case .visited:
            return Color.gray.opacity(0.3)
        case .active:
            return Color.blue.opacity(0.3)
        default:
            return Color.black.opacity(0.06)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch state {
        case .current:
            return 15
        case .inPath:
            return 12
        case .visited:
            return 8
        case .active:
            return 10
        default:
            return 6
        }
    }
    
    private var coordinateColor: Color {
        switch state {
        case .current:
            return .orange
        case .inPath:
            return .green
        case .visited:
            return .gray
        case .active:
            return .blue
        default:
            return Theme.Colors.secondaryText.opacity(0.6)
        }
    }
}

#Preview {
    NavigationStack {
        WordSearchVisualizationView()
    }
}
