//
//  SelectionSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func selectionSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Selection Sort divides the array into sorted and unsorted regions. It repeatedly selects the smallest element from the unsorted region and moves it to the end of the sorted region.",
            whenToUse: [
                "When memory write operations are costly",
                "For small datasets",
                "When you want to minimize the number of swaps",
                "For educational purposes"
            ],
            keyIdea: "Find the minimum element in the unsorted portion and swap it with the first unsorted element.",
            codeImplementations: [
                .pseudocode: """
                function selectionSort(array):
                    n = length(array)
                    for i = 0 to n-2:
                        minIndex = i
                        for j = i+1 to n-1:
                            if array[j] < array[minIndex]:
                                minIndex = j
                        swap(array[i], array[minIndex])
                    return array
                """,
                .c: """
                void selectionSort(int arr[], int n) {
                    for (int i = 0; i < n-1; i++) {
                        int minIndex = i;
                        for (int j = i+1; j < n; j++) {
                            if (arr[j] < arr[minIndex])
                                minIndex = j;
                        }
                        int temp = arr[i];
                        arr[i] = arr[minIndex];
                        arr[minIndex] = temp;
                    }
                }
                """,
                .cpp: """
                void selectionSort(vector<int>& arr) {
                    int n = arr.size();
                    for (int i = 0; i < n-1; i++) {
                        int minIndex = i;
                        for (int j = i+1; j < n; j++) {
                            if (arr[j] < arr[minIndex])
                                minIndex = j;
                        }
                        swap(arr[i], arr[minIndex]);
                    }
                }
                """,
                .java: """
                public void selectionSort(int[] arr) {
                    int n = arr.length;
                    for (int i = 0; i < n-1; i++) {
                        int minIndex = i;
                        for (int j = i+1; j < n; j++) {
                            if (arr[j] < arr[minIndex])
                                minIndex = j;
                        }
                        int temp = arr[i];
                        arr[i] = arr[minIndex];
                        arr[minIndex] = temp;
                    }
                }
                """,
                .python: """
                def selection_sort(arr):
                    n = len(arr)
                    for i in range(n-1):
                        min_index = i
                        for j in range(i+1, n):
                            if arr[j] < arr[min_index]:
                                min_index = j
                        arr[i], arr[min_index] = arr[min_index], arr[i]
                    return arr
                """,
                .swift: """
                func selectionSort(_ arr: inout [Int]) {
                    let n = arr.count
                    for i in 0..<n-1 {
                        var minIndex = i
                        for j in i+1..<n {
                            if arr[j] < arr[minIndex] {
                                minIndex = j
                            }
                        }
                        arr.swapAt(i, minIndex)
                    }
                }
                """,
                .javascript: """
                function selectionSort(arr) {
                    const n = arr.length;
                    for (let i = 0; i < n-1; i++) {
                        let minIndex = i;
                        for (let j = i+1; j < n; j++) {
                            if (arr[j] < arr[minIndex])
                                minIndex = j;
                        }
                        [arr[i], arr[minIndex]] = [arr[minIndex], arr[i]];
                    }
                    return arr;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [64, 25, 12, 22, 11],
                target: 0,
                expectedOutput: "[11, 12, 22, 25, 64]",
                explanation: "Find minimum (11) and swap with first position. Find next minimum (12) in remaining array and swap with second position. Repeat until sorted."
            ),
            steps: [
                AlgorithmStep(title: "Start Selection", description: "Set current position to start of array", type: .start),
                AlgorithmStep(title: "Find Minimum", description: "Scan unsorted portion to find minimum element", type: .process),
                AlgorithmStep(title: "Mark Minimum", description: "Keep track of minimum element's index", type: .decision),
                AlgorithmStep(title: "Swap Elements", description: "Swap minimum with current position", type: .process),
                AlgorithmStep(title: "Extend Sorted", description: "Current position is now part of sorted region", type: .success),
                AlgorithmStep(title: "Move Forward", description: "Move to next position in array", type: .process),
                AlgorithmStep(title: "Complete", description: "All elements are sorted", type: .end)
            ]
        )
    }
}
