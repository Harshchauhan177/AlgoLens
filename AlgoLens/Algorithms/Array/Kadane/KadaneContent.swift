//
//  KadaneContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func kadaneContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Kadane's Algorithm finds the maximum sum contiguous subarray in O(n) time. At each position, it decides whether to extend the current subarray or start a new one, keeping track of the maximum sum found.",
            whenToUse: [
                "Finding maximum sum subarray in an array with positive and negative numbers",
                "Stock profit maximization problems",
                "Identifying best time periods in time-series data",
                "Solving problems involving contiguous sequences with optimal sum"
            ],
            keyIdea: "At each element, choose the maximum between extending the current subarray (currentSum + element) or starting fresh (element). Track the global maximum throughout.",
            codeImplementations: [
                .pseudocode: """
                function kadane(array):
                    currentSum = array[0]
                    maxSum = array[0]
                    
                    for i from 1 to length(array)-1:
                        currentSum = max(array[i], currentSum + array[i])
                        maxSum = max(maxSum, currentSum)
                    
                    return maxSum
                """,
                .python: """
                def kadane(arr):
                    current_sum = arr[0]
                    max_sum = arr[0]
                    
                    for i in range(1, len(arr)):
                        current_sum = max(arr[i], current_sum + arr[i])
                        max_sum = max(max_sum, current_sum)
                    
                    return max_sum
                """,
                .swift: """
                func kadane(_ arr: [Int]) -> Int {
                    var currentSum = arr[0]
                    var maxSum = arr[0]
                    
                    for i in 1..<arr.count {
                        currentSum = max(arr[i], currentSum + arr[i])
                        maxSum = max(maxSum, currentSum)
                    }
                    
                    return maxSum
                }
                """,
                .java: """
                public int kadane(int[] arr) {
                    int currentSum = arr[0];
                    int maxSum = arr[0];
                    
                    for (int i = 1; i < arr.length; i++) {
                        currentSum = Math.max(arr[i], currentSum + arr[i]);
                        maxSum = Math.max(maxSum, currentSum);
                    }
                    
                    return maxSum;
                }
                """,
                .cpp: """
                int kadane(vector<int>& arr) {
                    int currentSum = arr[0];
                    int maxSum = arr[0];
                    
                    for (int i = 1; i < arr.size(); i++) {
                        currentSum = max(arr[i], currentSum + arr[i]);
                        maxSum = max(maxSum, currentSum);
                    }
                    
                    return maxSum;
                }
                """,
                .c: """
                int kadane(int arr[], int n) {
                    int currentSum = arr[0];
                    int maxSum = arr[0];
                    
                    for (int i = 1; i < n; i++) {
                        currentSum = (arr[i] > currentSum + arr[i]) ? 
                                     arr[i] : currentSum + arr[i];
                        maxSum = (maxSum > currentSum) ? maxSum : currentSum;
                    }
                    
                    return maxSum;
                }
                """,
                .javascript: """
                function kadane(arr) {
                    let currentSum = arr[0];
                    let maxSum = arr[0];
                    
                    for (let i = 1; i < arr.length; i++) {
                        currentSum = Math.max(arr[i], currentSum + arr[i]);
                        maxSum = Math.max(maxSum, currentSum);
                    }
                    
                    return maxSum;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [-2, 1, -3, 4, -1, 2, 1, -5, 4],
                target: 0,
                expectedOutput: "Max sum: 6",
                explanation: "The subarray [4, -1, 2, 1] has the maximum sum of 6. Kadane's algorithm efficiently finds this by maintaining a running sum and deciding at each step whether to continue or restart."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set currentSum and maxSum to first element", type: .start),
                AlgorithmStep(title: "Process Element", description: "For each element, evaluate two choices", type: .process),
                AlgorithmStep(title: "Extend or Restart", description: "Choose max(element, currentSum + element)", type: .decision),
                AlgorithmStep(title: "Extend Current", description: "If currentSum + element > element, extend the subarray", type: .process),
                AlgorithmStep(title: "Start Fresh", description: "If element > currentSum + element, start new subarray", type: .process),
                AlgorithmStep(title: "Update Maximum", description: "If currentSum > maxSum, update the global maximum", type: .success),
                AlgorithmStep(title: "Continue", description: "Move to next element and repeat", type: .process),
                AlgorithmStep(title: "Return Result", description: "Return the maximum sum found", type: .end)
            ]
        )
    }
}
