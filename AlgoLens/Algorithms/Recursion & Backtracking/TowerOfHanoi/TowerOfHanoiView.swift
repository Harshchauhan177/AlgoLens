//
//  TowerOfHanoiView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct TowerOfHanoiView: View {
    @StateObject private var viewModel = TowerOfHanoiViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Towers Visualization
            HStack(spacing: 40) {
                ForEach(0..<3) { towerIndex in
                    TowerView(disks: viewModel.towers[towerIndex], towerName: String(UnicodeScalar(65 + towerIndex)!))
                }
            }
            .frame(height: 300)
            .padding()
            
            // Move Counter
            Text("Move \(viewModel.currentStep) of \(viewModel.moves.count)")
                .font(.headline)
            
            // Current Move Display
            if viewModel.currentStep > 0 && viewModel.currentStep <= viewModel.moves.count {
                Text(viewModel.moves[viewModel.currentStep - 1])
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Controls
            HStack(spacing: 20) {
                Button(action: viewModel.previousStep) {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.currentStep == 0)
                
                Button(action: {
                    if viewModel.isAnimating {
                        viewModel.stopAnimation()
                    } else {
                        viewModel.autoPlay()
                    }
                }) {
                    Image(systemName: viewModel.isAnimating ? "pause.fill" : "play.fill")
                        .frame(width: 44, height: 44)
                }
                
                Button(action: viewModel.nextStep) {
                    Image(systemName: "chevron.right")
                        .frame(width: 44, height: 44)
                }
                .disabled(viewModel.currentStep >= viewModel.moves.count)
                
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

struct TowerView: View {
    let disks: [Int]
    let towerName: String
    
    var body: some View {
        VStack {
            Text("Tower \(towerName)")
                .font(.headline)
            
            ZStack(alignment: .bottom) {
                // Tower Rod
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 8, height: 200)
                
                // Base
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 120, height: 8)
                    .offset(y: 4)
                
                // Disks
                VStack(spacing: 2) {
                    ForEach(disks, id: \.self) { disk in
                        DiskView(size: disk)
                    }
                }
            }
        }
    }
}

struct DiskView: View {
    let size: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.blue.opacity(Double(size) * 0.15 + 0.3))
            .frame(width: CGFloat(size * 30), height: 20)
            .overlay(
                Text("\(size)")
                    .font(.caption)
                    .foregroundColor(.white)
            )
    }
}

#Preview {
    TowerOfHanoiView()
}
