//
//  SubarraySumContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func subarraySumContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Subarray Sum algorithm uses prefix sum hashing to efficiently find contiguous subarrays that sum to a target value. It maintains a running sum and stores prefix sums in a hash map, allowing O(1) lookup to detect subarrays.",
            whenToUse: [
                "Finding subarrays with a given target sum",
                "Continuous subarray problems with sum constraints",
                "Problems requiring O(n) time instead of O(n²)",
                "When you need to find all or any subarray with specific sum"
            ],
            keyIdea: "Store prefix sums in a hash map with their indices. If (current_sum - target) exists in the map, a subarray with target sum is found between that index and current index. This works because sum[i...j] = prefix_sum[j] - prefix_sum[i-1].",
            codeImplementations: [
                .pseudocode: """
                function subarraySum(array, target):
                    sum = 0, prefix_sums = {0: -1}
                    for i = 0 to length(array) - 1:
                        sum += array[i]
                        if (sum - target) in prefix_sums:
                            start = prefix_sums[sum - target] + 1
                            return [start, i]
                        prefix_sums[sum] = i
                    return null
                """,
                .python: """
                def subarray_sum(arr, target):
                    current_sum = 0
                    prefix_sums = {0: -1}
                    
                    for i, num in enumerate(arr):
                        current_sum += num
                        if (current_sum - target) in prefix_sums:
                            start = prefix_sums[current_sum - target] + 1
                            return (start, i)
                        prefix_sums[current_sum] = i
                    
                    return None
                """,
                .swift: """
                func subarraySum(_ arr: [Int], target: Int) -> (Int, Int)? {
                    var sum = 0
                    var prefixSums: [Int: Int] = [0: -1]
                    
                    for (i, num) in arr.enumerated() {
                        sum += num
                        if let startIndex = prefixSums[sum - target] {
                            return (startIndex + 1, i)
                        }
                        prefixSums[sum] = i
                    }
                    return nil
                }
                """,
                .java: """
                public int[] subarraySum(int[] arr, int target) {
                    int sum = 0;
                    Map<Integer, Integer> prefixSums = new HashMap<>();
                    prefixSums.put(0, -1);
                    
                    for (int i = 0; i < arr.length; i++) {
                        sum += arr[i];
                        if (prefixSums.containsKey(sum - target)) {
                            int start = prefixSums.get(sum - target) + 1;
                            return new int[]{start, i};
                        }
                        prefixSums.put(sum, i);
                    }
                    return null;
                }
                """,
                .cpp: """
                vector<int> subarraySum(vector<int>& arr, int target) {
                    int sum = 0;
                    unordered_map<int, int> prefixSums;
                    prefixSums[0] = -1;
                    
                    for (int i = 0; i < arr.size(); i++) {
                        sum += arr[i];
                        if (prefixSums.find(sum - target) != prefixSums.end()) {
                            int start = prefixSums[sum - target] + 1;
                            return {start, i};
                        }
                        prefixSums[sum] = i;
                    }
                    return {};
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 2, 3, 7, 5],
                target: 12,
                expectedOutput: "Subarray [2, 3, 7] from indices 1 to 3",
                explanation: "Elements from index 1 to 3 sum to 12. Found by checking if prefix_sum[3] - target exists in hash map."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set sum=0, create hash map with {0: -1}", type: .start),
                AlgorithmStep(title: "Add Element", description: "Add current element to running sum", type: .process),
                AlgorithmStep(title: "Check Hash Map", description: "Look for (sum - target) in hash map", type: .decision),
                AlgorithmStep(title: "Found Match", description: "If found, subarray exists from stored index+1 to current", type: .process),
                AlgorithmStep(title: "Store Sum", description: "Store current sum with its index in hash map", type: .process),
                AlgorithmStep(title: "Continue", description: "Repeat until subarray found or array ends", type: .end)
            ]
        )
    }
}
