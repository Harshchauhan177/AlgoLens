//
//  ExponentialSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func exponentialSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Exponential Search finds the range where the target element exists by exponentially increasing the index, then performs binary search in that range.",
            whenToUse: [
                "When array is unbounded or very large",
                "When target is likely near the beginning",
                "For sorted arrays",
                "When you want to combine linear and binary search benefits"
            ],
            keyIdea: "Find the range [2^k-1, 2^k] containing the target by doubling the index, then use binary search.",
            codeImplementations: [
                .pseudocode: """
                function exponentialSearch(array, target):
                    if array[0] == target:
                        return 0
                    i = 1
                    n = length(array)
                    while i < n and array[i] <= target:
                        i = i * 2
                    return binarySearch(array, i/2, min(i, n-1), target)
                """,
                .c: """
                int binarySearch(int arr[], int left, int right, int target) {
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target) return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                
                int exponentialSearch(int arr[], int n, int target) {
                    if (arr[0] == target)
                        return 0;
                    int i = 1;
                    while (i < n && arr[i] <= target)
                        i = i * 2;
                    return binarySearch(arr, i/2, (i < n) ? i : n-1, target);
                }
                """,
                .cpp: """
                int binarySearch(vector<int>& arr, int left, int right, int target) {
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target) return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                
                int exponentialSearch(vector<int>& arr, int target) {
                    if (arr[0] == target)
                        return 0;
                    int i = 1;
                    while (i < arr.size() && arr[i] <= target)
                        i = i * 2;
                    return binarySearch(arr, i/2, min((int)i, (int)arr.size()-1), target);
                }
                """,
                .java: """
                private int binarySearch(int[] arr, int left, int right, int target) {
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target) return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                
                public int exponentialSearch(int[] arr, int target) {
                    if (arr[0] == target)
                        return 0;
                    int i = 1;
                    while (i < arr.length && arr[i] <= target)
                        i = i * 2;
                    return binarySearch(arr, i/2, Math.min(i, arr.length-1), target);
                }
                """,
                .python: """
                def binary_search(arr, left, right, target):
                    while left <= right:
                        mid = left + (right - left) // 2
                        if arr[mid] == target:
                            return mid
                        elif arr[mid] < target:
                            left = mid + 1
                        else:
                            right = mid - 1
                    return -1
                
                def exponential_search(arr, target):
                    if arr[0] == target:
                        return 0
                    i = 1
                    while i < len(arr) and arr[i] <= target:
                        i = i * 2
                    return binary_search(arr, i//2, min(i, len(arr)-1), target)
                """,
                .swift: """
                func binarySearch(_ arr: [Int], left: Int, right: Int, target: Int) -> Int? {
                    var left = left, right = right
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
                
                func exponentialSearch(_ arr: [Int], target: Int) -> Int? {
                    if arr[0] == target {
                        return 0
                    }
                    var i = 1
                    while i < arr.count && arr[i] <= target {
                        i = i * 2
                    }
                    return binarySearch(arr, left: i/2, right: min(i, arr.count-1), target: target)
                }
                """,
                .javascript: """
                function binarySearch(arr, left, right, target) {
                    while (left <= right) {
                        const mid = Math.floor(left + (right - left) / 2);
                        if (arr[mid] === target) return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                
                function exponentialSearch(arr, target) {
                    if (arr[0] === target)
                        return 0;
                    let i = 1;
                    while (i < arr.length && arr[i] <= target)
                        i = i * 2;
                    return binarySearch(arr, i/2, Math.min(i, arr.length-1), target);
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Check indices 1, 2, 4. Find range [2,4], then binary search finds 6."
            ),
            steps: [
                AlgorithmStep(title: "Check First", description: "Check if first element is target", type: .start),
                AlgorithmStep(title: "Initialize", description: "Start with i = 1", type: .process),
                AlgorithmStep(title: "Double Index", description: "Double i until array[i] > target or end", type: .process),
                AlgorithmStep(title: "Find Range", description: "Identified range is [i/2, i]", type: .decision),
                AlgorithmStep(title: "Binary Search", description: "Perform binary search in this range", type: .process),
                AlgorithmStep(title: "Result", description: "Return result from binary search", type: .end)
            ]
        )
    }
}
