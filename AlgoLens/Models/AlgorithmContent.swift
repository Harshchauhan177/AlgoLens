//
//  AlgorithmContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import Foundation

// MARK: - Algorithm Content Model
struct AlgorithmContent {
    let algorithm: Algorithm
    let explanation: String
    let whenToUse: [String]
    let keyIdea: String
    let pseudocode: String
    let example: AlgorithmExample
    let steps: [String]
    
    struct AlgorithmExample {
        let inputArray: [Int]
        let target: Int
        let expectedOutput: String
        let explanation: String
    }
}

// MARK: - Content Data
extension AlgorithmContent {
    static func content(for algorithm: Algorithm) -> AlgorithmContent {
        switch algorithm.name {
        case "Linear Search":
            return linearSearchContent(algorithm: algorithm)
        case "Binary Search":
            return binarySearchContent(algorithm: algorithm)
        case "Jump Search":
            return jumpSearchContent(algorithm: algorithm)
        case "Interpolation Search":
            return interpolationSearchContent(algorithm: algorithm)
        case "Exponential Search":
            return exponentialSearchContent(algorithm: algorithm)
        case "Fibonacci Search":
            return fibonacciSearchContent(algorithm: algorithm)
        default:
            return defaultContent(algorithm: algorithm)
        }
    }
    
