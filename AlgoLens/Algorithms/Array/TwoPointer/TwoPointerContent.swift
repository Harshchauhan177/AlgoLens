//
//  TwoPointerContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func twoPointerContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Two Pointer technique uses two pointers to traverse an array from different positions, typically used to find pairs or solve problems efficiently in O(n) time.",
            whenToUse: [
                "Finding pairs with a target sum in sorted arrays",
                "Removing duplicates from sorted arrays",
                "Reversing an array in-place",
                "Checking if a string is a palindrome"
            ],
            keyIdea: "Use two pointers starting from different positions (usually start and end) and move them based on comparisons to solve the problem efficiently.",
            codeImplementations: [
                .pseudocode: """
                function twoPointerSum(array, target):
                    left = 0, right = length(array) - 1
                    while left < right:
                        sum = array[left] + array[right]
                        if sum == target:
                            return [left, right]
                        else if sum < target:
                            left++
                        else:
                            right--
                    return null
                """,
                .python: """
                def two_pointer_sum(arr, target):
                    left, right = 0, len(arr) - 1
                    while left < right:
                        current_sum = arr[left] + arr[right]
                        if current_sum == target:
                            return (left, right)
                        elif current_sum < target:
                            left += 1
                        else:
                            right -= 1
                    return None
                """,
                .swift: """
                func twoPointerSum(_ arr: [Int], target: Int) -> (Int, Int)? {
                    var left = 0, right = arr.count - 1
                    while left < right {
                        let sum = arr[left] + arr[right]
                        if sum == target {
                            return (left, right)
                        } else if sum < target {
                            left += 1
                        } else {
                            right -= 1
                        }
                    }
                    return nil
                }
                """,
                .java: """
                public int[] twoPointerSum(int[] arr, int target) {
                    int left = 0, right = arr.length - 1;
                    while (left < right) {
                        int sum = arr[left] + arr[right];
                        if (sum == target)
                            return new int[]{left, right};
                        else if (sum < target)
                            left++;
                        else
                            right--;
                    }
                    return null;
                }
                """,
                .cpp: """
                vector<int> twoPointerSum(vector<int>& arr, int target) {
                    int left = 0, right = arr.size() - 1;
                    while (left < right) {
                        int sum = arr[left] + arr[right];
                        if (sum == target)
                            return {left, right};
                        else if (sum < target)
                            left++;
                        else
                            right--;
                    }
                    return {};
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                target: 10,
                expectedOutput: "Pair (1, 9) at indices 0 and 8",
                explanation: "Start with pointers at 1 and 9. Sum is 10, which matches target. Found pair!"
            ),
            steps: [
                AlgorithmStep(title: "Initialize Pointers", description: "Set left pointer at start, right at end", type: .start),
                AlgorithmStep(title: "Calculate Sum", description: "Add values at both pointers", type: .process),
                AlgorithmStep(title: "Check Match", description: "Compare sum with target", type: .decision),
                AlgorithmStep(title: "Move Left", description: "If sum < target, move left pointer right", type: .process),
                AlgorithmStep(title: "Move Right", description: "If sum > target, move right pointer left", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until pointers meet or pair found", type: .end)
            ]
        )
    }
}
