//
//  PrefixSumContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func prefixSumContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Prefix Sum precomputes cumulative sums at each position, enabling O(1) range sum queries. The prefix sum at index i stores the sum of all elements from index 0 to i.",
            whenToUse: [
                "Answering multiple range sum queries efficiently",
                "Finding equilibrium index in an array",
                "Solving subarray sum problems",
                "Computing running totals or cumulative statistics"
            ],
            keyIdea: "Preprocess the array once in O(n) time to answer any range query in O(1) time. Range sum [L..R] = prefix[R] - prefix[L-1].",
            codeImplementations: [
                .pseudocode: """
                function buildPrefixSum(array):
                    prefix[0] = array[0]
                    for i from 1 to length(array)-1:
                        prefix[i] = prefix[i-1] + array[i]
                    return prefix
                
                function rangeSum(L, R, prefix):
                    if L == 0:
                        return prefix[R]
                    else:
                        return prefix[R] - prefix[L-1]
                """,
                .python: """
                def build_prefix_sum(arr):
                    prefix = [arr[0]]
                    for i in range(1, len(arr)):
                        prefix.append(prefix[i-1] + arr[i])
                    return prefix
                
                def range_sum(L, R, prefix):
                    if L == 0:
                        return prefix[R]
                    else:
                        return prefix[R] - prefix[L-1]
                """,
                .swift: """
                func buildPrefixSum(_ arr: [Int]) -> [Int] {
                    var prefix = [arr[0]]
                    for i in 1..<arr.count {
                        prefix.append(prefix[i-1] + arr[i])
                    }
                    return prefix
                }
                
                func rangeSum(_ L: Int, _ R: Int, _ prefix: [Int]) -> Int {
                    if L == 0 {
                        return prefix[R]
                    } else {
                        return prefix[R] - prefix[L-1]
                    }
                }
                """,
                .java: """
                public int[] buildPrefixSum(int[] arr) {
                    int[] prefix = new int[arr.length];
                    prefix[0] = arr[0];
                    for (int i = 1; i < arr.length; i++) {
                        prefix[i] = prefix[i-1] + arr[i];
                    }
                    return prefix;
                }
                
                public int rangeSum(int L, int R, int[] prefix) {
                    if (L == 0)
                        return prefix[R];
                    else
                        return prefix[R] - prefix[L-1];
                }
                """,
                .cpp: """
                vector<int> buildPrefixSum(vector<int>& arr) {
                    vector<int> prefix(arr.size());
                    prefix[0] = arr[0];
                    for (int i = 1; i < arr.size(); i++) {
                        prefix[i] = prefix[i-1] + arr[i];
                    }
                    return prefix;
                }
                
                int rangeSum(int L, int R, vector<int>& prefix) {
                    if (L == 0)
                        return prefix[R];
                    else
                        return prefix[R] - prefix[L-1];
                }
                """,
                .c: """
                void buildPrefixSum(int arr[], int prefix[], int n) {
                    prefix[0] = arr[0];
                    for (int i = 1; i < n; i++) {
                        prefix[i] = prefix[i-1] + arr[i];
                    }
                }
                
                int rangeSum(int L, int R, int prefix[]) {
                    if (L == 0)
                        return prefix[R];
                    else
                        return prefix[R] - prefix[L-1];
                }
                """,
                .javascript: """
                function buildPrefixSum(arr) {
                    const prefix = [arr[0]];
                    for (let i = 1; i < arr.length; i++) {
                        prefix.push(prefix[i-1] + arr[i]);
                    }
                    return prefix;
                }
                
                function rangeSum(L, R, prefix) {
                    if (L === 0)
                        return prefix[R];
                    else
                        return prefix[R] - prefix[L-1];
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 2, 3, 4, 5],
                target: 2,
                expectedOutput: "Query [1..3] = 9",
                explanation: "Build prefix sum: [1, 3, 6, 10, 15]. For range [1..3], result = prefix[3] - prefix[0] = 10 - 1 = 9. This is much faster than summing elements each time."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set prefix[0] = array[0]", type: .start),
                AlgorithmStep(title: "Build Array", description: "For each index i, compute prefix[i] = prefix[i-1] + array[i]", type: .process),
                AlgorithmStep(title: "Store Cumulative Sum", description: "Each position stores sum of all elements up to that index", type: .process),
                AlgorithmStep(title: "Complete Build", description: "Prefix sum array is ready", type: .success),
                AlgorithmStep(title: "Range Query", description: "To find sum of range [L..R]", type: .decision),
                AlgorithmStep(title: "Calculate Result", description: "If L=0: return prefix[R], else: return prefix[R] - prefix[L-1]", type: .process),
                AlgorithmStep(title: "O(1) Query", description: "Query answered in constant time!", type: .end)
            ]
        )
    }
}
