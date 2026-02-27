//
//  FibonacciDPView.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import SwiftUI

struct FibonacciDPView: View {
    @StateObject private var viewModel = FibonacciDPViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()

            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    headerSection
                    FibModeSwitcher(selectedMode: $viewModel.mode, isDisabled: viewModel.isCalculating)
                        .padding(.horizontal, Theme.Spacing.large)

                    if !viewModel.isCalculating {
                        inputSection.transition(.opacity.combined(with: .scale(scale: 0.95)))
                    }

                    explanationBanner

                    Group {
                        switch viewModel.mode {
                        case .recursive: FibRecursiveTreeView(viewModel: viewModel)
                        case .memoization: FibMemoizationView(viewModel: viewModel)
                        case .tabulation: FibTabulationView(viewModel: viewModel)
                        }
                    }.padding(.horizontal, Theme.Spacing.small)

                    if viewModel.isCalculating || viewModel.isCompleted {
                        FibStatsPanel(viewModel: viewModel)
                            .padding(.horizontal, Theme.Spacing.large)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    if viewModel.isCalculating {
                        speedSlider.padding(.horizontal, Theme.Spacing.large).transition(.opacity)
                    }

                    controlPanel.padding(.horizontal, Theme.Spacing.large)

                    if viewModel.isCompleted { quizButton }

                    Spacer(minLength: Theme.Spacing.extraLarge)
                }
            }
            .onTapGesture { isInputFocused = false }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Fibonacci (DP)")
        .navigationDestination(isPresented: $showQuiz) {
            QuizView(algorithm: Algorithm(
                name: "Fibonacci (DP)", description: "Fibonacci with DP",
                icon: "function",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(n)"),
                category: AlgorithmCategory.allCategories[1]
            ))
        }
    }

    // MARK: - Sections
    private var headerSection: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("Fibonacci (DP)").font(Theme.Fonts.title).foregroundColor(Theme.Colors.primaryText)
            Text("See how Dynamic Programming optimizes recursion")
                .font(Theme.Fonts.subtitle).foregroundColor(Theme.Colors.secondaryText)
                .multilineTextAlignment(.center).padding(.horizontal, Theme.Spacing.large)
        }.padding(.top, Theme.Spacing.large)
    }

    private var inputSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Text("Input").font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText).frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("N (Fibonacci position, 0-8)")
                    .font(.system(size: 13, weight: .medium)).foregroundColor(Theme.Colors.secondaryText)
                TextField("e.g., 5", text: $viewModel.nInput)
                    .font(.system(size: 15, design: .monospaced))
                    .keyboardType(.numberPad)
                    .padding(Theme.Spacing.medium)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(Theme.CornerRadius.medium)
                    .overlay(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium).stroke(Color.yellow.opacity(0.3), lineWidth: 1))
                    .focused($isInputFocused)
            }
            if let error = viewModel.inputError {
                HStack(spacing: Theme.Spacing.small) {
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                    Text(error).font(.system(size: 13, weight: .medium)).foregroundColor(.orange)
                }.padding(Theme.Spacing.small).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1)).cornerRadius(Theme.CornerRadius.small)
            }
        }.padding(.horizontal, Theme.Spacing.large)
    }

    private var explanationBanner: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: "lightbulb.fill").foregroundColor(.yellow).font(.system(size: 16))
                Text(viewModel.stepExplanation)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            if viewModel.isCalculating {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.15)).frame(height: 6)
                        RoundedRectangle(cornerRadius: 4).fill(viewModel.mode.color)
                            .frame(width: geo.size.width * viewModel.progress, height: 6)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
                    }
                }.frame(height: 6)
            }
        }
        .padding(Theme.Spacing.medium)
        .background(Color.white.opacity(0.95)).cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal, Theme.Spacing.large)
    }

    private var speedSlider: some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: "hare.fill").font(.system(size: 12)).foregroundColor(.blue)
                Text("Speed").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundColor(Theme.Colors.secondaryText)
                Spacer()
                Text(viewModel.animationSpeed < 0.5 ? "Fast" : viewModel.animationSpeed < 1.0 ? "Normal" : "Slow")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced)).foregroundColor(.blue)
            }
            Slider(value: $viewModel.animationSpeed, in: 0.2...2.0, step: 0.1).accentColor(.blue)
        }.padding(Theme.Spacing.medium).background(Color.white.opacity(0.9)).cornerRadius(Theme.CornerRadius.medium)
    }

    private var controlPanel: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack(spacing: Theme.Spacing.medium) {
                EnhancedControlButton(title: "Start", icon: "play.fill", color: .green, isEnabled: viewModel.canStart) {
                    isInputFocused = false; viewModel.start()
                }
                EnhancedControlButton(title: "Next Step", icon: "forward.fill", color: .blue, isEnabled: viewModel.canNext) {
                    viewModel.nextStep()
                }
            }
            HStack(spacing: Theme.Spacing.medium) {
                if viewModel.isAutoPlaying {
                    EnhancedControlButton(title: "Pause", icon: "pause.fill", color: .orange, isEnabled: true) {
                        viewModel.pauseAutoPlay()
                    }
                } else {
                    EnhancedControlButton(title: "Auto Play", icon: "play.circle.fill", color: .purple, isEnabled: viewModel.canAutoPlay) {
                        isInputFocused = false; viewModel.autoPlay()
                    }
                }
                EnhancedControlButton(title: "Reset", icon: "arrow.counterclockwise", color: .orange, isEnabled: viewModel.canReset) {
                    viewModel.reset()
                }
            }
        }
    }

    private var quizButton: some View {
        Button(action: { showQuiz = true }) {
            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: "questionmark.circle.fill").font(.system(size: 18, weight: .semibold))
                Text("Take Quiz").font(.system(size: 18, weight: .semibold, design: .rounded))
            }.foregroundColor(.white).frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.medium + 2)
                .background(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(Theme.CornerRadius.large)
                .shadow(color: .pink.opacity(0.4), radius: 15, x: 0, y: 8)
        }.padding(.horizontal, Theme.Spacing.large).transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Mode Switcher
