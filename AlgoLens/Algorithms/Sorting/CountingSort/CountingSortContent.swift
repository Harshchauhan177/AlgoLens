//
//  CountingSortContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func countingSortContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Counting Sort is a non-comparison based sorting algorithm that works by counting the occurrences of each element, then using arithmetic to determine positions. It's extremely efficient for sorting integers within a specific range.",
            whenToUse: [
                "When sorting integers within a known, small range",
                "When you need O(n) time complexity",
                "For datasets with many duplicate values",
                "When the range of values is not significantly larger than n"
            ],
            keyIdea: "Count occurrences of each value, then use cumulative counts to place elements directly in their sorted positions.",
            codeImplementations: [
                .pseudocode: """
                function countingSort(array):
                    max = findMax(array)
                    count = array of size max+1, filled with 0
                    
                    // Count occurrences
                    for each element in array:
                        count[element]++
                    
                    // Cumulative count
                    for i = 1 to max:
                        count[i] += count[i-1]
                    
                    // Build output array
                    output = array of same size
                    for i = length(array)-1 down to 0:
                        output[count[array[i]]-1] = array[i]
                        count[array[i]]--
                    
                    return output
                """,
                .c: """
                void countingSort(int arr[], int n) {
                    int max = arr[0];
                    for (int i = 1; i < n; i++)
                        if (arr[i] > max) max = arr[i];
                    
                    int count[max + 1];
                    memset(count, 0, sizeof(count));
                    
                    for (int i = 0; i < n; i++)
                        count[arr[i]]++;
                    
                    for (int i = 1; i <= max; i++)
                        count[i] += count[i - 1];
                    
                    int output[n];
                    for (int i = n - 1; i >= 0; i--) {
                        output[count[arr[i]] - 1] = arr[i];
                        count[arr[i]]--;
                    }
                    
                    for (int i = 0; i < n; i++)
                        arr[i] = output[i];
                }
                """,
                .cpp: """
                void countingSort(vector<int>& arr) {
                    int max = *max_element(arr.begin(), arr.end());
                    vector<int> count(max + 1, 0);
                    
                    for (int num : arr)
                        count[num]++;
                    
                    for (int i = 1; i <= max; i++)
                        count[i] += count[i - 1];
                    
                    vector<int> output(arr.size());
                    for (int i = arr.size() - 1; i >= 0; i--) {
                        output[count[arr[i]] - 1] = arr[i];
                        count[arr[i]]--;
                    }
                    
                    arr = output;
                }
                """,
                .java: """
                public void countingSort(int[] arr) {
                    int max = Arrays.stream(arr).max().getAsInt();
                    int[] count = new int[max + 1];
                    
                    for (int num : arr)
                        count[num]++;
                    
                    for (int i = 1; i <= max; i++)
                        count[i] += count[i - 1];
                    
                    int[] output = new int[arr.length];
                    for (int i = arr.length - 1; i >= 0; i--) {
                        output[count[arr[i]] - 1] = arr[i];
                        count[arr[i]]--;
                    }
                    
                    System.arraycopy(output, 0, arr, 0, arr.length);
                }
                """,
                .python: """
                def counting_sort(arr):
                    max_val = max(arr)
                    count = [0] * (max_val + 1)
                    
                    for num in arr:
                        count[num] += 1
                    
                    for i in range(1, max_val + 1):
                        count[i] += count[i - 1]
                    
                    output = [0] * len(arr)
                    for i in range(len(arr) - 1, -1, -1):
                        output[count[arr[i]] - 1] = arr[i]
                        count[arr[i]] -= 1
                    
                    return output
                """,
                .swift: """
                func countingSort(_ arr: [Int]) -> [Int] {
                    guard let max = arr.max() else { return arr }
                    var count = Array(repeating: 0, count: max + 1)
                    
                    for num in arr {
                        count[num] += 1
                    }
                    
                    for i in 1...max {
                        count[i] += count[i - 1]
                    }
                    
                    var output = Array(repeating: 0, count: arr.count)
                    for i in stride(from: arr.count - 1, through: 0, by: -1) {
                        output[count[arr[i]] - 1] = arr[i]
                        count[arr[i]] -= 1
                    }
                    
                    return output
                }
                """,
                .javascript: """
                function countingSort(arr) {
                    const max = Math.max(...arr);
                    const count = new Array(max + 1).fill(0);
                    
                    for (let num of arr)
                        count[num]++;
                    
                    for (let i = 1; i <= max; i++)
                        count[i] += count[i - 1];
                    
                    const output = new Array(arr.length);
                    for (let i = arr.length - 1; i >= 0; i--) {
                        output[count[arr[i]] - 1] = arr[i];
                        count[arr[i]]--;
                    }
                    
                    return output;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [4, 2, 2, 8, 3, 3, 1],
                target: 0,
                expectedOutput: "[1, 2, 2, 3, 3, 4, 8]",
                explanation: "Count: [0,1,2,2,1,0,0,0,1]. Cumulative: [0,1,3,5,6,6,6,6,7]. Place each element using counts to get sorted array."
            ),
            steps: [
                AlgorithmStep(title: "Find Maximum", description: "Find the maximum value in the array", type: .start),
                AlgorithmStep(title: "Count Occurrences", description: "Create count array and count each element", type: .process),
                AlgorithmStep(title: "Cumulative Count", description: "Transform counts into cumulative counts", type: .process),
                AlgorithmStep(title: "Build Output", description: "Use counts to place elements in correct positions", type: .success),
                AlgorithmStep(title: "Decrement Count", description: "Decrease count after placing each element", type: .process),
                AlgorithmStep(title: "Copy Back", description: "Copy output array back to original", type: .process),
                AlgorithmStep(title: "Complete", description: "Array is now sorted", type: .end)
            ]
        )
    }
}
