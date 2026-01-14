//
//  SlidingWindowContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func slidingWindowContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Sliding Window maintains a fixed or variable size window that moves through an array, useful for finding subarrays with specific properties efficiently in O(n) time.",
            whenToUse: [
                "Finding maximum/minimum sum of k consecutive elements",
                "Longest substring problems with constraints",
                "Running averages or statistics over a range",
                "Detecting patterns in sequential data"
            ],
            keyIdea: "Slide a window through the array, adding new elements and removing old ones efficiently instead of recalculating from scratch.",
            codeImplementations: [
                .pseudocode: """
                function maxSumWindow(array, k):
                    windowSum = sum(array[0...k-1])
                    maxSum = windowSum
                    
                    for i from k to length(array)-1:
                        windowSum = windowSum - array[i-k] + array[i]
                        maxSum = max(maxSum, windowSum)
                    
                    return maxSum
                """,
                .python: """
                def max_sum_window(arr, k):
                    window_sum = sum(arr[:k])
                    max_sum = window_sum
                    
                    for i in range(k, len(arr)):
                        window_sum = window_sum - arr[i-k] + arr[i]
                        max_sum = max(max_sum, window_sum)
                    
                    return max_sum
                """,
                .swift: """
                func maxSumWindow(_ arr: [Int], k: Int) -> Int {
                    var windowSum = arr[0..<k].reduce(0, +)
                    var maxSum = windowSum
                    
                    for i in k..<arr.count {
                        windowSum = windowSum - arr[i-k] + arr[i]
                        maxSum = max(maxSum, windowSum)
                    }
                    
                    return maxSum
                }
                """,
                .java: """
                public int maxSumWindow(int[] arr, int k) {
                    int windowSum = 0;
                    for (int i = 0; i < k; i++)
                        windowSum += arr[i];
                    
                    int maxSum = windowSum;
                    for (int i = k; i < arr.length; i++) {
                        windowSum = windowSum - arr[i-k] + arr[i];
                        maxSum = Math.max(maxSum, windowSum);
                    }
                    
                    return maxSum;
                }
                """,
                .cpp: """
                int maxSumWindow(vector<int>& arr, int k) {
                    int windowSum = 0;
                    for (int i = 0; i < k; i++)
                        windowSum += arr[i];
                    
                    int maxSum = windowSum;
                    for (int i = k; i < arr.size(); i++) {
                        windowSum = windowSum - arr[i-k] + arr[i];
                        maxSum = max(maxSum, windowSum);
                    }
                    
                    return maxSum;
                }
                """,
                .c: """
                int maxSumWindow(int arr[], int n, int k) {
                    int windowSum = 0;
                    for (int i = 0; i < k; i++)
                        windowSum += arr[i];
                    
                    int maxSum = windowSum;
                    for (int i = k; i < n; i++) {
                        windowSum = windowSum - arr[i-k] + arr[i];
                        maxSum = (maxSum > windowSum) ? maxSum : windowSum;
                    }
                    
                    return maxSum;
                }
                """,
                .javascript: """
                function maxSumWindow(arr, k) {
                    let windowSum = arr.slice(0, k).reduce((a, b) => a + b, 0);
                    let maxSum = windowSum;
                    
                    for (let i = k; i < arr.length; i++) {
                        windowSum = windowSum - arr[i-k] + arr[i];
                        maxSum = Math.max(maxSum, windowSum);
                    }
                    
                    return maxSum;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [2, 1, 5, 1, 3, 2],
                target: 3,
                expectedOutput: "Max sum: 9",
                explanation: "Window [5,1,3] at positions 2-4 has the maximum sum of 9. We efficiently find this by sliding the window and updating the sum instead of recalculating each time."
            ),
            steps: [
                AlgorithmStep(title: "Initialize Window", description: "Calculate sum of first k elements", type: .start),
                AlgorithmStep(title: "Set Maximum", description: "Set initial window sum as maximum", type: .process),
                AlgorithmStep(title: "Slide Window", description: "Remove leftmost element, add new rightmost element", type: .process),
                AlgorithmStep(title: "Update Sum", description: "Update window sum efficiently: sum = sum - left + right", type: .process),
                AlgorithmStep(title: "Compare Maximum", description: "Check if current sum is greater than maximum", type: .decision),
                AlgorithmStep(title: "Update Maximum", description: "If current sum > max, update maximum", type: .success),
                AlgorithmStep(title: "Continue Sliding", description: "Repeat until window reaches end of array", type: .process),
                AlgorithmStep(title: "Return Result", description: "Return the maximum sum found", type: .end)
            ]
        )
    }
}