struct FibModeSwitcher: View {
    @Binding var selectedMode: FibVisualizationMode
    let isDisabled: Bool

    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("Visualization Mode").font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
            HStack(spacing: 0) {
                ForEach(FibVisualizationMode.allCases, id: \.self) { mode in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { selectedMode = mode }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: mode.icon).font(.system(size: 14, weight: .semibold))
                            Text(mode.rawValue).font(.system(size: 11, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(selectedMode == mode ? .white : Theme.Colors.secondaryText)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(selectedMode == mode ? mode.color : Color.clear))
                    }.disabled(isDisabled)
                }
            }.padding(4).background(Color.white.opacity(0.9)).cornerRadius(14)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - ═══════════════════════════════════════
// MARK:  PART 1 — Recursive Tree Visualization
// MARK: - ═══════════════════════════════════════

struct FibRecursiveTreeView: View {
    @ObservedObject var viewModel: FibonacciDPViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "point.3.connected.trianglepath.dotted").foregroundColor(.red)
                Text("Recursion Tree").font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
                if viewModel.totalCalls > 0 {
                    Text("Calls: \(viewModel.totalCalls)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundColor(.red)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.red.opacity(0.1)).cornerRadius(8)
                }
            }.padding(.horizontal, Theme.Spacing.medium)

            if viewModel.visibleNodes.isEmpty {
                placeholderView(icon: "tree", text: "Press Start to grow the recursion tree")
            } else {
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    ZStack {
                        ForEach(Array(viewModel.visibleEdges.enumerated()), id: \.offset) { _, edge in
                            FibEdgeLine(from: edge.from.position, to: edge.to.position,
                                        color: recEdgeColor(edge.to)).transition(.opacity)
                        }
                        ForEach(viewModel.visibleNodes) { node in
                            FibNodeView(node: node, isRecursive: true)
                                .position(node.position).transition(.scale.combined(with: .opacity))
                        }
                    }
                    .frame(width: treeW, height: treeH).padding(Theme.Spacing.large)
                }
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 420)
                .background(Color.white.opacity(0.6)).cornerRadius(Theme.CornerRadius.large)
            }
        }
    }

    private var treeW: CGFloat { max((viewModel.allNodes.map { $0.position.x }.max() ?? 300) + 80, 300) }
    private var treeH: CGFloat { max((viewModel.allNodes.map { $0.position.y }.max() ?? 200) + 80, 200) }

    private func recEdgeColor(_ child: FibTreeNode) -> Color {
        switch child.state {
        case .duplicate: return .red
        case .computed, .finalResult: return .purple.opacity(0.5)
        default: return .gray.opacity(0.4)
        }
    }
}

// MARK: - ═══════════════════════════════════════
// MARK:  PART 2 — Memoization Visualization
// MARK: - ═══════════════════════════════════════

