//
//  AlgorithmContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/25.
//

import Foundation

// MARK: - Programming Language Enum
enum ProgrammingLanguage: String, CaseIterable {
    case pseudocode = "Pseudocode"
    case c = "C"
    case cpp = "C++"
    case java = "Java"
    case python = "Python"
    case swift = "Swift"
    case javascript = "JavaScript"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String? {
        switch self {
        case .pseudocode:
            return "doc.text"
        case .c:
            return "c.circle"
        case .cpp:
            return "c.circle.fill"
        case .java:
            return "cup.and.saucer"
        case .python:
            return "snake"
        case .swift:
            return "swift"
        case .javascript:
            return "j.circle"
        }
    }
}

// MARK: - Algorithm Content Model
struct AlgorithmContent {
    let algorithm: Algorithm
    let explanation: String
    let whenToUse: [String]
    let keyIdea: String
    let codeImplementations: [ProgrammingLanguage: String]
    let example: AlgorithmExample
    let steps: [AlgorithmStep]
    
    struct AlgorithmExample {
        let inputArray: [Int]
        let target: Int
        let expectedOutput: String
        let explanation: String
    }
    
    struct AlgorithmStep {
        let title: String
        let description: String
        let type: StepType
        
        enum StepType {
            case start
            case process
            case decision
            case success
            case end
        }
    }
    
    // Helper to get code for a language
    func code(for language: ProgrammingLanguage) -> String {
        return codeImplementations[language] ?? codeImplementations[.pseudocode] ?? "Code not available"
    }
}

// MARK: - Content Data
extension AlgorithmContent {
    static func content(for algorithm: Algorithm) -> AlgorithmContent {
        // Searching Algorithms
        switch algorithm.name {
        case "Linear Search":
            return linearSearchContent(algorithm: algorithm)
        case "Binary Search":
            return binarySearchContent(algorithm: algorithm)
        case "Jump Search":
            return jumpSearchContent(algorithm: algorithm)
        case "Interpolation Search":
            return interpolationSearchContent(algorithm: algorithm)
        case "Exponential Search":
            return exponentialSearchContent(algorithm: algorithm)
        case "Fibonacci Search":
            return fibonacciSearchContent(algorithm: algorithm)
        
        // Sorting Algorithms
        case "Bubble Sort":
            return bubbleSortContent(algorithm: algorithm)
        case "Selection Sort":
            return selectionSortContent(algorithm: algorithm)
        case "Insertion Sort":
            return insertionSortContent(algorithm: algorithm)
        case "Merge Sort":
            return mergeSortContent(algorithm: algorithm)
        case "Quick Sort":
            return quickSortContent(algorithm: algorithm)
        case "Heap Sort":
            return heapSortContent(algorithm: algorithm)
        case "Counting Sort":
            return countingSortContent(algorithm: algorithm)
            
        default:
            return defaultContent(algorithm: algorithm)
        }
    }
    
    // MARK: - Default Content
    private static func defaultContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "This algorithm helps you search or sort data efficiently.",
            whenToUse: [
                "Based on your data structure",
                "Depending on performance needs",
                "Consider time and space complexity"
            ],
            keyIdea: "Understanding the algorithm concept is key to using it effectively.",
            codeImplementations: [
                .pseudocode: """
                function algorithm(input):
                    // Algorithm steps here
                    return result
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 2, 3, 4, 5],
                target: 3,
                expectedOutput: "Found",
                explanation: "Example explanation will be shown here."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Initialize variables", type: .start),
                AlgorithmStep(title: "Process", description: "Process data", type: .process),
                AlgorithmStep(title: "Return", description: "Return result", type: .end)
            ]
        )
    }
}
