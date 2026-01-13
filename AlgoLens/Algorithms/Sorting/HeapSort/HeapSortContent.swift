//
//  HeapSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func heapSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Heap Sort is a comparison-based sorting algorithm that uses a binary heap data structure. It first builds a max heap from the input data, then repeatedly extracts the maximum element and rebuilds the heap.",
            whenToUse: [
                "When guaranteed O(n log n) time is needed",
                "When you want in-place sorting with no extra space",
                "For systems with memory constraints",
                "When worst-case performance matters"
            ],
            keyIdea: "Build a max heap, then repeatedly remove the largest element and restore the heap property until the array is sorted.",
            codeImplementations: [
                .pseudocode: """
                function heapSort(array):
                    n = length(array)
                    // Build max heap
                    for i = n/2 - 1 down to 0:
                        heapify(array, n, i)
                    // Extract elements from heap
                    for i = n-1 down to 1:
                        swap(array[0], array[i])
                        heapify(array, i, 0)
                
                function heapify(array, n, i):
                    largest = i
                    left = 2*i + 1
                    right = 2*i + 2
                    if left < n and array[left] > array[largest]:
                        largest = left
                    if right < n and array[right] > array[largest]:
                        largest = right
                    if largest != i:
                        swap(array[i], array[largest])
                        heapify(array, n, largest)
                """,
                .c: """
                void heapify(int arr[], int n, int i) {
                    int largest = i, left = 2*i + 1, right = 2*i + 2;
                    if (left < n && arr[left] > arr[largest])
                        largest = left;
                    if (right < n && arr[right] > arr[largest])
                        largest = right;
                    if (largest != i) {
                        int temp = arr[i];
                        arr[i] = arr[largest];
                        arr[largest] = temp;
                        heapify(arr, n, largest);
                    }
                }
                
                void heapSort(int arr[], int n) {
                    for (int i = n/2 - 1; i >= 0; i--)
                        heapify(arr, n, i);
                    for (int i = n-1; i > 0; i--) {
                        int temp = arr[0];
                        arr[0] = arr[i];
                        arr[i] = temp;
                        heapify(arr, i, 0);
                    }
                }
                """,
                .cpp: """
                void heapify(vector<int>& arr, int n, int i) {
                    int largest = i, left = 2*i + 1, right = 2*i + 2;
                    if (left < n && arr[left] > arr[largest])
                        largest = left;
                    if (right < n && arr[right] > arr[largest])
                        largest = right;
                    if (largest != i) {
                        swap(arr[i], arr[largest]);
                        heapify(arr, n, largest);
                    }
                }
                
                void heapSort(vector<int>& arr) {
                    int n = arr.size();
                    for (int i = n/2 - 1; i >= 0; i--)
                        heapify(arr, n, i);
                    for (int i = n-1; i > 0; i--) {
                        swap(arr[0], arr[i]);
                        heapify(arr, i, 0);
                    }
                }
                """,
                .java: """
                public void heapSort(int[] arr) {
                    int n = arr.length;
                    for (int i = n/2 - 1; i >= 0; i--)
                        heapify(arr, n, i);
                    for (int i = n-1; i > 0; i--) {
                        int temp = arr[0];
                        arr[0] = arr[i];
                        arr[i] = temp;
                        heapify(arr, i, 0);
                    }
                }
                
                void heapify(int[] arr, int n, int i) {
                    int largest = i, left = 2*i + 1, right = 2*i + 2;
                    if (left < n && arr[left] > arr[largest])
                        largest = left;
                    if (right < n && arr[right] > arr[largest])
                        largest = right;
                    if (largest != i) {
                        int temp = arr[i];
                        arr[i] = arr[largest];
                        arr[largest] = temp;
                        heapify(arr, n, largest);
                    }
                }
                """,
                .python: """
                def heap_sort(arr):
                    n = len(arr)
                    for i in range(n//2 - 1, -1, -1):
                        heapify(arr, n, i)
                    for i in range(n-1, 0, -1):
                        arr[0], arr[i] = arr[i], arr[0]
                        heapify(arr, i, 0)
                    return arr
                
                def heapify(arr, n, i):
                    largest = i
                    left, right = 2*i + 1, 2*i + 2
                    if left < n and arr[left] > arr[largest]:
                        largest = left
                    if right < n and arr[right] > arr[largest]:
                        largest = right
                    if largest != i:
                        arr[i], arr[largest] = arr[largest], arr[i]
                        heapify(arr, n, largest)
                """,
                .swift: """
                func heapSort(_ arr: inout [Int]) {
                    let n = arr.count
                    for i in stride(from: n/2 - 1, through: 0, by: -1) {
                        heapify(&arr, n: n, i: i)
                    }
                    for i in stride(from: n-1, through: 1, by: -1) {
                        arr.swapAt(0, i)
                        heapify(&arr, n: i, i: 0)
                    }
                }
                
                func heapify(_ arr: inout [Int], n: Int, i: Int) {
                    var largest = i
                    let left = 2*i + 1, right = 2*i + 2
                    if left < n && arr[left] > arr[largest] {
                        largest = left
                    }
                    if right < n && arr[right] > arr[largest] {
                        largest = right
                    }
                    if largest != i {
                        arr.swapAt(i, largest)
                        heapify(&arr, n: n, i: largest)
                    }
                }
                """,
                .javascript: """
                function heapSort(arr) {
                    const n = arr.length;
                    for (let i = Math.floor(n/2) - 1; i >= 0; i--)
                        heapify(arr, n, i);
                    for (let i = n-1; i > 0; i--) {
                        [arr[0], arr[i]] = [arr[i], arr[0]];
                        heapify(arr, i, 0);
                    }
                    return arr;
                }
                
                function heapify(arr, n, i) {
                    let largest = i, left = 2*i + 1, right = 2*i + 2;
                    if (left < n && arr[left] > arr[largest])
                        largest = left;
                    if (right < n && arr[right] > arr[largest])
                        largest = right;
                    if (largest !== i) {
                        [arr[i], arr[largest]] = [arr[largest], arr[i]];
                        heapify(arr, n, largest);
                    }
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [12, 11, 13, 5, 6, 7],
                target: 0,
                expectedOutput: "[5, 6, 7, 11, 12, 13]",
                explanation: "Build max heap: [13,12,11,5,6,7]. Extract max (13) to end, heapify remaining. Repeat until sorted."
            ),
            steps: [
                AlgorithmStep(title: "Build Max Heap", description: "Convert array into a max heap structure", type: .start),
                AlgorithmStep(title: "Heapify", description: "Ensure parent nodes are larger than children", type: .process),
                AlgorithmStep(title: "Extract Max", description: "Move root (maximum) to end of array", type: .success),
                AlgorithmStep(title: "Reduce Heap", description: "Decrease heap size by one", type: .decision),
                AlgorithmStep(title: "Restore Heap", description: "Heapify the reduced heap", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until heap size is 1", type: .process),
                AlgorithmStep(title: "Complete", description: "Array is now fully sorted", type: .end)
            ]
        )
    }
}