struct FibMemoizationView: View {
    @ObservedObject var viewModel: FibonacciDPViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "memorychip").foregroundColor(.green)
                Text("Memoization Tree + Cache").font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }.padding(.horizontal, Theme.Spacing.medium)

            if viewModel.memoVisibleNodes.isEmpty {
                placeholderView(icon: "memorychip", text: "Press Start to see memoization in action")
            } else {
                HStack(alignment: .top, spacing: Theme.Spacing.small) {
                    ScrollView([.horizontal, .vertical], showsIndicators: false) {
                        ZStack {
                            ForEach(Array(viewModel.memoVisibleEdges.enumerated()), id: \.offset) { _, edge in
                                FibEdgeLine(from: edge.from.position, to: edge.to.position,
                                            color: memoEdgeColor(edge.to)).transition(.opacity)
                            }
                            ForEach(viewModel.memoVisibleNodes) { node in
                                FibNodeView(node: node, isRecursive: false)
                                    .position(node.position).transition(.scale.combined(with: .opacity))
                            }
                        }
                        .frame(width: memoW, height: memoH).padding(Theme.Spacing.medium)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 420)
                    .background(Color.white.opacity(0.6)).cornerRadius(Theme.CornerRadius.large)

                    FibCachePanel(entries: viewModel.cacheEntries).frame(width: 120)
                }
            }
        }
    }

    private var memoW: CGFloat { max((viewModel.memoNodes.map { $0.position.x }.max() ?? 260) + 80, 260) }
    private var memoH: CGFloat { max((viewModel.memoNodes.map { $0.position.y }.max() ?? 200) + 80, 200) }

    private func memoEdgeColor(_ child: FibTreeNode) -> Color {
        switch child.state {
        case .cacheHit: return .green
        case .cached, .finalResult: return .green.opacity(0.4)
        default: return .gray.opacity(0.4)
        }
    }
}

// MARK: - Cache Panel
struct FibCachePanel: View {
    let entries: [CacheEntry]

    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack(spacing: 4) {
                Image(systemName: "tray.full.fill").font(.system(size: 12)).foregroundColor(.green)
                Text("Cache").font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                .background(Color.green.opacity(0.1)).cornerRadius(8)

            if entries.isEmpty {
                Text("Empty").font(.system(size: 12, design: .rounded)).foregroundColor(.gray)
                    .padding(.vertical, Theme.Spacing.large)
            } else {
                ForEach(entries.sorted(by: { $0.key < $1.key })) { entry in
                    HStack {
                        Text("F(\(entry.key))").font(.system(size: 12, weight: .semibold, design: .monospaced)).foregroundColor(.green)
                        Spacer()
                        Text("= \(entry.value)").font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.Colors.primaryText)
                    }
                    .padding(.horizontal, 8).padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 6).fill(entry.isHit ? Color.green.opacity(0.25) : Color.white.opacity(0.8)))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(entry.isHit ? Color.green : Color.clear, lineWidth: 2))
                    .scaleEffect(entry.isHit ? 1.08 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: entry.isHit)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(Theme.Spacing.small).background(Color.white.opacity(0.9))
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

// MARK: - ═══════════════════════════════════════
// MARK:  PART 3 — Tabulation Visualization
// MARK: - ═══════════════════════════════════════

struct FibTabulationView: View {
    @ObservedObject var viewModel: FibonacciDPViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "tablecells").foregroundColor(.blue)
                Text("DP Table (Bottom-Up)").font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }.padding(.horizontal, Theme.Spacing.medium)

            if viewModel.dpTable.isEmpty {
                placeholderView(icon: "tablecells", text: "Press Start to fill the DP table")
            } else {
                VStack(spacing: Theme.Spacing.medium) {
                    if !viewModel.currentComputation.isEmpty {
                        Text(viewModel.currentComputation)
                            .font(.system(size: 16, weight: .bold, design: .monospaced)).foregroundColor(.blue)
                            .padding(.horizontal, Theme.Spacing.medium).padding(.vertical, Theme.Spacing.small)
                            .background(Color.blue.opacity(0.08)).cornerRadius(Theme.CornerRadius.medium)
                            .transition(.scale.combined(with: .opacity))
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 4) {
                            HStack(spacing: 8) {
                                Text("Index").font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundColor(Theme.Colors.secondaryText).frame(width: 44)
                                ForEach(viewModel.dpTable) { cell in
                                    Text("\(cell.index)")
                                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        .foregroundColor(tabIdxColor(cell)).frame(width: 56)
                                }
                            }
                            HStack(spacing: 8) {
                                Text("dp[]").font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundColor(Theme.Colors.secondaryText).frame(width: 44)
                                ForEach(viewModel.dpTable) { cell in
                                    FibDPCellView(cell: cell)
                                }
                            }
                        }.padding(Theme.Spacing.medium)
                    }
                    .background(Color.white.opacity(0.9)).cornerRadius(Theme.CornerRadius.large)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                }.padding(.horizontal, Theme.Spacing.small)
            }
        }
    }

    private func tabIdxColor(_ c: DPTableCell) -> Color {
        switch c.state {
        case .computing: return .blue; case .highlight1: return .orange
        case .highlight2: return .cyan; case .finalResult: return .purple
        default: return Theme.Colors.secondaryText
        }
    }
}

