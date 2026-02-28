//
//  SortingCategoryView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import SwiftUI

struct SortingAlgorithmsView: View {
    @StateObject private var viewModel = SortingAlgorithmsViewModel()
    
    var body: some View {
        AlgorithmCategoryListView(
            title: "Sorting Algorithms",
            subtitle: "Learn how data is organized step by step",
            algorithms: viewModel.algorithms,
            accentColor: .purple
        )
    }
}

#Preview {
    NavigationStack {
        SortingAlgorithmsView()
    }
}
