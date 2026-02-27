//
//  FibonacciDPViewModel.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import SwiftUI
import Combine

// MARK: - Visualization Mode
enum FibVisualizationMode: String, CaseIterable {
    case recursive = "Recursive"
    case memoization = "Memoization"
    case tabulation = "Tabulation"
    
    var icon: String {
        switch self {
        case .recursive: return "point.3.connected.trianglepath.dotted"
        case .memoization: return "memorychip"
        case .tabulation: return "tablecells"
        }
    }
    
    var color: Color {
        switch self {
        case .recursive: return .red
        case .memoization: return .green
        case .tabulation: return .blue
        }
    }
}

// MARK: - Tree Node
class FibTreeNode: Identifiable, ObservableObject {
    let id = UUID()
    let value: Int
    var left: FibTreeNode?
    var right: FibTreeNode?
    var result: Int?
    @Published var state: NodeState = .hidden
    var depth: Int
    var position: CGPoint = .zero
    var isDuplicate: Bool = false
    var cacheHit: Bool = false
    
    enum NodeState: Equatable {
        case hidden, appearing, computing, duplicate, cached, cacheHit, computed, finalResult
    }
    
    init(value: Int, depth: Int) {
        self.value = value
        self.depth = depth
    }
}

// MARK: - DP Table Cell
struct DPTableCell: Identifiable {
    let id = UUID()
    let index: Int
    var value: Int?
    var state: CellState = .empty
    
    enum CellState {
        case empty, baseCase, computing, highlight1, highlight2, filled, finalResult
    }
}

// MARK: - Cache Entry
struct CacheEntry: Identifiable {
    let id = UUID()
    let key: Int
    let value: Int
    var isNew: Bool = true
    var isHit: Bool = false
}

// MARK: - Animation Step
struct FibAnimationStep {
    enum StepType {
        case showNode(FibTreeNode)
        case expandChildren(FibTreeNode)
        case markDuplicate(FibTreeNode)
        case computeResult(FibTreeNode, Int)
        case memoShowNode(FibTreeNode)
        case memoExpand(FibTreeNode)
        case memoCache(FibTreeNode, Int)
        case memoCacheHit(FibTreeNode, Int)
        case memoResult(FibTreeNode, Int)
        case tabBaseCase(Int, Int)
        case tabHighlightDeps(Int, Int, Int)
        case tabCompute(Int, Int)
        case tabFinalResult(Int)
    }
    let type: StepType
    let explanation: String
}

// MARK: - ViewModel
@MainActor
class FibonacciDPViewModel: ObservableObject {
    @Published var nInput: String = "5"
    @Published var inputError: String?
    @Published var n: Int = 5
    @Published var mode: FibVisualizationMode = .recursive
    @Published var isCalculating = false
    @Published var isCompleted = false
    @Published var isAutoPlaying = false
    @Published var currentStepIndex: Int = -1
    @Published var stepExplanation: String = "Press Start to begin the visualization"
    @Published var animationSpeed: Double = 0.8

    // Recursive
    @Published var treeRoot: FibTreeNode?
    @Published var allNodes: [FibTreeNode] = []
    @Published var visibleNodes: [FibTreeNode] = []
    @Published var visibleEdges: [(from: FibTreeNode, to: FibTreeNode)] = []
    @Published var duplicateCount: Int = 0
    @Published var totalCalls: Int = 0

    // Memoization
    @Published var memoRoot: FibTreeNode?
    @Published var memoNodes: [FibTreeNode] = []
    @Published var memoVisibleNodes: [FibTreeNode] = []
    @Published var memoVisibleEdges: [(from: FibTreeNode, to: FibTreeNode)] = []
    @Published var cacheEntries: [CacheEntry] = []
    @Published var memoCalls: Int = 0
    @Published var cacheHits: Int = 0

    // Tabulation
    @Published var dpTable: [DPTableCell] = []
    @Published var currentComputation: String = ""

    private var animationSteps: [FibAnimationStep] = []
    private var autoPlayTask: Task<Void, Never>?

    var canStart: Bool { !isCalculating && !isCompleted }
    var canNext: Bool { isCalculating && !isAutoPlaying && currentStepIndex < animationSteps.count - 1 }
    var canAutoPlay: Bool { isCalculating && currentStepIndex < animationSteps.count - 1 }
    var canReset: Bool { isCalculating || isCompleted }
    var progress: Double {
        guard !animationSteps.isEmpty else { return 0 }
        return Double(currentStepIndex + 1) / Double(animationSteps.count)
    }

    // MARK: - Validate
    func validateInput() -> Bool {
        guard let val = Int(nInput), val >= 0, val <= 8 else {
            inputError = "Please enter a number between 0 and 8"
            return false
        }
        inputError = nil
        n = val
        return true
    }

