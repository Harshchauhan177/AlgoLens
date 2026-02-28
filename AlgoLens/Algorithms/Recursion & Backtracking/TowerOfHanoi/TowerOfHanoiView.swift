//
//  TowerOfHanoiView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct TowerOfHanoiVisualizationView: View {
    @StateObject private var viewModel = TowerOfHanoiViewModel()
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
                        Text("Tower of Hanoi")
                            .font(Theme.Fonts.title)
                            .foregroundColor(Theme.Colors.primaryText)
                        
                        Text("Move all disks from source to destination tower")
                            .font(Theme.Fonts.subtitle)
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                    }
                    .padding(.top, Theme.Spacing.large)
                    
                    // Dynamic Input Section
                    if viewModel.currentStep == 0 && !viewModel.isAnimating {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Number of Disks Input
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Number of Disks (1-8)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.Colors.secondaryText)
                                
                                TextField("e.g., 3", text: $viewModel.diskInput)
                                    .font(.system(size: 15, design: .monospaced))
                                    .keyboardType(.numberPad)
                                    .padding(Theme.Spacing.medium)
                                    .background(Theme.Colors.cardSurface)
                                    .cornerRadius(Theme.CornerRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($isInputFocused)
                                    .onChange(of: viewModel.diskInput) { _ in
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
                            
                            // Info about complexity
                            HStack(spacing: Theme.Spacing.small) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Total moves required: \(viewModel.moves.count)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                            .padding(Theme.Spacing.small)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(Theme.CornerRadius.small)
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Towers Visualization Area
                    VStack(spacing: Theme.Spacing.medium) {
                        // Header with progress indicator
                        VStack(spacing: Theme.Spacing.small) {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Towers Visualization")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.Colors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.currentStep > 0 {
                                    HStack(spacing: 6) {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text("Move \(viewModel.currentStep)/\(viewModel.moves.count)")
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient(
                                            colors: [Color.blue, Color.purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            
                            // Progress indicator
                            if viewModel.currentStep > 0 && !viewModel.isCompleted {
                                let progress = Double(viewModel.currentStep) / Double(max(1, viewModel.moves.count))
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Algorithm Progress")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Theme.Colors.secondaryText)
                                        Spacer()
                                        Text("\(Int(progress * 100))%")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.blue, Color.green],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        // Towers - Improved Layout
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(0..<3) { towerIndex in
                                        ImprovedTowerView(
                                            disks: viewModel.towers[towerIndex],
                                            towerName: viewModel.getTowerName(tower: towerIndex),
                                            towerColor: viewModel.getTowerColor(tower: towerIndex),
                                            maxDisks: viewModel.numberOfDisks,
                                            towerIndex: towerIndex,
                                            isActiveTower: viewModel.activeTowerIndex == towerIndex,
                                            isFromTower: viewModel.fromTowerIndex == towerIndex,
                                            isToTower: viewModel.toTowerIndex == towerIndex
                                        )
                                        .id("tower_\(towerIndex)")
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.large)
                                .padding(.vertical, Theme.Spacing.medium)
                            }
                            .onChange(of: viewModel.activeTowerIndex) { newIndex in
                                if newIndex >= 0 && newIndex < 3 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo("tower_\(newIndex)", anchor: .center)
                                    }
                                }
                            }
                            .onChange(of: viewModel.toTowerIndex) { newIndex in
                                // Also scroll when destination tower changes
                                if newIndex >= 0 && newIndex < 3 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo("tower_\(newIndex)", anchor: .center)
                                    }
                                }
                            }
                            .onAppear {
                                // Scroll to first tower on appear
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    proxy.scrollTo("tower_0", anchor: .leading)
                                }
                            }
                        }
                    }
                    
                    // Step Information Panel
                    if viewModel.currentStep > 0 || viewModel.isCompleted {
                        TowerOfHanoiStepPanel(
                            currentStep: viewModel.currentStep,
                            totalMoves: viewModel.moves.count,
                            currentMove: viewModel.currentMoveDescription,
                            finalResult: viewModel.finalResult,
                            isCompleted: viewModel.isCompleted
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
        .navigationTitle("Tower of Hanoi")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Tower of Hanoi",
                description: "Classic recursive disk moving puzzle",
                icon: "building.columns.fill",
                complexity: Algorithm.Complexity(time: "O(2^n)", space: "O(n)"),
                category: AlgorithmCategory.allCategories[2]
            ))
        }
    }
}

// MARK: - Step Information Panel
struct TowerOfHanoiStepPanel: View {
    let currentStep: Int
    let totalMoves: Int
    let currentMove: String
    let finalResult: String
    let isCompleted: Bool
    
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
                    HanoiInfoRow(
                        label: "Current Move",
                        value: "\(currentStep)/\(totalMoves)",
                        icon: "arrow.right.circle.fill",
                        color: .blue
                    )
                    
                    HanoiInfoRow(
                        label: "Remaining Moves",
                        value: "\(totalMoves - currentStep)",
                        icon: "clock.fill",
                        color: .orange
                    )
                    
                    if !currentMove.isEmpty {
                        Divider()
                            .padding(.vertical, 4)
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                            Text(currentMove)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.Colors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                    }
                }
                
                // Final Result
                if !finalResult.isEmpty {
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                        
                        Text(finalResult)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.green)
                            .fixedSize(horizontal: false, vertical: true)
                        
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
}

