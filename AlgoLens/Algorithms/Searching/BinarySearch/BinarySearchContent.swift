//
//  BinarySearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func binarySearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Binary Search is an efficient algorithm that finds a target value in a sorted array by repeatedly dividing the search interval in half.",
            whenToUse: [
                "When the array is sorted",
                "For large datasets",
                "When you need fast search performance",
                "When random access is available"
            ],
            keyIdea: "Divide the search space in half with each comparison, eliminating half of the remaining elements.",
            codeImplementations: [
                .pseudocode: """
                function binarySearch(array, target):
                    left = 0, right = length(array) - 1
                    while left <= right:
                        mid = (left + right) / 2
                        if array[mid] == target:
                            return mid
                        else if array[mid] < target:
                            left = mid + 1
                        else:
                            right = mid - 1
                    return -1 (not found)
                """,
                .c: """
                int binarySearch(int arr[], int n, int target) {
                    int left = 0, right = n - 1;
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """,
                .cpp: """
                int binarySearch(vector<int>& arr, int target) {
                    int left = 0, right = arr.size() - 1;
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """,
                .java: """
                public int binarySearch(int[] arr, int target) {
                    int left = 0, right = arr.length - 1;
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """,
                .python: """
                def binary_search(arr, target):
                    left, right = 0, len(arr) - 1
                    while left <= right:
                        mid = (left + right) // 2
                        if arr[mid] == target:
                            return mid
                        elif arr[mid] < target:
                            left = mid + 1
                        else:
                            right = mid - 1
                    return -1
                """,
                .swift: """
                func binarySearch(_ arr: [Int], target: Int) -> Int? {
                    var left = 0, right = arr.count - 1
                    while left <= right {
                        let mid = left + (right - left) / 2
                        if arr[mid] == target {
                            return mid
                        } else if arr[mid] < target {
                            left = mid + 1
                        } else {
                            right = mid - 1
                        }
                    }
                    return nil
                }
                """,
                .javascript: """
                function binarySearch(arr, target) {
                    let left = 0, right = arr.length - 1;
                    while (left <= right) {
                        const mid = Math.floor((left + right) / 2);
                        if (arr[mid] === target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Check middle (4), target is larger. Check right half's middle (7), target is smaller. Find 6 at index 3."
            ),
            steps: [
                AlgorithmStep(title: "Initialize Pointers", description: "Set left pointer to start, right to end", type: .start),
                AlgorithmStep(title: "Find Middle", description: "Calculate middle index: mid = (left + right) / 2", type: .process),
                AlgorithmStep(title: "Compare", description: "Compare middle element with target", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match, return middle index", type: .success),
                AlgorithmStep(title: "Search Left", description: "If target is smaller, search left half (right = mid - 1)", type: .process),
                AlgorithmStep(title: "Search Right", description: "If target is larger, search right half (left = mid + 1)", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until found or pointers cross", type: .end)
            ]
        )
    }
}
