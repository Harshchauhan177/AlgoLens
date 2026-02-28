//
//  CategoryCardView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import SwiftUI

// MARK: - Enhanced Category Card with Premium Design
struct CategoryCardView: View {
    let category: AlgorithmCategory
    @State private var shimmerOffset: CGFloat = -200
    @State private var iconBounce = false
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Top Row: Icon + Decorative dots
            HStack(alignment: .top) {
                // Animated icon with layered rings
                ZStack {
                    // Rotating outer ring
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    categoryColor.opacity(0.4),
                                    categoryColor.opacity(0.1),
                                    categoryColor.opacity(0.3),
                                    categoryColor.opacity(0.05),
                                    categoryColor.opacity(0.4)
                                ],
                                center: .center
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(appeared ? 360 : 0))
                        .animation(
                            .linear(duration: 12).repeatForever(autoreverses: false),
                            value: appeared
                        )
                    
                    // Inner glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    categoryColor.opacity(0.22),
                                    categoryColor.opacity(0.06)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 32
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.65)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(iconBounce ? 1.12 : 1.0)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.5),
                            value: iconBounce
                        )
                }
                .onAppear {
                    appeared = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        iconBounce = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            iconBounce = false
                        }
                    }
                }
                
                Spacer()
                
                // Decorative floating dots
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(categoryColor.opacity(0.15 + Double(i) * 0.1))
                            .frame(width: 6 - CGFloat(i), height: 6 - CGFloat(i))
                    }
                }
                .padding(.top, 8)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 8) {
                Text(category.name)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                
                Text(category.description)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer(minLength: 0)
            
            // Filled capsule "Explore" CTA
            HStack(spacing: 0) {
                HStack(spacing: 7) {
                    Text("Explore")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .heavy))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: categoryColor.opacity(0.35), radius: 8, x: 0, y: 4)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ZStack {
                // Frosted glass base
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)
                
                // Subtle gradient tint
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.05),
                                Color.clear,
                                categoryColor.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Decorative blob top-right
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [categoryColor.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 70
                        )
                    )
                    .frame(width: 120, height: 120)
                    .offset(x: 60, y: -50)
                
                // Decorative blob bottom-left
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [categoryColor.opacity(0.06), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 80, height: 80)
                    .offset(x: -40, y: 60)
                
                // Shimmer sweep
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.06),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerOffset)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 3)
                            .repeatForever(autoreverses: false)
                            .delay(1)
                        ) {
                            shimmerOffset = 300
                        }
                    }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    LinearGradient(
                        colors: [
                            categoryColor.opacity(0.35),
                            categoryColor.opacity(0.08),
                            Color.white.opacity(0.15),
                            categoryColor.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
        .shadow(color: categoryColor.opacity(0.18), radius: 20, x: 0, y: 10)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    private var categoryColor: Color {
        switch category.color {
        case .blue: return .blue
        case .purple: return .purple
        case .green: return .green
        case .orange: return .orange
        case .red: return .red
        case .pink: return .pink
        case .teal: return .teal
        case .indigo: return .indigo
        case .mint: return .mint
        case .cyan: return .cyan
        case .yellow: return .yellow
        case .brown: return .brown
        }
    }
}
