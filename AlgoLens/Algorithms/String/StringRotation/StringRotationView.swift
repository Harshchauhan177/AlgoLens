//
//  StringRotationView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct StringRotationVisualizationView: View {
    @StateObject private var viewModel = StringRotationViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.backgroundGradientStart, Theme.Colors.backgroundGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    VStack(spacing: Theme.Spacing.small) {
                        Text("String Rotation").font(Theme.Fonts.title).foregroundColor(Theme.Colors.primaryText)
                        Text("Check if one string is rotation of another").font(Theme.Fonts.subtitle).foregroundColor(Theme.Colors.secondaryText).multilineTextAlignment(.center).padding(.horizontal, Theme.Spacing.large)
                    }.padding(.top, Theme.Spacing.large)
                    
                    if !viewModel.isChecking {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Input Data").font(.system(size: 16, weight: .semibold, design: .rounded)).foregroundColor(Theme.Colors.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Original String").font(.system(size: 13, weight: .medium)).foregroundColor(Theme.Colors.secondaryText)
                                TextField("e.g., waterbottle", text: $viewModel.string1Input).font(.system(size: 15, design: .monospaced)).padding(Theme.Spacing.medium).background(Color.white.opacity(0.9)).cornerRadius(Theme.CornerRadius.medium).focused($isInputFocused)
                            }
                            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                                Text("Rotated String").font(.system(size: 13, weight: .medium)).foregroundColor(Theme.Colors.secondaryText)
                                TextField("e.g., erbottlewat", text: $viewModel.string2Input).font(.system(size: 15, design: .monospaced)).padding(Theme.Spacing.medium).background(Color.white.opacity(0.9)).cornerRadius(Theme.CornerRadius.medium).focused($isInputFocused)
                            }
                        }.padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    if viewModel.isCompleted {
                        VStack(spacing: Theme.Spacing.medium) {
                            Text("Result").font(.system(size: 16, weight: .semibold, design: .rounded)).foregroundColor(Theme.Colors.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Image(systemName: viewModel.isRotation ? "checkmark.circle.fill" : "xmark.circle.fill").font(.system(size: 40)).foregroundColor(viewModel.isRotation ? .green : .red)
                                VStack(alignment: .leading) {
                                    Text(viewModel.isRotation ? "✓ Is Rotation!" : "✗ Not Rotation").font(.system(size: 20, weight: .bold)).foregroundColor(viewModel.isRotation ? .green : .red)
                                    Text(viewModel.isRotation ? "Second string is rotation of first" : "Strings are not rotations").font(.system(size: 14, weight: .medium)).foregroundColor(Theme.Colors.secondaryText)
                                }
                            }.padding(Theme.Spacing.medium).background(Color.white.opacity(0.9)).cornerRadius(Theme.CornerRadius.medium)
                        }.padding(.horizontal, Theme.Spacing.large)
                    }
                    
                    VStack(spacing: Theme.Spacing.medium) {
                        HStack(spacing: Theme.Spacing.medium) {
                            EnhancedControlButton(title: "Check", icon: "play.fill", color: .green, isEnabled: viewModel.canCheck) { isInputFocused = false; viewModel.check() }
                            EnhancedControlButton(title: "Reset", icon: "arrow.counterclockwise", color: .orange, isEnabled: viewModel.canReset) { viewModel.reset() }
                        }
                        if viewModel.isCompleted {
                            Button(action: { showQuiz = true }) {
                                HStack(spacing: Theme.Spacing.small) { Image(systemName: "questionmark.circle.fill"); Text("Take Quiz") }.foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, Theme.Spacing.medium + 2).background(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing)).cornerRadius(Theme.CornerRadius.large)
                            }
                        }
                    }.padding(.horizontal, Theme.Spacing.large).padding(.bottom, Theme.Spacing.large)
                }
            }
        }.navigationBarTitleDisplayMode(.inline).navigationDestination(isPresented: $showQuiz) { QuizView(algorithm: Algorithm(name: "String Rotation", description: "Check rotation", icon: "arrow.clockwise.circle.fill", complexity: Algorithm.Complexity(time: "O(n)", space: "O(n)"), category: AlgorithmCategory.allCategories[3])) }
    }
}

#Preview { NavigationStack { StringRotationVisualizationView() } }
