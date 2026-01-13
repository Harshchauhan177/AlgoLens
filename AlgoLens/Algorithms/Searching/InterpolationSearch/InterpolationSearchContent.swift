//
//  InterpolationSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func interpolationSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Interpolation Search improves Binary Search by estimating the position of the target based on its value, similar to how humans search in a dictionary.",
            whenToUse: [
                "When array is sorted and uniformly distributed",
                "For large datasets with even distribution",
                "When data follows a predictable pattern",
                "Better than binary for uniform data"
            ],
            keyIdea: "Estimate the likely position of the target using interpolation formula based on value distribution.",
            codeImplementations: [
                .pseudocode: """
                function interpolationSearch(array, target):
                    low = 0, high = length(array) - 1
                    while low <= high and target >= array[low] and target <= array[high]:
                        if low == high:
                            if array[low] == target:
                                return low
                            return -1
                        pos = low + ((target - array[low]) * (high - low)) / (array[high] - array[low])
                        if array[pos] == target:
                            return pos
                        if array[pos] < target:
                            low = pos + 1
                        else:
                            high = pos - 1
                    return -1
                """,
                .c: """
                int interpolationSearch(int arr[], int n, int target) {
                    int low = 0, high = n - 1;
                    while (low <= high && target >= arr[low] && target <= arr[high]) {
                        if (low == high) {
                            if (arr[low] == target) return low;
                            return -1;
                        }
                        int pos = low + (((double)(high - low) / (arr[high] - arr[low])) * (target - arr[low]));
                        if (arr[pos] == target)
                            return pos;
                        if (arr[pos] < target)
                            low = pos + 1;
                        else
                            high = pos - 1;
                    }
                    return -1;
                }
                """,
                .cpp: """
                int interpolationSearch(vector<int>& arr, int target) {
                    int low = 0, high = arr.size() - 1;
                    while (low <= high && target >= arr[low] && target <= arr[high]) {
                        if (low == high) {
                            if (arr[low] == target) return low;
                            return -1;
                        }
                        int pos = low + (((double)(high - low) / (arr[high] - arr[low])) * (target - arr[low]));
                        if (arr[pos] == target)
                            return pos;
                        if (arr[pos] < target)
                            low = pos + 1;
                        else
                            high = pos - 1;
                    }
                    return -1;
                }
                """,
                .java: """
                public int interpolationSearch(int[] arr, int target) {
                    int low = 0, high = arr.length - 1;
                    while (low <= high && target >= arr[low] && target <= arr[high]) {
                        if (low == high) {
                            if (arr[low] == target) return low;
                            return -1;
                        }
                        int pos = low + (int)(((double)(high - low) / (arr[high] - arr[low])) * (target - arr[low]));
                        if (arr[pos] == target)
                            return pos;
                        if (arr[pos] < target)
                            low = pos + 1;
                        else
                            high = pos - 1;
                    }
                    return -1;
                }
                """,
                .python: """
                def interpolation_search(arr, target):
                    low, high = 0, len(arr) - 1
                    while low <= high and target >= arr[low] and target <= arr[high]:
                        if low == high:
                            if arr[low] == target:
                                return low
                            return -1
                        pos = low + int(((target - arr[low]) * (high - low)) / (arr[high] - arr[low]))
                        if arr[pos] == target:
                            return pos
                        if arr[pos] < target:
                            low = pos + 1
                        else:
                            high = pos - 1
                    return -1
                """,
                .swift: """
                func interpolationSearch(_ arr: [Int], target: Int) -> Int? {
                    var low = 0, high = arr.count - 1
                    while low <= high && target >= arr[low] && target <= arr[high] {
                        if low == high {
                            if arr[low] == target { return low }
                            return nil
                        }
                        let pos = low + Int((Double(target - arr[low]) / Double(arr[high] - arr[low])) * Double(high - low))
                        if arr[pos] == target {
                            return pos
                        } else if arr[pos] < target {
                            low = pos + 1
                        } else {
                            high = pos - 1
                        }
                    }
                    return nil
                }
                """,
                .javascript: """
                function interpolationSearch(arr, target) {
                    let low = 0, high = arr.length - 1;
                    while (low <= high && target >= arr[low] && target <= arr[high]) {
                        if (low === high) {
                            if (arr[low] === target) return low;
                            return -1;
                        }
                        const pos = low + Math.floor(((target - arr[low]) * (high - low)) / (arr[high] - arr[low]));
                        if (arr[pos] === target)
                            return pos;
                        if (arr[pos] < target)
                            low = pos + 1;
                        else
                            high = pos - 1;
                    }
                    return -1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Estimate position based on value. Target 6 is likely near middle-right."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set low and high pointers", type: .start),
                AlgorithmStep(title: "Estimate Position", description: "Calculate estimated position using interpolation", type: .process),
                AlgorithmStep(title: "Compare", description: "Compare element at estimated position", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match, return position", type: .success),
                AlgorithmStep(title: "Search Left", description: "If target is smaller, search left portion", type: .process),
                AlgorithmStep(title: "Search Right", description: "If target is larger, search right portion", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until found or range exhausted", type: .end)
            ]
        )
    }
}
