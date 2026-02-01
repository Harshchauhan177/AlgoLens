//
//  HowItWorksTabView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

// MARK: - How It Works Tab (Enhanced with Visual Timeline)
struct HowItWorksTabView: View {
    let content: AlgorithmContent
    @State private var appearedSteps: Set<Int> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium + 2) {
            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: "list.number")
                    .foregroundColor(.orange)
                    .font(.system(size: 20, weight: .semibold))
                Text("Step-by-Step Process")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            .padding(.bottom, Theme.Spacing.small)
            
            // Timeline Steps
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(content.steps.enumerated()), id: \.offset) { index, step in
                    TimelineStepCard(
                        number: index + 1,
                        step: step,
                        isFirst: index == 0,
                        isLast: index == content.steps.count - 1
                    )
                    .opacity(appearedSteps.contains(index) ? 1 : 0)
                    .offset(y: appearedSteps.contains(index) ? 0 : 20)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.1)) {
                            _ = appearedSteps.insert(index)
                        }
                    }
                }
            }
            
            // Learning Tip Card
            VStack(alignment: .leading, spacing: Theme.Spacing.small + 2) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18))
                    Text("Pro Tip")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                }
                
                Text(getLearningTip(for: content.algorithm.name))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineSpacing(4)
            }
            .padding(Theme.Spacing.medium + 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color.yellow.opacity(0.08), Color.orange.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Color.yellow.opacity(0.3), lineWidth: 1.5)
            )
            .shadow(color: Color.orange.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
    
    // Helper function to get learning tips
    private func getLearningTip(for algorithmName: String) -> String {
        switch algorithmName {
        case "Linear Search":
            return "Linear Search checks every element, so performance depends on array size. Best for small or unsorted datasets where simplicity matters."
        case "Binary Search":
            return "Binary Search requires a sorted array but is incredibly fast (O(log n)). It's like finding a name in a phone book by opening it in the middle!"
        case "Jump Search":
            return "Jump Search is a sweet spot between Linear and Binary Search. It works well when you want better performance than linear but can't use binary search."
        case "Interpolation Search":
            return "Interpolation Search shines with uniformly distributed data. It's like guessing where 'Smith' would be in a phone book—closer to the end than the beginning."
        case "Exponential Search":
            return "Exponential Search is perfect when you expect the target to be near the beginning of a large array. It doubles the search range until it finds the right spot."
        case "Fibonacci Search":
            return "Fibonacci Search uses Fibonacci numbers to divide the array. It's especially useful when division operations are expensive on your hardware."
        default:
            return "Understanding how each step flows helps you debug and optimize your code. Practice tracing through with different inputs!"
        }
    }
}

// MARK: - Timeline Step Card with Visual Connectors
struct TimelineStepCard: View {
    let number: Int
    let step: AlgorithmContent.AlgorithmStep
    let isFirst: Bool
    let isLast: Bool
    
    var stepColor: Color {
        switch step.type {
        case .start: return .green
        case .process: return .blue
        case .decision: return .purple
        case .success: return .orange
        case .end: return .red
        }
    }
    
    var stepIcon: String {
        switch step.type {
        case .start: return "play.circle.fill"
        case .process: return "arrow.right.circle.fill"
        case .decision: return "questionmark.diamond.fill"
        case .success: return "checkmark.seal.fill"
        case .end: return "flag.checkered"
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Timeline Connector Column
            VStack(spacing: 0) {
                // Top Line
                if !isFirst {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 16)
                }
                
                // Step Badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [stepColor.opacity(0.2), stepColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Circle()
                        .stroke(stepColor.opacity(0.4), lineWidth: 2)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: stepIcon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(stepColor)
                }
                
                // Bottom Line
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2)
                        .frame(minHeight: 20)
                }
            }
            .frame(width: 44)
            .padding(.trailing, Theme.Spacing.medium)
            
            // Content Card
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center) {
                    Text(step.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Spacer()
                    
                    // Step Number Badge
                    Text("\(number)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(stepColor)
                        .frame(width: 24, height: 24)
                        .background(stepColor.opacity(0.15))
                        .clipShape(Circle())
                }
                
                Text(step.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineSpacing(3)
            }
            .padding(Theme.Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.85))
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(stepColor.opacity(0.15), lineWidth: 1.5)
            )
        }
        .padding(.bottom, isLast ? 0 : Theme.Spacing.small)
    }
}
