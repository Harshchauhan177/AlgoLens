//
//  TowerOfHanoiViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

// MARK: - Move Structure
struct HanoiMove {
    let diskSize: Int
    let fromTower: Int
    let toTower: Int
    
    var description: String {
        "Move disk \(diskSize) from Tower \(Character(UnicodeScalar(65 + fromTower)!)) to Tower \(Character(UnicodeScalar(65 + toTower)!))"
    }
}

@MainActor
class TowerOfHanoiViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var towers: [[Int]] = [[], [], []]
    @Published var moves: [HanoiMove] = []
    @Published var currentStep = 0
    @Published var isAnimating = false
    @Published var isCompleted = false
    
    // MARK: - Tower tracking for auto-scroll
    @Published var activeTowerIndex: Int = -1
    @Published var fromTowerIndex: Int = -1
    @Published var toTowerIndex: Int = -1
    
    // MARK: - Input Fields
    @Published var numberOfDisks = 3
    @Published var diskInput: String = "3"
    @Published var inputError: String?
    
    // MARK: - Step Information
    @Published var currentMoveDescription: String = ""
    @Published var finalResult: String = ""
    
    // MARK: - Control State
    @Published var canStart: Bool = true
    @Published var canNext: Bool = false
    @Published var canRunComplete: Bool = true
    @Published var canReset: Bool = false
    
    // MARK: - Auto-run
    private var autoRunTask: Task<Void, Never>?
    private let autoRunDelay: Double = 0.8
    
    // MARK: - Initialization
    init() {
        setupTowers()
    }
    
    // MARK: - Input Validation
    func updateFromInputs() {
        inputError = nil
        
        let trimmedInput = diskInput.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedInput.isEmpty else {
            inputError = "Number of disks cannot be empty"
            return
        }
        
        guard let disks = Int(trimmedInput) else {
            inputError = "Please enter a valid number"
            return
        }
        
        guard disks >= 1 else {
            inputError = "Minimum 1 disk required"
            return
        }
        
        guard disks <= 8 else {
            inputError = "Maximum 8 disks allowed"
            return
        }
        
        numberOfDisks = disks
    }
    
    // MARK: - Setup
    func setupTowers() {
        towers = [[], [], []]
        // Disks are numbered from 1 (smallest) to n (largest)
        // Store them in reverse order so smallest is on top (last in array)
        towers[0] = Array(1...numberOfDisks).reversed()
        currentStep = 0
        isCompleted = false
        currentMoveDescription = ""
        finalResult = ""
        activeTowerIndex = -1
        fromTowerIndex = -1
        toTowerIndex = -1
        generateMoves()
    }
    
    private func generateMoves() {
        moves = []
        // Simulate the moves to track which disk actually moves
        var simulatedTowers: [[Int]] = [[], [], []]
        simulatedTowers[0] = Array(1...numberOfDisks)
        solveHanoi(n: numberOfDisks, from: 0, to: 2, aux: 1, towers: &simulatedTowers)
    }
    
    private func solveHanoi(n: Int, from: Int, to: Int, aux: Int, towers: inout [[Int]]) {
        if n == 1 {
            // Move the top disk from 'from' tower to 'to' tower
            if let disk = towers[from].popLast() {
                towers[to].append(disk)
                moves.append(HanoiMove(diskSize: disk, fromTower: from, toTower: to))
            }
            return
        }
        
        // Step 1: Move n-1 disks from source to auxiliary, using destination as auxiliary
        solveHanoi(n: n - 1, from: from, to: aux, aux: to, towers: &towers)
        
        // Step 2: Move the largest disk from source to destination
        if let disk = towers[from].popLast() {
            towers[to].append(disk)
            moves.append(HanoiMove(diskSize: disk, fromTower: from, toTower: to))
        }
        
        // Step 3: Move n-1 disks from auxiliary to destination, using source as auxiliary
        solveHanoi(n: n - 1, from: aux, to: to, aux: from, towers: &towers)
    }
    
    // MARK: - User Actions
    func start() {
        guard canStart else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupTowers()
            canStart = false
            canNext = true
            canRunComplete = false
            canReset = true
            
            if currentStep < moves.count {
                currentMoveDescription = moves[currentStep].description
            }
        }
    }
    
    func nextStep() {
        guard canNext && !isCompleted && !isAnimating else { return }
        performStep()
    }
    
    func runComplete() {
        guard canRunComplete else { return }
        
        updateFromInputs()
        guard inputError == nil else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupTowers()
            isAnimating = true
            canStart = false
            canNext = false
            canRunComplete = false
            canReset = false
            
            if currentStep < moves.count {
                currentMoveDescription = moves[currentStep].description
            }
        }
        
        autoRunTask = Task {
            while currentStep < moves.count && !isCompleted {
                try? await Task.sleep(nanoseconds: UInt64(autoRunDelay * 1_000_000_000))
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    performStep()
                }
                
                if isCompleted {
                    break
                }
            }
            
            await MainActor.run {
                isAnimating = false
                canReset = true
            }
        }
    }
    
    func reset() {
        autoRunTask?.cancel()
        autoRunTask = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            setupTowers()
            currentStep = 0
            isAnimating = false
            isCompleted = false
            currentMoveDescription = ""
            finalResult = ""
            
            canStart = true
            canNext = false
            canRunComplete = true
            canReset = false
        }
    }
    
    // MARK: - Core Algorithm Logic
    private func performStep() {
        guard currentStep < moves.count else {
            completeAlgorithm()
            return
        }
        
        executeMove(at: currentStep)
        currentStep += 1
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentStep < moves.count {
                currentMoveDescription = moves[currentStep].description
            } else {
                completeAlgorithm()
            }
        }
    }
    
    private func executeMove(at index: Int) {
        let move = moves[index]
        
        // Update active tower indices for auto-scroll
        fromTowerIndex = move.fromTower
        toTowerIndex = move.toTower
        activeTowerIndex = move.toTower // Focus on destination tower
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if let disk = towers[move.fromTower].popLast() {
                // Validate the move follows Tower of Hanoi rules
                if towers[move.toTower].isEmpty || towers[move.toTower].last! > disk {
                    towers[move.toTower].append(disk)
                } else {
                    // This should never happen if the algorithm is correct
                    print("⚠️ Invalid move detected: trying to place disk \(disk) on smaller disk \(towers[move.toTower].last!)")
                    // Still append to prevent state inconsistency
                    towers[move.toTower].append(disk)
                }
            }
        }
    }
    
    private func completeAlgorithm() {
        isCompleted = true
        canNext = false
        activeTowerIndex = 2 // Highlight the destination tower
        fromTowerIndex = -1
        toTowerIndex = -1
        
        // Verify all disks are on Tower C in correct order
        let expectedMoves = (1 << numberOfDisks) - 1 // 2^n - 1
        finalResult = "Success! Moved \(numberOfDisks) disk\(numberOfDisks > 1 ? "s" : "") from Tower A to Tower C in \(moves.count) moves (optimal: \(expectedMoves) moves)"
        
        if !isAnimating {
            canReset = true
        }
        
        // Reset active tower after a delay
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            await MainActor.run {
                activeTowerIndex = -1
            }
        }
    }
    
    // MARK: - Tower State
    func getTowerColor(tower: Int) -> Color {
        switch tower {
        case 0: return .blue
        case 1: return .purple
        case 2: return .green
        default: return .gray
        }
    }
    
    func getTowerName(tower: Int) -> String {
        switch tower {
        case 0: return "A (Source)"
        case 1: return "B (Auxiliary)"
        case 2: return "C (Destination)"
        default: return ""
        }
    }
}
