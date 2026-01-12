//
//  AlgorithmDetailViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI
import Combine

@MainActor
class AlgorithmDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTab: DetailTab = .explanation
    @Published var content: AlgorithmContent
    @Published var showVisualization: Bool = false
    
    let algorithm: Algorithm
    
    // MARK: - Tab Enum
    enum DetailTab: String, CaseIterable {
        case explanation = "Explanation"
        case pseudocode = "Pseudocode"
        case example = "Example"
        case howItWorks = "How It Works"
        
        var icon: String {
            switch self {
            case .explanation:
                return "text.alignleft"
            case .pseudocode:
                return "chevron.left.forwardslash.chevron.right"
            case .example:
                return "lightbulb.fill"
            case .howItWorks:
                return "list.number"
            }
        }
    }
    
    // MARK: - Initialization
    init(algorithm: Algorithm) {
        self.algorithm = algorithm
        self.content = AlgorithmContent.content(for: algorithm)
    }
    
    // MARK: - Actions
    func selectTab(_ tab: DetailTab) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedTab = tab
        }
    }
    
    func startVisualization() {
        showVisualization = true
    }
}
