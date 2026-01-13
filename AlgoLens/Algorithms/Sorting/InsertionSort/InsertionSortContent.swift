//
//  InsertionSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func insertionSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Insertion Sort builds the final sorted array one item at a time by inserting each element into its proper position among the previously sorted elements, similar to sorting playing cards in your hands.",
            whenToUse: [
                "When the array is nearly sorted",
                "For small datasets",
                "When you need a simple, adaptive algorithm",
                "For online sorting (sorting as data arrives)"
            ],
            keyIdea: "Take one element at a time and insert it into its correct position in the already sorted portion.",
            codeImplementations: [
                .pseudocode: """
                function insertionSort(array):
                    for i = 1 to length(array)-1:
                        key = array[i]
                        j = i - 1
                        while j >= 0 and array[j] > key:
                            array[j+1] = array[j]
                            j = j - 1
                        array[j+1] = key
                    return array
                """,
                .c: """
                void insertionSort(int arr[], int n) {
                    for (int i = 1; i < n; i++) {
                        int key = arr[i];
                        int j = i - 1;
                        while (j >= 0 && arr[j] > key) {
                            arr[j + 1] = arr[j];
                            j--;
                        }
                        arr[j + 1] = key;
                    }
                }
                """,
                .cpp: """
                void insertionSort(vector<int>& arr) {
                    for (int i = 1; i < arr.size(); i++) {
                        int key = arr[i];
                        int j = i - 1;
                        while (j >= 0 && arr[j] > key) {
                            arr[j + 1] = arr[j];
                            j--;
                        }
                        arr[j + 1] = key;
                    }
                }
                """,
                .java: """
                public void insertionSort(int[] arr) {
                    for (int i = 1; i < arr.length; i++) {
                        int key = arr[i];
                        int j = i - 1;
                        while (j >= 0 && arr[j] > key) {
                            arr[j + 1] = arr[j];
                            j--;
                        }
                        arr[j + 1] = key;
                    }
                }
                """,
                .python: """
                def insertion_sort(arr):
                    for i in range(1, len(arr)):
                        key = arr[i]
                        j = i - 1
                        while j >= 0 and arr[j] > key:
                            arr[j + 1] = arr[j]
                            j -= 1
                        arr[j + 1] = key
                    return arr
                """,
                .swift: """
                func insertionSort(_ arr: inout [Int]) {
                    for i in 1..<arr.count {
                        let key = arr[i]
                        var j = i - 1
                        while j >= 0 && arr[j] > key {
                            arr[j + 1] = arr[j]
                            j -= 1
                        }
                        arr[j + 1] = key
                    }
                }
                """,
                .javascript: """
                function insertionSort(arr) {
                    for (let i = 1; i < arr.length; i++) {
                        let key = arr[i];
                        let j = i - 1;
                        while (j >= 0 && arr[j] > key) {
                            arr[j + 1] = arr[j];
                            j--;
                        }
                        arr[j + 1] = key;
                    }
                    return arr;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [12, 11, 13, 5, 6],
                target: 0,
                expectedOutput: "[5, 6, 11, 12, 13]",
                explanation: "Start with 12 as sorted. Insert 11 before 12. Keep 13 at end. Insert 5 at beginning. Insert 6 after 5. Result is sorted array."
            ),
            steps: [
                AlgorithmStep(title: "Start with Second", description: "Consider first element as sorted, start from index 1", type: .start),
                AlgorithmStep(title: "Pick Key", description: "Select current element as key to insert", type: .process),
                AlgorithmStep(title: "Compare Backward", description: "Compare key with sorted elements from right to left", type: .decision),
                AlgorithmStep(title: "Shift Elements", description: "Move larger elements one position right", type: .process),
                AlgorithmStep(title: "Insert Key", description: "Place key in its correct position", type: .success),
                AlgorithmStep(title: "Move Forward", description: "Move to next element in array", type: .process),
                AlgorithmStep(title: "Complete", description: "All elements inserted in sorted order", type: .end)
            ]
        )
    }
}
