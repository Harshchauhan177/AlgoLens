//
//  RecursionCategoryView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import SwiftUI

struct RecursionCategoryView: View {
    @StateObject private var viewModel = RecursionAlgorithmsViewModel()
    
    var body: some View {
        AlgorithmCategoryListView(
            title: "Recursion & Backtracking",
            subtitle: "Master recursive problem-solving techniques",
            algorithms: viewModel.algorithms,
            accentColor: .red
        )
    }
}

#Preview {
    NavigationStack {
        RecursionCategoryView()
    }
}
