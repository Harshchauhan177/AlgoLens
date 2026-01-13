//
//  FibonacciSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func fibonacciSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Fibonacci Search divides the array into unequal parts using Fibonacci numbers, similar to binary search but with Fibonacci intervals.",
            whenToUse: [
                "When array is sorted",
                "For large datasets",
                "When division operation is costly",
                "As an alternative to binary search"
            ],
            keyIdea: "Use Fibonacci numbers to divide the array and narrow down the search range without division operations.",
            codeImplementations: [
                .pseudocode: """
                function fibonacciSearch(array, target):
                    fibM2 = 0, fibM1 = 1
                    fibM = fibM2 + fibM1
                    while fibM < length(array):
                        fibM2 = fibM1
                        fibM1 = fibM
                        fibM = fibM2 + fibM1
                    offset = -1
                    while fibM > 1:
                        i = min(offset + fibM2, length(array) - 1)
                        if array[i] < target:
                            fibM = fibM1, fibM1 = fibM2
                            fibM2 = fibM - fibM1
                            offset = i
                        else if array[i] > target:
                            fibM = fibM2, fibM1 = fibM1 - fibM2
                            fibM2 = fibM - fibM1
                        else:
                            return i
                    if fibM1 and array[offset+1] == target:
                        return offset + 1
                    return -1
                """,
                .c: """
                int fibonacciSearch(int arr[], int n, int target) {
                    int fibM2 = 0, fibM1 = 1, fibM = fibM2 + fibM1;
                    while (fibM < n) {
                        fibM2 = fibM1;
                        fibM1 = fibM;
                        fibM = fibM2 + fibM1;
                    }
                    int offset = -1;
                    while (fibM > 1) {
                        int i = (offset + fibM2 < n - 1) ? offset + fibM2 : n - 1;
                        if (arr[i] < target) {
                            fibM = fibM1;
                            fibM1 = fibM2;
                            fibM2 = fibM - fibM1;
                            offset = i;
                        } else if (arr[i] > target) {
                            fibM = fibM2;
                            fibM1 = fibM1 - fibM2;
                            fibM2 = fibM - fibM1;
                        } else {
                            return i;
                        }
                    }
                    if (fibM1 && arr[offset + 1] == target)
                        return offset + 1;
                    return -1;
                }
                """,
                .cpp: """
                int fibonacciSearch(vector<int>& arr, int target) {
                    int n = arr.size();
                    int fibM2 = 0, fibM1 = 1, fibM = fibM2 + fibM1;
                    while (fibM < n) {
                        fibM2 = fibM1;
                        fibM1 = fibM;
                        fibM = fibM2 + fibM1;
                    }
                    int offset = -1;
                    while (fibM > 1) {
                        int i = min(offset + fibM2, n - 1);
                        if (arr[i] < target) {
                            fibM = fibM1;
                            fibM1 = fibM2;
                            fibM2 = fibM - fibM1;
                            offset = i;
                        } else if (arr[i] > target) {
                            fibM = fibM2;
                            fibM1 = fibM1 - fibM2;
                            fibM2 = fibM - fibM1;
                        } else {
                            return i;
                        }
                    }
                    if (fibM1 && arr[offset + 1] == target)
                        return offset + 1;
                    return -1;
                }
                """,
                .java: """
                public int fibonacciSearch(int[] arr, int target) {
                    int n = arr.length;
                    int fibM2 = 0, fibM1 = 1, fibM = fibM2 + fibM1;
                    while (fibM < n) {
                        fibM2 = fibM1;
                        fibM1 = fibM;
                        fibM = fibM2 + fibM1;
                    }
                    int offset = -1;
                    while (fibM > 1) {
                        int i = Math.min(offset + fibM2, n - 1);
                        if (arr[i] < target) {
                            fibM = fibM1;
                            fibM1 = fibM2;
                            fibM2 = fibM - fibM1;
                            offset = i;
                        } else if (arr[i] > target) {
                            fibM = fibM2;
                            fibM1 = fibM1 - fibM2;
                            fibM2 = fibM - fibM1;
                        } else {
                            return i;
                        }
                    }
                    if (fibM1 == 1 && arr[offset + 1] == target)
                        return offset + 1;
                    return -1;
                }
                """,
                .python: """
                def fibonacci_search(arr, target):
                    n = len(arr)
                    fibM2, fibM1 = 0, 1
                    fibM = fibM2 + fibM1
                    while fibM < n:
                        fibM2 = fibM1
                        fibM1 = fibM
                        fibM = fibM2 + fibM1
                    offset = -1
                    while fibM > 1:
                        i = min(offset + fibM2, n - 1)
                        if arr[i] < target:
                            fibM = fibM1
                            fibM1 = fibM2
                            fibM2 = fibM - fibM1
                            offset = i
                        elif arr[i] > target:
                            fibM = fibM2
                            fibM1 = fibM1 - fibM2
                            fibM2 = fibM - fibM1
                        else:
                            return i
                    if fibM1 and arr[offset + 1] == target:
                        return offset + 1
                    return -1
                """,
                .swift: """
                func fibonacciSearch(_ arr: [Int], target: Int) -> Int? {
                    let n = arr.count
                    var fibM2 = 0, fibM1 = 1, fibM = fibM2 + fibM1
                    while fibM < n {
                        fibM2 = fibM1
                        fibM1 = fibM
                        fibM = fibM2 + fibM1
                    }
                    var offset = -1
                    while fibM > 1 {
                        let i = min(offset + fibM2, n - 1)
                        if arr[i] < target {
                            fibM = fibM1
                            fibM1 = fibM2
                            fibM2 = fibM - fibM1
                            offset = i
                        } else if arr[i] > target {
                            fibM = fibM2
                            fibM1 = fibM1 - fibM2
                            fibM2 = fibM - fibM1
                        } else {
                            return i
                        }
                    }
                    if fibM1 == 1 && arr[offset + 1] == target {
                        return offset + 1
                    }
                    return nil
                }
                """,
                .javascript: """
                function fibonacciSearch(arr, target) {
                    const n = arr.length;
                    let fibM2 = 0, fibM1 = 1, fibM = fibM2 + fibM1;
                    while (fibM < n) {
                        fibM2 = fibM1;
                        fibM1 = fibM;
                        fibM = fibM2 + fibM1;
                    }
                    let offset = -1;
                    while (fibM > 1) {
                        const i = Math.min(offset + fibM2, n - 1);
                        if (arr[i] < target) {
                            fibM = fibM1;
                            fibM1 = fibM2;
                            fibM2 = fibM - fibM1;
                            offset = i;
                        } else if (arr[i] > target) {
                            fibM = fibM2;
                            fibM1 = fibM1 - fibM2;
                            fibM2 = fibM - fibM1;
                        } else {
                            return i;
                        }
                    }
                    if (fibM1 && arr[offset + 1] === target)
                        return offset + 1;
                    return -1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Use Fibonacci numbers (1,1,2,3,5,8) to divide array and find target."
            ),
            steps: [
                AlgorithmStep(title: "Find Fibonacci", description: "Find smallest Fibonacci number >= array length", type: .start),
                AlgorithmStep(title: "Initialize", description: "Initialize Fibonacci numbers: fibM, fibM1, fibM2", type: .process),
                AlgorithmStep(title: "Compare", description: "Compare target with element at Fibonacci position", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match, return index", type: .success),
                AlgorithmStep(title: "Eliminate Left", description: "If target is larger, eliminate left portion", type: .process),
                AlgorithmStep(title: "Eliminate Right", description: "If target is smaller, eliminate right portion", type: .process),
                AlgorithmStep(title: "Adjust & Repeat", description: "Adjust Fibonacci numbers and repeat", type: .end)
            ]
        )
    }
}
