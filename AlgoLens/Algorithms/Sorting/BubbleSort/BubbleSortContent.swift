//
//  BubbleSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func bubbleSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Bubble Sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order. The pass through the list is repeated until the list is sorted.",
            whenToUse: [
                "When the array is nearly sorted",
                "For small datasets",
                "When simplicity is more important than efficiency",
                "For educational purposes to understand sorting"
            ],
            keyIdea: "Like bubbles rising to the surface, larger elements 'bubble up' to the end of the array in each pass.",
            codeImplementations: [
                .pseudocode: """
                function bubbleSort(array):
                    n = length(array)
                    for i = 0 to n-1:
                        for j = 0 to n-i-2:
                            if array[j] > array[j+1]:
                                swap(array[j], array[j+1])
                    return array
                """,
                .c: """
                void bubbleSort(int arr[], int n) {
                    for (int i = 0; i < n-1; i++) {
                        for (int j = 0; j < n-i-1; j++) {
                            if (arr[j] > arr[j+1]) {
                                int temp = arr[j];
                                arr[j] = arr[j+1];
                                arr[j+1] = temp;
                            }
                        }
                    }
                }
                """,
                .cpp: """
                void bubbleSort(vector<int>& arr) {
                    int n = arr.size();
                    for (int i = 0; i < n-1; i++) {
                        for (int j = 0; j < n-i-1; j++) {
                            if (arr[j] > arr[j+1]) {
                                swap(arr[j], arr[j+1]);
                            }
                        }
                    }
                }
                """,
                .java: """
                public void bubbleSort(int[] arr) {
                    int n = arr.length;
                    for (int i = 0; i < n-1; i++) {
                        for (int j = 0; j < n-i-1; j++) {
                            if (arr[j] > arr[j+1]) {
                                int temp = arr[j];
                                arr[j] = arr[j+1];
                                arr[j+1] = temp;
                            }
                        }
                    }
                }
                """,
                .python: """
                def bubble_sort(arr):
                    n = len(arr)
                    for i in range(n-1):
                        for j in range(n-i-1):
                            if arr[j] > arr[j+1]:
                                arr[j], arr[j+1] = arr[j+1], arr[j]
                    return arr
                """,
                .swift: """
                func bubbleSort(_ arr: inout [Int]) {
                    let n = arr.count
                    for i in 0..<n-1 {
                        for j in 0..<n-i-1 {
                            if arr[j] > arr[j+1] {
                                arr.swapAt(j, j+1)
                            }
                        }
                    }
                }
                """,
                .javascript: """
                function bubbleSort(arr) {
                    const n = arr.length;
                    for (let i = 0; i < n-1; i++) {
                        for (let j = 0; j < n-i-1; j++) {
                            if (arr[j] > arr[j+1]) {
                                [arr[j], arr[j+1]] = [arr[j+1], arr[j]];
                            }
                        }
                    }
                    return arr;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [64, 34, 25, 12, 22, 11, 90],
                target: 0,
                expectedOutput: "[11, 12, 22, 25, 34, 64, 90]",
                explanation: "After each pass, the largest unsorted element moves to its correct position at the end. Pass 1: 90 moves to end. Pass 2: 64 moves to second-last position, and so on."
            ),
            steps: [
                AlgorithmStep(title: "Start First Pass", description: "Begin comparing adjacent elements from the start", type: .start),
                AlgorithmStep(title: "Compare Adjacent", description: "Compare current element with next element", type: .decision),
                AlgorithmStep(title: "Swap if Needed", description: "If current > next, swap them", type: .process),
                AlgorithmStep(title: "Continue Pass", description: "Move to next pair of elements", type: .process),
                AlgorithmStep(title: "Complete Pass", description: "Largest element is now at the end", type: .success),
                AlgorithmStep(title: "Repeat", description: "Start next pass, excluding sorted elements", type: .process),
                AlgorithmStep(title: "Array Sorted", description: "All elements are in correct order", type: .end)
            ]
        )
    }
}