// MARK: - DP Cell
struct FibDPCellView: View {
    let cell: DPTableCell
    var body: some View {
        Text(cell.value != nil ? "\(cell.value!)" : "?")
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(cellTextColor).frame(width: 56, height: 56)
            .background(cellBg).cornerRadius(Theme.CornerRadius.medium)
            .overlay(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium).stroke(cellBorder, lineWidth: cellBorderW))
            .shadow(color: cellShadow, radius: cellShadowR, x: 0, y: 4)
            .scaleEffect(cellScale)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: cell.state)
    }
    private var cellTextColor: Color {
        switch cell.state {
        case .empty: return .gray.opacity(0.4); case .baseCase: return .green; case .computing: return .blue
        case .highlight1: return .orange; case .highlight2: return .cyan
        case .filled: return Theme.Colors.primaryText; case .finalResult: return .purple
        }
    }
    private var cellBg: Color {
        switch cell.state {
        case .empty: return .white.opacity(0.5); case .baseCase: return .green.opacity(0.1)
        case .computing: return .blue.opacity(0.12); case .highlight1: return .orange.opacity(0.12)
        case .highlight2: return .cyan.opacity(0.12); case .filled: return .white.opacity(0.95)
        case .finalResult: return .purple.opacity(0.15)
        }
    }
    private var cellBorder: Color {
        switch cell.state {
        case .empty: return .gray.opacity(0.2); case .baseCase: return .green; case .computing: return .blue
        case .highlight1: return .orange; case .highlight2: return .cyan
        case .filled: return .gray.opacity(0.2); case .finalResult: return .purple
        }
    }
    private var cellBorderW: CGFloat {
        switch cell.state {
        case .computing, .highlight1, .highlight2, .finalResult: return 2.5; case .baseCase: return 2; default: return 1
        }
    }
    private var cellShadow: Color {
        switch cell.state {
        case .computing: return .blue.opacity(0.3); case .finalResult: return .purple.opacity(0.4)
        default: return .black.opacity(0.04)
        }
    }
    private var cellShadowR: CGFloat {
        switch cell.state { case .computing, .finalResult: return 10; default: return 4 }
    }
    private var cellScale: CGFloat {
        switch cell.state { case .computing: return 1.1; case .finalResult: return 1.12; default: return 1.0 }
    }
}

// MARK: - ═══════════════════════════════════════
// MARK:  Shared Components
// MARK: - ═══════════════════════════════════════

struct FibNodeView: View {
    @ObservedObject var node: FibTreeNode
    let isRecursive: Bool

