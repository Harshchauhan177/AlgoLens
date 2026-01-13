//
//  MergeSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func mergeSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Merge Sort is a divide-and-conquer algorithm that divides the array into halves, recursively sorts them, and then merges the sorted halves back together. It guarantees O(n log n) performance in all cases.",
            whenToUse: [
                "When you need guaranteed O(n log n) performance",
                "For large datasets",
                "When stability is required",
                "For sorting linked lists efficiently"
            ],
            keyIdea: "Divide the array into halves, sort each half recursively, then merge the sorted halves into a single sorted array.",
            codeImplementations: [
                .pseudocode: """
                function mergeSort(array):
                    if length(array) <= 1:
                        return array
                    mid = length(array) / 2
                    left = mergeSort(array[0...mid])
                    right = mergeSort(array[mid+1...end])
                    return merge(left, right)
                
                function merge(left, right):
                    result = []
                    while left and right not empty:
                        if left[0] <= right[0]:
                            append left[0] to result
                        else:
                            append right[0] to result
                    append remaining elements
                    return result
                """,
                .c: """
                void merge(int arr[], int l, int m, int r) {
                    int n1 = m - l + 1, n2 = r - m;
                    int L[n1], R[n2];
                    for (int i = 0; i < n1; i++) L[i] = arr[l + i];
                    for (int j = 0; j < n2; j++) R[j] = arr[m + 1 + j];
                    int i = 0, j = 0, k = l;
                    while (i < n1 && j < n2) {
                        if (L[i] <= R[j]) arr[k++] = L[i++];
                        else arr[k++] = R[j++];
                    }
                    while (i < n1) arr[k++] = L[i++];
                    while (j < n2) arr[k++] = R[j++];
                }
                
                void mergeSort(int arr[], int l, int r) {
                    if (l < r) {
                        int m = l + (r - l) / 2;
                        mergeSort(arr, l, m);
                        mergeSort(arr, m + 1, r);
                        merge(arr, l, m, r);
                    }
                }
                """,
                .cpp: """
                void merge(vector<int>& arr, int l, int m, int r) {
                    vector<int> left(arr.begin() + l, arr.begin() + m + 1);
                    vector<int> right(arr.begin() + m + 1, arr.begin() + r + 1);
                    int i = 0, j = 0, k = l;
                    while (i < left.size() && j < right.size()) {
                        if (left[i] <= right[j]) arr[k++] = left[i++];
                        else arr[k++] = right[j++];
                    }
                    while (i < left.size()) arr[k++] = left[i++];
                    while (j < right.size()) arr[k++] = right[j++];
                }
                
                void mergeSort(vector<int>& arr, int l, int r) {
                    if (l < r) {
                        int m = l + (r - l) / 2;
                        mergeSort(arr, l, m);
                        mergeSort(arr, m + 1, r);
                        merge(arr, l, m, r);
                    }
                }
                """,
                .java: """
                public void mergeSort(int[] arr, int l, int r) {
                    if (l < r) {
                        int m = l + (r - l) / 2;
                        mergeSort(arr, l, m);
                        mergeSort(arr, m + 1, r);
                        merge(arr, l, m, r);
                    }
                }
                
                private void merge(int[] arr, int l, int m, int r) {
                    int n1 = m - l + 1, n2 = r - m;
                    int[] L = new int[n1], R = new int[n2];
                    System.arraycopy(arr, l, L, 0, n1);
                    System.arraycopy(arr, m + 1, R, 0, n2);
                    int i = 0, j = 0, k = l;
                    while (i < n1 && j < n2)
                        arr[k++] = (L[i] <= R[j]) ? L[i++] : R[j++];
                    while (i < n1) arr[k++] = L[i++];
                    while (j < n2) arr[k++] = R[j++];
                }
                """,
                .python: """
                def merge_sort(arr):
                    if len(arr) <= 1:
                        return arr
                    mid = len(arr) // 2
                    left = merge_sort(arr[:mid])
                    right = merge_sort(arr[mid:])
                    return merge(left, right)
                
                def merge(left, right):
                    result = []
                    i = j = 0
                    while i < len(left) and j < len(right):
                        if left[i] <= right[j]:
                            result.append(left[i])
                            i += 1
                        else:
                            result.append(right[j])
                            j += 1
                    result.extend(left[i:])
                    result.extend(right[j:])
                    return result
                """,
                .swift: """
                func mergeSort(_ arr: [Int]) -> [Int] {
                    guard arr.count > 1 else { return arr }
                    let mid = arr.count / 2
                    let left = mergeSort(Array(arr[..<mid]))
                    let right = mergeSort(Array(arr[mid...]))
                    return merge(left, right)
                }
                
                func merge(_ left: [Int], _ right: [Int]) -> [Int] {
                    var result = [Int]()
                    var i = 0, j = 0
                    while i < left.count && j < right.count {
                        if left[i] <= right[j] {
                            result.append(left[i])
                            i += 1
                        } else {
                            result.append(right[j])
                            j += 1
                        }
                    }
                    result.append(contentsOf: left[i...])
                    result.append(contentsOf: right[j...])
                    return result
                }
                """,
                .javascript: """
                function mergeSort(arr) {
                    if (arr.length <= 1) return arr;
                    const mid = Math.floor(arr.length / 2);
                    const left = mergeSort(arr.slice(0, mid));
                    const right = mergeSort(arr.slice(mid));
                    return merge(left, right);
                }
                
                function merge(left, right) {
                    const result = [];
                    let i = 0, j = 0;
                    while (i < left.length && j < right.length) {
                        if (left[i] <= right[j]) result.push(left[i++]);
                        else result.push(right[j++]);
                    }
                    return result.concat(left.slice(i), right.slice(j));
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [38, 27, 43, 3, 9, 82, 10],
                target: 0,
                expectedOutput: "[3, 9, 10, 27, 38, 43, 82]",
                explanation: "Divide: [38,27,43,3] and [9,82,10]. Recursively divide and sort. Merge sorted halves: [3,27,38,43] and [9,10,82]. Final merge produces sorted array."
            ),
            steps: [
                AlgorithmStep(title: "Divide", description: "Split array into two halves at midpoint", type: .start),
                AlgorithmStep(title: "Recurse Left", description: "Recursively sort the left half", type: .process),
                AlgorithmStep(title: "Recurse Right", description: "Recursively sort the right half", type: .process),
                AlgorithmStep(title: "Base Case", description: "Single element arrays are already sorted", type: .decision),
                AlgorithmStep(title: "Merge", description: "Merge two sorted halves into one", type: .process),
                AlgorithmStep(title: "Compare", description: "Pick smaller element from both halves", type: .success),
                AlgorithmStep(title: "Complete", description: "Fully sorted array obtained", type: .end)
            ]
        )
    }
}
