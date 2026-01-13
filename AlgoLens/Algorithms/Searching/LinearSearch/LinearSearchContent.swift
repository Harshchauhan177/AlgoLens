//
//  LinearSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func linearSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Linear Search is the simplest searching algorithm that checks every element in the array sequentially until the target element is found or the end of the array is reached.",
            whenToUse: [
                "When the array is unsorted",
                "For small datasets",
                "When you need to find the first occurrence",
                "When simplicity is more important than speed"
            ],
            keyIdea: "Check each element one by one from left to right until you find the target or reach the end.",
            codeImplementations: [
                .pseudocode: """
                function linearSearch(array, target):
                    for i = 0 to length(array) - 1:
                        if array[i] == target:
                            return i
                    return -1 (not found)
                """,
                .c: """
                int linearSearch(int arr[], int n, int target) {
                    for (int i = 0; i < n; i++) {
                        if (arr[i] == target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """,
                .cpp: """
                int linearSearch(vector<int>& arr, int target) {
                    for (int i = 0; i < arr.size(); i++) {
                        if (arr[i] == target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """,
                .java: """
                public int linearSearch(int[] arr, int target) {
                    for (int i = 0; i < arr.length; i++) {
                        if (arr[i] == target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """,
                .python: """
                def linear_search(arr, target):
                    for i in range(len(arr)):
                        if arr[i] == target:
                            return i
                    return -1
                """,
                .swift: """
                func linearSearch(_ arr: [Int], target: Int) -> Int? {
                    for (index, value) in arr.enumerated() {
                        if value == target {
                            return index
                        }
                    }
                    return nil
                }
                """,
                .javascript: """
                function linearSearch(arr, target) {
                    for (let i = 0; i < arr.length; i++) {
                        if (arr[i] === target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [4, 7, 1, 9, 3, 6],
                target: 9,
                expectedOutput: "Found at index 3",
                explanation: "We check each element: 4, 7, 1, then find 9 at index 3."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Start at index 0 (first element)", type: .start),
                AlgorithmStep(title: "Compare", description: "Compare current element with target value", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match found, return the current index", type: .success),
                AlgorithmStep(title: "Move Next", description: "If not match, move to next element (i++)", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until target found or array ends", type: .process),
                AlgorithmStep(title: "Not Found", description: "If array ends without finding, return -1", type: .end)
            ]
        )
    }
}
