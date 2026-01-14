//
//  ArrayAlgorithmsViewModel.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import SwiftUI
import Combine

@MainActor
class ArrayAlgorithmsViewModel: ObservableObject {
    @Published var algorithms: [Algorithm] = Algorithm.arrayAlgorithms
}
