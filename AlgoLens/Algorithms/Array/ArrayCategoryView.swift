//
//  ArrayAlgorithmsView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct ArrayAlgorithmsView: View {
    @StateObject private var viewModel = ArrayAlgorithmsViewModel()
    
    var body: some View {
        AlgorithmCategoryListView(
            title: "Array Algorithms",
            subtitle: "Master essential array manipulation techniques",
            algorithms: viewModel.algorithms,
            accentColor: .green
        )
    }
}

#Preview {
    NavigationStack {
        ArrayAlgorithmsView()
    }
}
