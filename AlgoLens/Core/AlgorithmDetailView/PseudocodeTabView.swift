//
//  PseudocodeTabView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

// MARK: - Pseudocode Tab (Enhanced with Multi-Language Support)
struct PseudocodeTabView: View {
    let content: AlgorithmContent
    @State private var selectedLanguage: ProgrammingLanguage = .pseudocode
    @State private var showCopiedAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large + 4) {
            // Header with Icon
            HStack(spacing: Theme.Spacing.small + 2) {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundColor(.purple)
                    .font(.system(size: 20, weight: .semibold))
                Text("Code Implementation")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
            }
            .padding(.horizontal, 2)
            
            // Language Selector with Modern Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ProgrammingLanguage.allCases, id: \.self) { language in
                        LanguagePillButton(
                            language: language,
                            isSelected: selectedLanguage == language
                        ) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedLanguage = language
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            
            // Premium Code Editor Container
            VStack(alignment: .leading, spacing: 0) {
                // Editor Header Bar (macOS-style window controls)
                HStack(spacing: 0) {
                    // Left: Window Controls (subtle macOS-style dots)
                    HStack(spacing: 7) {
                        Circle()
                            .fill(Color.red.opacity(0.75))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.yellow.opacity(0.75))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(Color.green.opacity(0.75))
                            .frame(width: 10, height: 10)
                    }
                    .padding(.leading, Theme.Spacing.medium + 2)
                    
                    Spacer()
                    
                    // Center: Language Label
                    Text(selectedLanguage.displayName)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(7)
                    
                    Spacer()
                    
                    // Right: Copy Button
                    Button(action: {
                        UIPasteboard.general.string = content.code(for: selectedLanguage)
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showCopiedAlert = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showCopiedAlert = false
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: showCopiedAlert ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 13, weight: .semibold))
                                .contentTransition(.symbolEffect(.replace))
                            Text(showCopiedAlert ? "Copied!" : "Copy")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(showCopiedAlert ? .green : .blue)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 7)
                        .background(
                            (showCopiedAlert ? Color.green.opacity(0.1) : Color.blue.opacity(0.08))
                        )
                        .cornerRadius(8)
                    }
                    .padding(.trailing, Theme.Spacing.medium + 2)
                }
                .frame(height: 44)
                .background(
                    LinearGradient(
                        colors: [
                            Color(white: 0.96),
                            Color(white: 0.94)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Divider()
                    .background(Color.gray.opacity(0.2))
                
                // Code Content Area with Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: true) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(content.code(for: selectedLanguage))
                            .font(.system(size: 15, weight: .regular, design: .monospaced))
                            .foregroundColor(Theme.Colors.primaryText)
                            .lineSpacing(7)
                            .padding(Theme.Spacing.large)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 220)
                .background(Color(white: 0.99))
            }
            .background(Color(white: 0.99))
            .cornerRadius(Theme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.25),
                                Color.blue.opacity(0.25),
                                Color.purple.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.purple.opacity(0.1), radius: 16, x: 0, y: 8)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Implementation Info Card
            HStack(alignment: .top, spacing: Theme.Spacing.medium) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue.opacity(0.8))
                    .font(.system(size: 20))
                    .padding(.top, 1)
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Implementation Guide")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text("This implementation demonstrates the core logic of the algorithm. You can adapt it to your specific use case and language preferences.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.Colors.secondaryText)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(Theme.Spacing.medium + 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.04))
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Color.blue.opacity(0.12), lineWidth: 1)
            )
        }
        .padding(Theme.Spacing.large)
        .padding(.bottom, Theme.Spacing.extraLarge)
    }
}

// MARK: - Language Pill Button (Enhanced)
struct LanguagePillButton: View {
    let language: ProgrammingLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                // Language Icon
                if let icon = language.icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                }
                
                Text(language.displayName)
                    .font(.system(size: 14, weight: isSelected ? .bold : .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : Theme.Colors.primaryText.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.95),
                                Color.blue.opacity(0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.white.opacity(0.9)
                    }
                }
            )
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isSelected ? Color.clear : Color.gray.opacity(0.2),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: isSelected ? Color.purple.opacity(0.3) : Color.black.opacity(0.06),
                radius: isSelected ? 10 : 4,
                x: 0,
                y: isSelected ? 5 : 2
            )
        }
        .scaleEffect(isSelected ? 1.02 : 0.98)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
    }
}