    // MARK: - Linear Search Content
    private static func linearSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Linear Search is the simplest searching algorithm that checks every element in the array sequentially until the target element is found or the end of the array is reached.",
            whenToUse: [
                "When the array is unsorted",
                "For small datasets",
                "When you need to find the first occurrence",
                "When simplicity is more important than speed"
            ],
            keyIdea: "Check each element one by one from left to right until you find the target or reach the end.",
            pseudocode: """
            function linearSearch(array, target):
                for i = 0 to length(array) - 1:
                    if array[i] == target:
                        return i
                return -1 (not found)
            """,
            example: AlgorithmExample(
                inputArray: [4, 7, 1, 9, 3, 6],
                target: 9,
                expectedOutput: "Found at index 3",
                explanation: "We check each element: 4, 7, 1, then find 9 at index 3."
            ),
            steps: [
                "Start at index 0 (first element)",
                "Compare current element with target",
                "If match found, return the index",
                "If not match, move to next element",
                "Repeat until target found or array ends",
                "If array ends without finding, return -1"
            ]
        )
    }
    
    // MARK: - Binary Search Content
    private static func binarySearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Binary Search is an efficient algorithm that finds a target value in a sorted array by repeatedly dividing the search interval in half.",
            whenToUse: [
                "When the array is sorted",
                "For large datasets",
                "When you need fast search performance",
                "When random access is available"
            ],
            keyIdea: "Divide the search space in half with each comparison, eliminating half of the remaining elements.",
            pseudocode: """
            function binarySearch(array, target):
                left = 0, right = length(array) - 1
                while left <= right:
                    mid = (left + right) / 2
                    if array[mid] == target:
                        return mid
                    else if array[mid] < target:
                        left = mid + 1
                    else:
                        right = mid - 1
                return -1 (not found)
            """,
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Check middle (4), target is larger. Check right half's middle (7), target is smaller. Find 6 at index 3."
            ),
            steps: [
                "Set left pointer to start, right to end",
                "Calculate middle index",
                "Compare middle element with target",
                "If match, return middle index",
                "If target is smaller, search left half",
                "If target is larger, search right half",
                "Repeat until found or pointers cross"
            ]
        )
    }
    
    // MARK: - Jump Search Content
    private static func jumpSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Jump Search works by jumping ahead by fixed steps in a sorted array, then performing a linear search in the identified block.",
            whenToUse: [
                "When array is sorted",
                "For medium-sized sorted datasets",
                "When binary search is not suitable",
                "Better than linear for sorted arrays"
            ],
            keyIdea: "Jump ahead by √n steps to find the block containing the target, then search linearly within that block.",
            pseudocode: """
            function jumpSearch(array, target):
                n = length(array)
                step = sqrt(n)
                prev = 0
                while array[min(step, n)-1] < target:
                    prev = step
                    step += sqrt(n)
                    if prev >= n:
                        return -1
                while array[prev] < target:
                    prev++
                    if prev == min(step, n):
                        return -1
                if array[prev] == target:
                    return prev
                return -1
            """,
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Jump by √6 ≈ 2 steps. Find block [4,6,7], then linear search finds 6."
            ),
            steps: [
                "Calculate optimal jump size (√n)",
                "Jump ahead by step size",
                "Check if target is in current block",
                "If target is larger, continue jumping",
                "Once block is identified, do linear search",
                "Return index if found, -1 otherwise"
            ]
        )
    }
    
    // MARK: - Interpolation Search Content
    private static func interpolationSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Interpolation Search improves Binary Search by estimating the position of the target based on its value, similar to how humans search in a dictionary.",
            whenToUse: [
                "When array is sorted and uniformly distributed",
                "For large datasets with even distribution",
                "When data follows a predictable pattern",
                "Better than binary for uniform data"
            ],
            keyIdea: "Estimate the likely position of the target using interpolation formula based on value distribution.",
            pseudocode: """
            function interpolationSearch(array, target):
                low = 0, high = length(array) - 1
                while low <= high and target >= array[low] and target <= array[high]:
                    if low == high:
                        if array[low] == target:
                            return low
                        return -1
                    pos = low + ((target - array[low]) * (high - low)) / (array[high] - array[low])
                    if array[pos] == target:
                        return pos
                    if array[pos] < target:
                        low = pos + 1
                    else:
                        high = pos - 1
                return -1
            """,
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Estimate position based on value. Target 6 is likely near middle-right."
            ),
            steps: [
                "Set low and high pointers",
                "Calculate estimated position using interpolation",
                "Compare element at estimated position",
                "If match, return position",
                "If target is smaller, search left portion",
                "If target is larger, search right portion",
                "Repeat until found or range exhausted"
            ]
        )
    }
    
    // MARK: - Exponential Search Content
    private static func exponentialSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Exponential Search finds the range where the target element exists by exponentially increasing the index, then performs binary search in that range.",
            whenToUse: [
                "When array is unbounded or very large",
                "When target is likely near the beginning",
                "For sorted arrays",
                "When you want to combine linear and binary search benefits"
            ],
            keyIdea: "Find the range [2^k-1, 2^k] containing the target by doubling the index, then use binary search.",
            pseudocode: """
            function exponentialSearch(array, target):
                if array[0] == target:
                    return 0
                i = 1
                n = length(array)
                while i < n and array[i] <= target:
                    i = i * 2
                return binarySearch(array, i/2, min(i, n-1), target)
            """,
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Check indices 1, 2, 4. Find range [2,4], then binary search finds 6."
            ),
            steps: [
                "Check if first element is target",
                "Start with i = 1",
                "Double i until array[i] > target or end",
                "Identified range is [i/2, i]",
                "Perform binary search in this range",
                "Return result from binary search"
            ]
        )
    }
    
    // MARK: - Fibonacci Search Content
    private static func fibonacciSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Fibonacci Search divides the array into unequal parts using Fibonacci numbers, similar to binary search but with Fibonacci intervals.",
            whenToUse: [
                "When array is sorted",
                "For large datasets",
                "When division operation is costly",
                "As an alternative to binary search"
            ],
            keyIdea: "Use Fibonacci numbers to divide the array and narrow down the search range without division operations.",
            pseudocode: """
            function fibonacciSearch(array, target):
                fibM2 = 0, fibM1 = 1
                fibM = fibM2 + fibM1
                while fibM < length(array):
                    fibM2 = fibM1
                    fibM1 = fibM
                    fibM = fibM2 + fibM1
                offset = -1
                while fibM > 1:
                    i = min(offset + fibM2, length(array) - 1)
                    if array[i] < target:
                        fibM = fibM1, fibM1 = fibM2
                        fibM2 = fibM - fibM1
                        offset = i
                    else if array[i] > target:
                        fibM = fibM2, fibM1 = fibM1 - fibM2
                        fibM2 = fibM - fibM1
                    else:
                        return i
                if fibM1 and array[offset+1] == target:
                    return offset + 1
                return -1
            """,
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Use Fibonacci numbers (1,1,2,3,5,8) to divide array and find target."
            ),
            steps: [
                "Find smallest Fibonacci number >= array length",
                "Initialize Fibonacci numbers: fibM, fibM1, fibM2",
                "Compare target with element at Fibonacci position",
                "If match, return index",
                "If target is larger, eliminate left portion",
                "If target is smaller, eliminate right portion",
                "Adjust Fibonacci numbers and repeat"
            ]
        )
    }
    
    // MARK: - Default Content
    private static func defaultContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "This algorithm helps you search or sort data efficiently.",
            whenToUse: [
                "Based on your data structure",
                "Depending on performance needs",
                "Consider time and space complexity"
            ],
            keyIdea: "Understanding the algorithm concept is key to using it effectively.",
            pseudocode: """
            function algorithm(input):
                // Algorithm steps here
                return result
            """,
            example: AlgorithmExample(
                inputArray: [1, 2, 3, 4, 5],
                target: 3,
                expectedOutput: "Found",
                explanation: "Example explanation will be shown here."
            ),
            steps: [
                "Step 1: Initialize variables",
                "Step 2: Process data",
                "Step 3: Return result"
            ]
        )
    }
}
