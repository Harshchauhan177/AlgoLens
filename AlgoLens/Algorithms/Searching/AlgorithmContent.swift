//
//  AlgorithmContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/25.
//

import Foundation

// MARK: - Programming Language Enum
enum ProgrammingLanguage: String, CaseIterable {
    case pseudocode = "Pseudocode"
    case c = "C"
    case cpp = "C++"
    case java = "Java"
    case python = "Python"
    case swift = "Swift"
    case javascript = "JavaScript"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String? {
        switch self {
        case .pseudocode:
            return "doc.text"
        case .c:
            return "c.circle"
        case .cpp:
            return "c.circle.fill"
        case .java:
            return "cup.and.saucer"
        case .python:
            return "snake"
        case .swift:
            return "swift"
        case .javascript:
            return "j.circle"
        }
    }
}

// MARK: - Algorithm Content Model
struct AlgorithmContent {
    let algorithm: Algorithm
    let explanation: String
    let whenToUse: [String]
    let keyIdea: String
    let codeImplementations: [ProgrammingLanguage: String]
    let example: AlgorithmExample
    let steps: [AlgorithmStep]
    
    struct AlgorithmExample {
        let inputArray: [Int]
        let target: Int
        let expectedOutput: String
        let explanation: String
    }
    
    struct AlgorithmStep {
        let title: String
        let description: String
        let type: StepType
        
        enum StepType {
            case start
            case process
            case decision
            case success
            case end
        }
    }
    
