//
//  TowerOfHanoiViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class TowerOfHanoiViewModel: ObservableObject {
    @Published var towers: [[Int]] = [[], [], []]
    @Published var moves: [String] = []
    @Published var currentStep = 0
    @Published var isAnimating = false
    @Published var numberOfDisks = 3
    @Published var animationSpeed: Double = 1.0
    
    init() {
        setupTowers()
    }
    
    func setupTowers() {
        towers = [[], [], []]
        towers[0] = Array((1...numberOfDisks).reversed())
        moves = []
        currentStep = 0
        generateMoves()
    }
    
    private func generateMoves() {
        moves = []
        solveHanoi(n: numberOfDisks, from: 0, to: 2, aux: 1)
    }
    
    private func solveHanoi(n: Int, from: Int, to: Int, aux: Int) {
        if n == 1 {
            moves.append("Move disk \(n) from Tower \(Character(UnicodeScalar(65 + from)!)) to Tower \(Character(UnicodeScalar(65 + to)!))")
            return
        }
        
        solveHanoi(n: n - 1, from: from, to: aux, aux: to)
        moves.append("Move disk \(n) from Tower \(Character(UnicodeScalar(65 + from)!)) to Tower \(Character(UnicodeScalar(65 + to)!))")
        solveHanoi(n: n - 1, from: aux, to: to, aux: from)
    }
    
    func nextStep() {
        guard currentStep < moves.count else { return }
        executeMove(at: currentStep)
        currentStep += 1
    }
    
    func previousStep() {
        guard currentStep > 0 else { return }
        currentStep -= 1
        undoMove(at: currentStep)
    }
    
    func reset() {
        setupTowers()
    }
    
    private func executeMove(at index: Int) {
        let move = moves[index]
        let components = move.components(separatedBy: " ")
        guard components.count >= 8 else { return }
        
        let fromTower = Int(components[5].unicodeScalars.first!.value - 65)
        let toTower = Int(components[8].unicodeScalars.first!.value - 65)
        
        if let disk = towers[fromTower].popLast() {
            towers[toTower].append(disk)
        }
    }
    
    private func undoMove(at index: Int) {
        let move = moves[index]
        let components = move.components(separatedBy: " ")
        guard components.count >= 8 else { return }
        
        let fromTower = Int(components[5].unicodeScalars.first!.value - 65)
        let toTower = Int(components[8].unicodeScalars.first!.value - 65)
        
        if let disk = towers[toTower].popLast() {
            towers[fromTower].append(disk)
        }
    }
    
    func autoPlay() {
        isAnimating = true
        Task {
            while currentStep < moves.count && isAnimating {
                nextStep()
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 / animationSpeed))
            }
            isAnimating = false
        }
    }
    
    func stopAnimation() {
        isAnimating = false
    }
}
