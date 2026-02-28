//
//  StringAlgorithmsView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI

struct StringAlgorithmsView: View {
    @StateObject private var viewModel = StringAlgorithmsViewModel()
    
    var body: some View {
        AlgorithmCategoryListView(
            title: "String Algorithms",
            subtitle: "Master pattern matching and string manipulation",
            algorithms: viewModel.algorithms,
            accentColor: .orange
        )
    }
}

#Preview {
    NavigationStack {
        StringAlgorithmsView()
    }
}
