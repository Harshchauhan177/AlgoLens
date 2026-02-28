//
//  SearchingAlgorithmsView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct SearchingAlgorithmsView: View {
    @StateObject private var viewModel = SearchingAlgorithmsViewModel()
    
    var body: some View {
        AlgorithmCategoryListView(
            title: "Searching Algorithms",
            subtitle: "Understand how data is searched step by step",
            algorithms: viewModel.algorithms,
            accentColor: .blue
        )
    }
}

#Preview {
    NavigationStack {
        SearchingAlgorithmsView()
    }
}