// MARK: - Hanoi Info Row
struct HanoiInfoRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.Colors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// MARK: - Tower Border Overlay
struct TowerBorderOverlay: View {
    let cornerRadius: CGFloat
    let strokeColor: Color
    let lineWidth: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(strokeColor, lineWidth: lineWidth)
    }
}

// MARK: - Tower Glow Overlay
struct TowerGlowOverlay: View {
    let cornerRadius: CGFloat
    let glowColor: Color
    let shouldShow: Bool
    
    var body: some View {
        Group {
            if shouldShow {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(glowColor.opacity(0.5), lineWidth: 8)
                    .blur(radius: 8)
            }
        }
    }
}

// MARK: - Improved Tower View
struct ImprovedTowerView: View {
    let disks: [Int]
    let towerName: String
    let towerColor: Color
    let maxDisks: Int
    let towerIndex: Int
    let isActiveTower: Bool
    let isFromTower: Bool
    let isToTower: Bool
    
    private var towerLetter: String {
        switch towerIndex {
        case 0: return "A"
        case 1: return "B"
        case 2: return "C"
        default: return ""
        }
    }
    
    private var borderStrokeLineWidth: CGFloat {
        (isActiveTower || isToTower) ? 4 : 2
    }
    
    private var borderStrokeColor: Color {
        (isActiveTower || isToTower) ? towerColor : towerColor.opacity(0.3)
    }
    
    private var isHighlighted: Bool {
        isActiveTower || isToTower
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Tower Name with Icon
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [towerColor.opacity(0.2), towerColor.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Text(towerLetter)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(towerColor)
                }
                
                Text(towerName.split(separator: " ").dropFirst().joined(separator: " "))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(towerColor.opacity(0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            // Tower Structure with better proportions
            ZStack(alignment: .bottom) {
                // Background platform shadow
                Ellipse()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 140, height: 20)
                    .offset(y: 12)
                    .blur(radius: 6)
                
                // Rod with gradient
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            colors: [
                                towerColor.opacity(0.6),
                                towerColor.opacity(0.8)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 10, height: 240)
                    .shadow(color: towerColor.opacity(0.4), radius: 8, x: 0, y: 4)
                
                // Base Platform with 3D effect
                ZStack {
                    // Shadow layer
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.15))
                        .frame(width: 130, height: 18)
                        .offset(y: 8)
                    
                    // Main platform
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    towerColor.opacity(0.7),
                                    towerColor.opacity(0.9)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 130, height: 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(towerColor, lineWidth: 2)
                        )
                }
                .offset(y: 8)
                
                // Disks Stack with better animation
                VStack(spacing: 2) {
                    Spacer()
                    ForEach(disks.reversed(), id: \.self) { disk in
                        ImprovedDiskView(
                            size: disk,
                            maxSize: maxDisks,
                            color: towerColor
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                    }
                }
                .frame(height: 240)
                .padding(.bottom, 12)
            }
            .frame(height: 260)
            
            // Disk Count Badge with better design
            HStack(spacing: 6) {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: 11, weight: .bold))
                Text("\(disks.count) disk\(disks.count == 1 ? "" : "s")")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundColor(disks.isEmpty ? .gray : towerColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(disks.isEmpty ? Color.gray.opacity(0.1) : towerColor.opacity(0.15))
            )
            .overlay(
                Capsule()
                    .stroke(disks.isEmpty ? Color.gray.opacity(0.3) : towerColor.opacity(0.4), lineWidth: 1.5)
            )
        }
        .frame(width: 140)
        .padding(Theme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                .fill(Theme.Colors.cardSurfaceStrong)
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
        .overlay(
            TowerBorderOverlay(
                cornerRadius: Theme.CornerRadius.large,
                strokeColor: borderStrokeColor,
                lineWidth: borderStrokeLineWidth
            )
        )
        .overlay(
            TowerGlowOverlay(
                cornerRadius: Theme.CornerRadius.large,
                glowColor: towerColor,
                shouldShow: isHighlighted
            )
        )
        .scaleEffect(isHighlighted ? 1.02 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isActiveTower)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isToTower)
    }
}

// MARK: - Improved Disk View with 3D effect
struct ImprovedDiskView: View {
    let size: Int
    let maxSize: Int
    let color: Color
    
    private var diskWidth: CGFloat {
        let minWidth: CGFloat = 40
        let maxWidth: CGFloat = 115
        let ratio = CGFloat(size) / CGFloat(maxSize)
        return minWidth + (maxWidth - minWidth) * ratio
    }
    
    private var diskColor: Color {
        let intensity = 0.5 + (Double(size) / Double(maxSize) * 0.5)
        return color.opacity(intensity)
    }
    
    var body: some View {
        ZStack {
            // Bottom shadow
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.25))
                .frame(width: diskWidth + 6, height: 28)
                .offset(y: 3)
                .blur(radius: 3)
            
            // Disk with 3D gradient
            ZStack {
                // Main disk body
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [
                                diskColor.opacity(0.9),
                                diskColor,
                                diskColor.opacity(0.8)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: diskWidth, height: 26)
                
                // Top highlight
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .frame(width: diskWidth, height: 26)
                
                // Border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.8), color],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2.5
                    )
                    .frame(width: diskWidth, height: 26)
                
                // Size label
                Text("\(size)")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
            .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.65), value: size)
    }
}

#Preview {
    NavigationStack {
        TowerOfHanoiVisualizationView()
    }
}
