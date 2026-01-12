//
//  ExponentialSearchViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 12/01/26.
//

import Foundation
import Combine

@MainActor
class ExponentialSearchViewModel: ObservableObject {
    @Published var array: [Int] = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
    @Published var target: Int = 13
    @Published var isSearching = false
    
    // TODO: Implement Exponential Search visualization logic
}
