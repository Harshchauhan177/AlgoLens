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
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.15),
                                categoryColor.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                
                Image(systemName: category.icon)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(categoryColor)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 8) {
                Text(category.name)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                
                Text(category.description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }
            
            Spacer()
            
            // "Explore" indicator
            HStack {
                Text("Explore")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(categoryColor)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(categoryColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            ZStack {
                Color.white.opacity(0.95)
                
                // Subtle gradient overlay
                LinearGradient(
                    colors: [
                        categoryColor.opacity(0.03),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            categoryColor.opacity(0.2),
                            categoryColor.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: categoryColor.opacity(0.15), radius: 12, x: 0, y: 6)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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
