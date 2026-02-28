//
//  DPCategoryView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import SwiftUI

struct DPAlgorithmsView: View {
    @StateObject private var viewModel = DPAlgorithmsViewModel()
    
    var body: some View {
        AlgorithmCategoryListView(
            title: "Dynamic Programming",
            subtitle: "Learn optimal substructure and memoization",
            algorithms: viewModel.algorithms,
            accentColor: .yellow
        )
    }
}

#Preview {
    NavigationStack {
        DPAlgorithmsView()
    }
}
