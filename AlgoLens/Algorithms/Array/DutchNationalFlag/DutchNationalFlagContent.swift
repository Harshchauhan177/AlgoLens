//
//  DutchNationalFlagContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func dutchNationalFlagContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "The Dutch National Flag algorithm efficiently sorts an array containing three distinct values (0, 1, 2) in a single pass using three pointers. It partitions the array into three sections: all 0s, all 1s, and all 2s.",
            whenToUse: [
                "Sorting arrays with only three distinct values (0, 1, 2)",
                "Three-way partitioning problems",
                "Color sorting problems (red, white, blue)",
                "Segregating elements into three groups in linear time"
            ],
            keyIdea: "Use three pointers (low, mid, high) to maintain three regions: [0...low-1] contains 0s, [low...mid-1] contains 1s, [mid...high] is unsorted, and [high+1...end] contains 2s. Process elements at mid pointer and swap accordingly.",
            codeImplementations: [
                .pseudocode: """
                function dutchNationalFlag(array):
                    low = 0, mid = 0, high = length(array) - 1
                    while mid <= high:
                        if array[mid] == 0:
                            swap(array[low], array[mid])
                            low++, mid++
                        else if array[mid] == 1:
                            mid++
                        else:  // array[mid] == 2
                            swap(array[mid], array[high])
                            high--
                """,
                .python: """
                def dutch_national_flag(arr):
                    low, mid, high = 0, 0, len(arr) - 1
                    while mid <= high:
                        if arr[mid] == 0:
                            arr[low], arr[mid] = arr[mid], arr[low]
                            low += 1
                            mid += 1
                        elif arr[mid] == 1:
                            mid += 1
                        else:  # arr[mid] == 2
                            arr[mid], arr[high] = arr[high], arr[mid]
                            high -= 1
                    return arr
                """,
                .swift: """
                func dutchNationalFlag(_ arr: inout [Int]) {
                    var low = 0, mid = 0, high = arr.count - 1
                    while mid <= high {
                        if arr[mid] == 0 {
                            arr.swapAt(low, mid)
                            low += 1
                            mid += 1
                        } else if arr[mid] == 1 {
                            mid += 1
                        } else {
                            arr.swapAt(mid, high)
                            high -= 1
                        }
                    }
                }
                """,
                .java: """
                public void dutchNationalFlag(int[] arr) {
                    int low = 0, mid = 0, high = arr.length - 1;
                    while (mid <= high) {
                        if (arr[mid] == 0) {
                            swap(arr, low, mid);
                            low++;
                            mid++;
                        } else if (arr[mid] == 1) {
                            mid++;
                        } else {
                            swap(arr, mid, high);
                            high--;
                        }
                    }
                }
                """,
                .cpp: """
                void dutchNationalFlag(vector<int>& arr) {
                    int low = 0, mid = 0, high = arr.size() - 1;
                    while (mid <= high) {
                        if (arr[mid] == 0) {
                            swap(arr[low], arr[mid]);
                            low++;
                            mid++;
                        } else if (arr[mid] == 1) {
                            mid++;
                        } else {
                            swap(arr[mid], arr[high]);
                            high--;
                        }
                    }
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [2, 0, 1, 2, 1, 0],
                target: 0,
                expectedOutput: "[0, 0, 1, 1, 2, 2]",
                explanation: "After sorting: all 0s first, then all 1s, then all 2s"
            ),
            steps: [
                AlgorithmStep(title: "Initialize Pointers", description: "Set low=0, mid=0, high=n-1", type: .start),
                AlgorithmStep(title: "Check Mid Element", description: "Examine value at mid pointer", type: .decision),
                AlgorithmStep(title: "Process 0", description: "If 0: swap with low, move both low and mid right", type: .process),
                AlgorithmStep(title: "Process 1", description: "If 1: already in place, just move mid right", type: .process),
                AlgorithmStep(title: "Process 2", description: "If 2: swap with high, move high left", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until mid > high", type: .end)
            ]
        )
    }
}