    var body: some View {
        VStack(spacing: 2) {
            Text("F(\(node.value))")
                .font(.system(size: 13, weight: .bold, design: .rounded)).foregroundColor(nTextColor)
            if let result = node.result,
               [.computed, .finalResult, .cached, .cacheHit].contains(node.state) {
                Text("= \(result)")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(nResultColor)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 52, height: 52).background(nBg).clipShape(Circle())
        .overlay(Circle().stroke(nBorder, lineWidth: nBorderW))
        .shadow(color: nShadow, radius: nShadowR, x: 0, y: 3)
        .scaleEffect(nScale).opacity(node.state == .hidden ? 0 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: node.state)
    }

    private var nTextColor: Color {
        switch node.state {
        case .hidden, .appearing: return .gray; case .computing: return .blue
        case .duplicate: return .white; case .cached: return .green
        case .cacheHit: return .white; case .computed: return .purple; case .finalResult: return .white
        }
    }
    private var nResultColor: Color {
        switch node.state {
        case .finalResult: return .white.opacity(0.9); case .cached, .cacheHit: return .green
        default: return .purple.opacity(0.8)
        }
    }
    private var nBg: Color {
        switch node.state {
        case .hidden: return .clear; case .appearing: return .white.opacity(0.7)
        case .computing: return .blue.opacity(0.1); case .duplicate: return .red.opacity(0.85)
        case .cached: return .green.opacity(0.1); case .cacheHit: return .green.opacity(0.85)
        case .computed: return .purple.opacity(0.08); case .finalResult: return .purple.opacity(0.9)
        }
    }
    private var nBorder: Color {
        switch node.state {
        case .computing: return .blue; case .duplicate: return .red; case .cached: return .green
        case .cacheHit: return .green; case .computed: return .purple.opacity(0.4)
        case .finalResult: return .purple; default: return .gray.opacity(0.3)
        }
    }
    private var nBorderW: CGFloat {
        switch node.state {
        case .computing, .duplicate, .cacheHit, .finalResult: return 3; case .cached: return 2; default: return 1.5
        }
    }
    private var nShadow: Color {
        switch node.state {
        case .computing: return .blue.opacity(0.4); case .duplicate: return .red.opacity(0.5)
        case .cacheHit: return .green.opacity(0.5); case .finalResult: return .purple.opacity(0.5)
        default: return .black.opacity(0.06)
        }
    }
    private var nShadowR: CGFloat {
        switch node.state { case .computing, .duplicate, .cacheHit, .finalResult: return 12; default: return 4 }
    }
    private var nScale: CGFloat {
        switch node.state {
        case .appearing: return 0.5; case .computing: return 1.08; case .duplicate: return 1.15
        case .cacheHit: return 1.12; case .finalResult: return 1.15; default: return 1.0
        }
    }
}

struct FibEdgeLine: View {
    let from: CGPoint; let to: CGPoint; let color: Color
    var body: some View {
        Path { p in
            p.move(to: from)
            p.addCurve(to: to,
                       control1: CGPoint(x: from.x, y: from.y + (to.y - from.y) * 0.5),
                       control2: CGPoint(x: to.x, y: to.y - (to.y - from.y) * 0.5))
        }.stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .animation(.easeInOut(duration: 0.4), value: color)
    }
}

// MARK: - Stats
struct FibStatsPanel: View {
    @ObservedObject var viewModel: FibonacciDPViewModel
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            HStack {
                Image(systemName: "chart.bar.fill").foregroundColor(viewModel.mode.color)
                Text("Statistics").font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            switch viewModel.mode {
            case .recursive:
                HStack(spacing: Theme.Spacing.medium) {
                    FibStatBadge(title: "Total Calls", value: "\(viewModel.totalCalls)", color: .blue)
                    FibStatBadge(title: "Duplicates", value: "\(viewModel.duplicateCount)", color: .red)
                    FibStatBadge(title: "Complexity", value: "O(2ⁿ)", color: .red)
                }
            case .memoization:
                HStack(spacing: Theme.Spacing.medium) {
                    FibStatBadge(title: "Total Calls", value: "\(viewModel.memoCalls)", color: .blue)
                    FibStatBadge(title: "Cache Hits", value: "\(viewModel.cacheHits)", color: .green)
                    FibStatBadge(title: "Complexity", value: "O(n)", color: .green)
                }
            case .tabulation:
                HStack(spacing: Theme.Spacing.medium) {
                    FibStatBadge(title: "Cells", value: "\(viewModel.dpTable.filter { $0.value != nil }.count)", color: .blue)
                    FibStatBadge(title: "Time", value: "O(n)", color: .blue)
                    FibStatBadge(title: "Space", value: "O(n)", color: .blue)
                }
            }
        }.padding(Theme.Spacing.medium).background(Color.white.opacity(0.9))
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct FibStatBadge: View {
    let title: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(color)
            Text(title).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(Theme.Colors.secondaryText)
        }.frame(maxWidth: .infinity).padding(.vertical, 8)
            .background(color.opacity(0.08)).cornerRadius(8)
    }
}

// MARK: - Placeholder Helper
private func placeholderView(icon: String, text: String) -> some View {
    VStack(spacing: 12) {
        Image(systemName: icon).font(.system(size: 40)).foregroundColor(.gray.opacity(0.3))
        Text(text).font(.system(size: 14, design: .rounded)).foregroundColor(Theme.Colors.secondaryText)
    }.frame(maxWidth: .infinity, minHeight: 200)
        .background(Color.white.opacity(0.6)).cornerRadius(Theme.CornerRadius.large)
}

#Preview {
    NavigationStack { FibonacciDPView() }
}