    // MARK: - Start
    func start() {
        guard validateInput() else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            isCalculating = true
            isCompleted = false
            currentStepIndex = -1
            duplicateCount = 0; totalCalls = 0
            memoCalls = 0; cacheHits = 0
        }
        switch mode {
        case .recursive: buildRecursiveSteps()
        case .memoization: buildMemoizationSteps()
        case .tabulation: buildTabulationSteps()
        }
        stepExplanation = "Ready! Press Next Step or Auto Play"
    }

    // MARK: - Next Step
    func nextStep() {
        guard currentStepIndex < animationSteps.count - 1 else {
            completeVisualization(); return
        }
        currentStepIndex += 1
        let step = animationSteps[currentStepIndex]
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            executeStep(step)
        }
        if currentStepIndex >= animationSteps.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.completeVisualization() }
        }
    }

    // MARK: - Auto Play
    func autoPlay() {
        isAutoPlaying = true
        autoPlayTask = Task {
            while currentStepIndex < animationSteps.count - 1 && !Task.isCancelled {
                nextStep()
                try? await Task.sleep(nanoseconds: UInt64(animationSpeed * 1_000_000_000))
            }
            isAutoPlaying = false
        }
    }

    func pauseAutoPlay() {
        isAutoPlaying = false
        autoPlayTask?.cancel()
        autoPlayTask = nil
    }

    // MARK: - Reset
    func reset() {
        autoPlayTask?.cancel(); autoPlayTask = nil
        withAnimation(.easeInOut(duration: 0.3)) {
            nInput = "5"; inputError = nil; n = 5
            isCalculating = false; isCompleted = false; isAutoPlaying = false
            currentStepIndex = -1
            stepExplanation = "Press Start to begin the visualization"
            treeRoot = nil; allNodes = []; visibleNodes = []; visibleEdges = []
            duplicateCount = 0; totalCalls = 0
            memoRoot = nil; memoNodes = []; memoVisibleNodes = []; memoVisibleEdges = []
            cacheEntries = []; memoCalls = 0; cacheHits = 0
            dpTable = []; currentComputation = ""; animationSteps = []
        }
    }

    private func completeVisualization() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCompleted = true; isCalculating = true; isAutoPlaying = false
            switch mode {
            case .recursive:
                stepExplanation = "🔴 Total calls: \(totalCalls) | Duplicates: \(duplicateCount) — O(2ⁿ) time complexity!"
            case .memoization:
                stepExplanation = "🟢 Total calls: \(memoCalls) | Cache hits: \(cacheHits) — O(n) with memoization!"
            case .tabulation:
                stepExplanation = "🔵 Filled \(n + 1) cells — O(n) time, O(n) space!"
            }
        }
    }

    // MARK: - Build Recursive
    private func buildRecursiveSteps() {
        allNodes = []; visibleNodes = []; visibleEdges = []; animationSteps = []
        let root = buildRecTree(n, depth: 0)
        treeRoot = root
        assignPositions(root: root)
        var seen = Set<Int>()
        buildRecAnimSteps(node: root, seen: &seen)
    }

    private func buildRecTree(_ n: Int, depth: Int) -> FibTreeNode {
        let node = FibTreeNode(value: n, depth: depth)
        allNodes.append(node)
        if n > 1 {
            node.left = buildRecTree(n - 1, depth: depth + 1)
            node.right = buildRecTree(n - 2, depth: depth + 1)
        }
        if n <= 1 { node.result = n }
        return node
    }

    private func buildRecAnimSteps(node: FibTreeNode, seen: inout Set<Int>) {
        let isDup = seen.contains(node.value) && node.value > 1
        node.isDuplicate = isDup
        animationSteps.append(FibAnimationStep(
            type: .showNode(node),
            explanation: isDup ? "⚠️ Fib(\(node.value)) — Repeated computation!" : "📍 Exploring Fib(\(node.value))"
        ))
        if isDup {
            animationSteps.append(FibAnimationStep(
                type: .markDuplicate(node),
                explanation: "🔴 Fib(\(node.value)) already computed! Wasted work."
            ))
        }
        seen.insert(node.value)
        if let left = node.left, let right = node.right {
            animationSteps.append(FibAnimationStep(
                type: .expandChildren(node),
                explanation: "🌳 Fib(\(node.value)) = Fib(\(node.value-1)) + Fib(\(node.value-2))"
            ))
            buildRecAnimSteps(node: left, seen: &seen)
            buildRecAnimSteps(node: right, seen: &seen)
            let res = fibVal(left.value) + fibVal(right.value)
            node.result = res
            animationSteps.append(FibAnimationStep(
                type: .computeResult(node, res),
                explanation: "✅ Fib(\(node.value)) = \(fibVal(left.value)) + \(fibVal(right.value)) = \(res)"
            ))
        } else {
            animationSteps.append(FibAnimationStep(
                type: .computeResult(node, node.value),
                explanation: "📌 Base case: Fib(\(node.value)) = \(node.value)"
            ))
        }
    }

    // MARK: - Build Memoization
    private func buildMemoizationSteps() {
        memoNodes = []; memoVisibleNodes = []; memoVisibleEdges = []
        cacheEntries = []; animationSteps = []
        let root = FibTreeNode(value: n, depth: 0)
        memoRoot = root; memoNodes.append(root)
        var cache = [Int: Int]()
        buildMemoAnimSteps(node: root, cache: &cache)
    }

    private func buildMemoAnimSteps(node: FibTreeNode, cache: inout [Int: Int]) {
        animationSteps.append(FibAnimationStep(
            type: .memoShowNode(node),
            explanation: "📍 Computing Fib(\(node.value))"
        ))
        if let cached = cache[node.value] {
            node.result = cached; node.cacheHit = true
            animationSteps.append(FibAnimationStep(
                type: .memoCacheHit(node, cached),
                explanation: "💚 Cache hit! Fib(\(node.value)) = \(cached) — no recomputation"
            ))
            return
        }
        if node.value <= 1 {
            node.result = node.value; cache[node.value] = node.value
            animationSteps.append(FibAnimationStep(
                type: .memoCache(node, node.value),
                explanation: "📌 Base: Fib(\(node.value)) = \(node.value) → cached"
            ))
            return
        }
        let left = FibTreeNode(value: node.value-1, depth: node.depth+1)
        let right = FibTreeNode(value: node.value-2, depth: node.depth+1)
        node.left = left; node.right = right
        memoNodes.append(left); memoNodes.append(right)
        animationSteps.append(FibAnimationStep(
            type: .memoExpand(node),
            explanation: "🌳 Fib(\(node.value)) = Fib(\(node.value-1)) + Fib(\(node.value-2))"
        ))
        buildMemoAnimSteps(node: left, cache: &cache)
        buildMemoAnimSteps(node: right, cache: &cache)
        let res = (left.result ?? 0) + (right.result ?? 0)
        node.result = res; cache[node.value] = res
        animationSteps.append(FibAnimationStep(
            type: .memoResult(node, res),
            explanation: "✅ Fib(\(node.value)) = \(left.result ?? 0) + \(right.result ?? 0) = \(res) → cached"
        ))
    }

    // MARK: - Build Tabulation
    private func buildTabulationSteps() {
        animationSteps = []
        dpTable = (0...n).map { DPTableCell(index: $0) }
        animationSteps.append(FibAnimationStep(type: .tabBaseCase(0, 0), explanation: "📌 Base case: dp[0] = 0"))
        if n >= 1 {
            animationSteps.append(FibAnimationStep(type: .tabBaseCase(1, 1), explanation: "📌 Base case: dp[1] = 1"))
        }
        for i in 2...max(2, n) {
            guard i <= n else { break }
            let v1 = fibVal(i-1), v2 = fibVal(i-2), res = v1 + v2
            animationSteps.append(FibAnimationStep(
                type: .tabHighlightDeps(i, i-1, i-2),
                explanation: "🔍 dp[\(i)] = dp[\(i-1)] + dp[\(i-2)] = \(v1) + \(v2)"
            ))
            animationSteps.append(FibAnimationStep(
                type: .tabCompute(i, res),
                explanation: "✅ dp[\(i)] = \(res)"
            ))
        }
        animationSteps.append(FibAnimationStep(
            type: .tabFinalResult(n),
            explanation: "🎉 Fib(\(n)) = \(fibVal(n)) — O(n) time!"
        ))
    }

    // MARK: - Execute
    private func executeStep(_ step: FibAnimationStep) {
        stepExplanation = step.explanation
        switch step.type {
        case .showNode(let node):
            totalCalls += 1; node.state = .appearing
            if !visibleNodes.contains(where: { $0.id == node.id }) { visibleNodes.append(node) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { node.state = .computing }
            }
        case .expandChildren(let node):
            if let l = node.left { visibleEdges.append((from: node, to: l)) }
            if let r = node.right { visibleEdges.append((from: node, to: r)) }
        case .markDuplicate(let node):
            duplicateCount += 1; node.state = .duplicate
            for n in visibleNodes where n.value == node.value && n.id != node.id {
                n.state = .duplicate
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation { if n.state == .duplicate { n.state = .computed } }
                }
            }
        case .computeResult(let node, _):
            node.state = node.value == n ? .finalResult : .computed

        case .memoShowNode(let node):
            memoCalls += 1; node.state = .appearing
            if !memoVisibleNodes.contains(where: { $0.id == node.id }) { memoVisibleNodes.append(node) }
            assignMemoPositions()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { node.state = .computing }
            }
        case .memoExpand(let node):
            if let l = node.left { memoVisibleEdges.append((from: node, to: l)) }
            if let r = node.right { memoVisibleEdges.append((from: node, to: r)) }
            assignMemoPositions()
        case .memoCache(let node, let val):
            node.state = .cached
            if !cacheEntries.contains(where: { $0.key == node.value }) {
                cacheEntries.append(CacheEntry(key: node.value, value: val))
            }
        case .memoCacheHit(let node, _):
            cacheHits += 1; node.state = .cacheHit
            for i in cacheEntries.indices where cacheEntries[i].key == node.value {
                cacheEntries[i].isHit = true
                let idx = i
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { self.cacheEntries[idx].isHit = false }
            }
        case .memoResult(let node, let val):
            node.state = node.value == n ? .finalResult : .cached
            if !cacheEntries.contains(where: { $0.key == node.value }) {
                cacheEntries.append(CacheEntry(key: node.value, value: val))
            }

        case .tabBaseCase(let idx, let val):
            if idx < dpTable.count { dpTable[idx].value = val; dpTable[idx].state = .baseCase }
            currentComputation = "dp[\(idx)] = \(val)"
        case .tabHighlightDeps(let idx, let d1, let d2):
            for i in dpTable.indices {
                if dpTable[i].state == .highlight1 || dpTable[i].state == .highlight2 || dpTable[i].state == .computing {
                    dpTable[i].state = .filled
                }
            }
            if d1 < dpTable.count { dpTable[d1].state = .highlight1 }
            if d2 < dpTable.count { dpTable[d2].state = .highlight2 }
            if idx < dpTable.count { dpTable[idx].state = .computing }
            currentComputation = "dp[\(idx)] = dp[\(d1)] + dp[\(d2)]"
        case .tabCompute(let idx, let val):
            for i in dpTable.indices {
                if dpTable[i].state == .highlight1 || dpTable[i].state == .highlight2 { dpTable[i].state = .filled }
            }
            if idx < dpTable.count { dpTable[idx].value = val; dpTable[idx].state = .filled }
            currentComputation = "dp[\(idx)] = \(val) ✓"
        case .tabFinalResult(let idx):
            for i in dpTable.indices {
                if dpTable[i].state == .highlight1 || dpTable[i].state == .highlight2 { dpTable[i].state = .filled }
            }
            if idx < dpTable.count { dpTable[idx].state = .finalResult }
            currentComputation = "Result: Fib(\(n)) = \(fibVal(n))"
        }
    }

    // MARK: - Helpers
    func fibVal(_ n: Int) -> Int {
        if n <= 0 { return 0 }; if n == 1 { return 1 }
        var a = 0, b = 1
        for _ in 2...n { let t = a+b; a = b; b = t }
        return b
    }

    func assignPositions(root: FibTreeNode?) {
        guard let root else { return }
        let d = maxDepth(root)
        let w = CGFloat(pow(2.0, Double(d))) * 44
        posHelper(node: root, x: w/2, y: 40, hs: w/4)
    }

    func assignMemoPositions() {
        guard let root = memoRoot else { return }
        let d = memoMaxDepth(root)
        let w = CGFloat(pow(2.0, Double(d))) * 44
        posHelper(node: root, x: w/2, y: 40, hs: w/4)
    }

    private func posHelper(node: FibTreeNode, x: CGFloat, y: CGFloat, hs: CGFloat) {
        node.position = CGPoint(x: x, y: y)
        if let l = node.left { posHelper(node: l, x: x-hs, y: y+72, hs: hs/2) }
        if let r = node.right { posHelper(node: r, x: x+hs, y: y+72, hs: hs/2) }
    }

    private func maxDepth(_ n: FibTreeNode) -> Int {
        if n.left == nil && n.right == nil { return 0 }
        return max(n.left.map { maxDepth($0) } ?? 0, n.right.map { maxDepth($0) } ?? 0) + 1
    }

    private func memoMaxDepth(_ node: FibTreeNode) -> Int {
        guard memoVisibleNodes.contains(where: { $0.id == node.id }) else { return 0 }
        if node.left == nil && node.right == nil { return 0 }
        let l: Int
        if let left = node.left, memoVisibleNodes.contains(where: { $0.id == left.id }) {
            l = memoMaxDepth(left)
        } else {
            l = 0
        }
        let r: Int
        if let right = node.right, memoVisibleNodes.contains(where: { $0.id == right.id }) {
            r = memoMaxDepth(right)
        } else {
            r = 0
        }
        return max(l, r) + 1
    }
}
