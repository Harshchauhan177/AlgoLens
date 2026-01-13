//
//  QuickSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func quickSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Quick Sort is a highly efficient divide-and-conquer sorting algorithm that works by selecting a 'pivot' element and partitioning the array around it, placing smaller elements before and larger elements after the pivot.",
            whenToUse: [
                "For large datasets requiring fast sorting",
                "When average-case O(n log n) is acceptable",
                "When in-place sorting is preferred",
                "For general-purpose sorting needs"
            ],
            keyIdea: "Choose a pivot element, partition the array so elements smaller than pivot are on the left and larger on the right, then recursively sort both partitions.",
            codeImplementations: [
                .pseudocode: """
                function quickSort(array, low, high):
                    if low < high:
                        pivotIndex = partition(array, low, high)
                        quickSort(array, low, pivotIndex - 1)
                        quickSort(array, pivotIndex + 1, high)
                
                function partition(array, low, high):
                    pivot = array[high]
                    i = low - 1
                    for j = low to high-1:
                        if array[j] < pivot:
                            i = i + 1
                            swap(array[i], array[j])
                    swap(array[i+1], array[high])
                    return i + 1
                """,
                .c: """
                int partition(int arr[], int low, int high) {
                    int pivot = arr[high];
                    int i = low - 1;
                    for (int j = low; j < high; j++) {
                        if (arr[j] < pivot) {
                            i++;
                            int temp = arr[i];
                            arr[i] = arr[j];
                            arr[j] = temp;
                        }
                    }
                    int temp = arr[i + 1];
                    arr[i + 1] = arr[high];
                    arr[high] = temp;
                    return i + 1;
                }
                
                void quickSort(int arr[], int low, int high) {
                    if (low < high) {
                        int pi = partition(arr, low, high);
                        quickSort(arr, low, pi - 1);
                        quickSort(arr, pi + 1, high);
                    }
                }
                """,
                .cpp: """
                int partition(vector<int>& arr, int low, int high) {
                    int pivot = arr[high];
                    int i = low - 1;
                    for (int j = low; j < high; j++) {
                        if (arr[j] < pivot) {
                            i++;
                            swap(arr[i], arr[j]);
                        }
                    }
                    swap(arr[i + 1], arr[high]);
                    return i + 1;
                }
                
                void quickSort(vector<int>& arr, int low, int high) {
                    if (low < high) {
                        int pi = partition(arr, low, high);
                        quickSort(arr, low, pi - 1);
                        quickSort(arr, pi + 1, high);
                    }
                }
                """,
                .java: """
                public void quickSort(int[] arr, int low, int high) {
                    if (low < high) {
                        int pi = partition(arr, low, high);
                        quickSort(arr, low, pi - 1);
                        quickSort(arr, pi + 1, high);
                    }
                }
                
                private int partition(int[] arr, int low, int high) {
                    int pivot = arr[high];
                    int i = low - 1;
                    for (int j = low; j < high; j++) {
                        if (arr[j] < pivot) {
                            i++;
                            int temp = arr[i];
                            arr[i] = arr[j];
                            arr[j] = temp;
                        }
                    }
                    int temp = arr[i + 1];
                    arr[i + 1] = arr[high];
                    arr[high] = temp;
                    return i + 1;
                }
                """,
                .python: """
                def quick_sort(arr, low, high):
                    if low < high:
                        pi = partition(arr, low, high)
                        quick_sort(arr, low, pi - 1)
                        quick_sort(arr, pi + 1, high)
                
                def partition(arr, low, high):
                    pivot = arr[high]
                    i = low - 1
                    for j in range(low, high):
                        if arr[j] < pivot:
                            i += 1
                            arr[i], arr[j] = arr[j], arr[i]
                    arr[i + 1], arr[high] = arr[high], arr[i + 1]
                    return i + 1
                """,
                .swift: """
                func quickSort(_ arr: inout [Int], low: Int, high: Int) {
                    if low < high {
                        let pi = partition(&arr, low: low, high: high)
                        quickSort(&arr, low: low, high: pi - 1)
                        quickSort(&arr, low: pi + 1, high: high)
                    }
                }
                
                func partition(_ arr: inout [Int], low: Int, high: Int) -> Int {
                    let pivot = arr[high]
                    var i = low - 1
                    for j in low..<high {
                        if arr[j] < pivot {
                            i += 1
                            arr.swapAt(i, j)
                        }
                    }
                    arr.swapAt(i + 1, high)
                    return i + 1
                }
                """,
                .javascript: """
                function quickSort(arr, low = 0, high = arr.length - 1) {
                    if (low < high) {
                        const pi = partition(arr, low, high);
                        quickSort(arr, low, pi - 1);
                        quickSort(arr, pi + 1, high);
                    }
                    return arr;
                }
                
                function partition(arr, low, high) {
                    const pivot = arr[high];
                    let i = low - 1;
                    for (let j = low; j < high; j++) {
                        if (arr[j] < pivot) {
                            i++;
                            [arr[i], arr[j]] = [arr[j], arr[i]];
                        }
                    }
                    [arr[i + 1], arr[high]] = [arr[high], arr[i + 1]];
                    return i + 1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [10, 7, 8, 9, 1, 5],
                target: 0,
                expectedOutput: "[1, 5, 7, 8, 9, 10]",
                explanation: "Choose pivot (5). Partition: [1] 5 [7,8,9,10]. Recursively sort left and right partitions. Result is fully sorted array."
            ),
            steps: [
                AlgorithmStep(title: "Choose Pivot", description: "Select a pivot element (often the last element)", type: .start),
                AlgorithmStep(title: "Partition", description: "Rearrange array so smaller elements are before pivot", type: .process),
                AlgorithmStep(title: "Place Pivot", description: "Put pivot in its final sorted position", type: .success),
                AlgorithmStep(title: "Divide", description: "Array is now divided into two partitions", type: .decision),
                AlgorithmStep(title: "Recurse Left", description: "Recursively sort left partition", type: .process),
                AlgorithmStep(title: "Recurse Right", description: "Recursively sort right partition", type: .process),
                AlgorithmStep(title: "Complete", description: "All partitions sorted, array is sorted", type: .end)
            ]
        )
    }
}