    // Helper to get code for a language
    func code(for language: ProgrammingLanguage) -> String {
        return codeImplementations[language] ?? codeImplementations[.pseudocode] ?? "Code not available"
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
            codeImplementations: [
                .pseudocode: """
                function linearSearch(array, target):
                    for i = 0 to length(array) - 1:
                        if array[i] == target:
                            return i
                    return -1 (not found)
                """,
                .c: """
                int linearSearch(int arr[], int n, int target) {
                    for (int i = 0; i < n; i++) {
                        if (arr[i] == target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """,
                .cpp: """
                int linearSearch(vector<int>& arr, int target) {
                    for (int i = 0; i < arr.size(); i++) {
                        if (arr[i] == target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """,
                .java: """
                public int linearSearch(int[] arr, int target) {
                    for (int i = 0; i < arr.length; i++) {
                        if (arr[i] == target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """,
                .python: """
                def linear_search(arr, target):
                    for i in range(len(arr)):
                        if arr[i] == target:
                            return i
                    return -1
                """,
                .swift: """
                func linearSearch(_ arr: [Int], target: Int) -> Int? {
                    for (index, value) in arr.enumerated() {
                        if value == target {
                            return index
                        }
                    }
                    return nil
                }
                """,
                .javascript: """
                function linearSearch(arr, target) {
                    for (let i = 0; i < arr.length; i++) {
                        if (arr[i] === target) {
                            return i;
                        }
                    }
                    return -1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [4, 7, 1, 9, 3, 6],
                target: 9,
                expectedOutput: "Found at index 3",
                explanation: "We check each element: 4, 7, 1, then find 9 at index 3."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Start at index 0 (first element)", type: .start),
                AlgorithmStep(title: "Compare", description: "Compare current element with target value", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match found, return the current index", type: .success),
                AlgorithmStep(title: "Move Next", description: "If not match, move to next element (i++)", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until target found or array ends", type: .process),
                AlgorithmStep(title: "Not Found", description: "If array ends without finding, return -1", type: .end)
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
            codeImplementations: [
                .pseudocode: """
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
                .c: """
                int binarySearch(int arr[], int n, int target) {
                    int left = 0, right = n - 1;
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """,
                .cpp: """
                int binarySearch(vector<int>& arr, int target) {
                    int left = 0, right = arr.size() - 1;
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """,
                .java: """
                public int binarySearch(int[] arr, int target) {
                    int left = 0, right = arr.length - 1;
                    while (left <= right) {
                        int mid = left + (right - left) / 2;
                        if (arr[mid] == target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """,
                .python: """
                def binary_search(arr, target):
                    left, right = 0, len(arr) - 1
                    while left <= right:
                        mid = (left + right) // 2
                        if arr[mid] == target:
                            return mid
                        elif arr[mid] < target:
                            left = mid + 1
                        else:
                            right = mid - 1
                    return -1
                """,
                .swift: """
                func binarySearch(_ arr: [Int], target: Int) -> Int? {
                    var left = 0, right = arr.count - 1
                    while left <= right {
                        let mid = left + (right - left) / 2
                        if arr[mid] == target {
                            return mid
                        } else if arr[mid] < target {
                            left = mid + 1
                        } else {
                            right = mid - 1
                        }
                    }
                    return nil
                }
                """,
                .javascript: """
                function binarySearch(arr, target) {
                    let left = 0, right = arr.length - 1;
                    while (left <= right) {
                        const mid = Math.floor((left + right) / 2);
                        if (arr[mid] === target)
                            return mid;
                        if (arr[mid] < target)
                            left = mid + 1;
                        else
                            right = mid - 1;
                    }
                    return -1;
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Check middle (4), target is larger. Check right half's middle (7), target is smaller. Find 6 at index 3."
            ),
            steps: [
                AlgorithmStep(title: "Initialize Pointers", description: "Set left pointer to start, right to end", type: .start),
                AlgorithmStep(title: "Find Middle", description: "Calculate middle index: mid = (left + right) / 2", type: .process),
                AlgorithmStep(title: "Compare", description: "Compare middle element with target", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match, return middle index", type: .success),
                AlgorithmStep(title: "Search Left", description: "If target is smaller, search left half (right = mid - 1)", type: .process),
                AlgorithmStep(title: "Search Right", description: "If target is larger, search right half (left = mid + 1)", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until found or pointers cross", type: .end)
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
            codeImplementations: [
                .pseudocode: """
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
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Jump by √6 ≈ 2 steps. Find block [4,6,7], then linear search finds 6."
            ),
            steps: [
                AlgorithmStep(title: "Calculate Jump", description: "Calculate optimal jump size (√n)", type: .start),
                AlgorithmStep(title: "Jump Ahead", description: "Jump ahead by step size", type: .process),
                AlgorithmStep(title: "Check Block", description: "Check if target is in current block", type: .decision),
                AlgorithmStep(title: "Continue", description: "If target is larger, continue jumping", type: .process),
                AlgorithmStep(title: "Linear Search", description: "Once block is identified, do linear search", type: .process),
                AlgorithmStep(title: "Result", description: "Return index if found, -1 otherwise", type: .end)
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
            codeImplementations: [
                .pseudocode: """
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
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Estimate position based on value. Target 6 is likely near middle-right."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set low and high pointers", type: .start),
                AlgorithmStep(title: "Estimate Position", description: "Calculate estimated position using interpolation", type: .process),
                AlgorithmStep(title: "Compare", description: "Compare element at estimated position", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match, return position", type: .success),
                AlgorithmStep(title: "Search Left", description: "If target is smaller, search left portion", type: .process),
                AlgorithmStep(title: "Search Right", description: "If target is larger, search right portion", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until found or range exhausted", type: .end)
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
            codeImplementations: [
                .pseudocode: """
                function exponentialSearch(array, target):
                    if array[0] == target:
                        return 0
                    i = 1
                    n = length(array)
                    while i < n and array[i] <= target:
                        i = i * 2
                    return binarySearch(array, i/2, min(i, n-1), target)
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Check indices 1, 2, 4. Find range [2,4], then binary search finds 6."
            ),
            steps: [
                AlgorithmStep(title: "Check First", description: "Check if first element is target", type: .start),
                AlgorithmStep(title: "Initialize", description: "Start with i = 1", type: .process),
                AlgorithmStep(title: "Double Index", description: "Double i until array[i] > target or end", type: .process),
                AlgorithmStep(title: "Find Range", description: "Identified range is [i/2, i]", type: .decision),
                AlgorithmStep(title: "Binary Search", description: "Perform binary search in this range", type: .process),
                AlgorithmStep(title: "Result", description: "Return result from binary search", type: .end)
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
            codeImplementations: [
                .pseudocode: """
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
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9],
                target: 6,
                expectedOutput: "Found at index 3",
                explanation: "Use Fibonacci numbers (1,1,2,3,5,8) to divide array and find target."
            ),
            steps: [
                AlgorithmStep(title: "Find Fibonacci", description: "Find smallest Fibonacci number >= array length", type: .start),
                AlgorithmStep(title: "Initialize", description: "Initialize Fibonacci numbers: fibM, fibM1, fibM2", type: .process),
                AlgorithmStep(title: "Compare", description: "Compare target with element at Fibonacci position", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If match, return index", type: .success),
                AlgorithmStep(title: "Eliminate Left", description: "If target is larger, eliminate left portion", type: .process),
                AlgorithmStep(title: "Eliminate Right", description: "If target is smaller, eliminate right portion", type: .process),
                AlgorithmStep(title: "Adjust & Repeat", description: "Adjust Fibonacci numbers and repeat", type: .end)
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
            codeImplementations: [
                .pseudocode: """
                function algorithm(input):
                    // Algorithm steps here
                    return result
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 2, 3, 4, 5],
                target: 3,
                expectedOutput: "Found",
                explanation: "Example explanation will be shown here."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Initialize variables", type: .start),
                AlgorithmStep(title: "Process", description: "Process data", type: .process),
                AlgorithmStep(title: "Return", description: "Return result", type: .end)
            ]
        )
    }
}
