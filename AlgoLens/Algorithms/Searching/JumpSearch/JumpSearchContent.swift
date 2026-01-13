//
//  JumpSearchContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 13/01/26.
//

import Foundation

extension AlgorithmContent {
    static func jumpSearchContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Jump Search works by jumping ahead by fixed steps in a sorted array, then performing a linear search in the identified block. The optimal jump size is √n, which provides a good balance between jumping too far and jumping too little.",
            whenToUse: [
                "When array is sorted",
                "For medium-sized sorted datasets",
                "When binary search is not suitable (e.g., backward jumping is costly)",
                "Better than linear search for sorted arrays",
                "When you want simpler implementation than binary search"
            ],
            keyIdea: "Jump ahead by √n steps to find the block containing the target, then perform linear search within that block. This achieves O(√n) time complexity.",
            codeImplementations: [
                .pseudocode: """
                function jumpSearch(array, target):
                    n = length(array)
                    step = sqrt(n)
                    prev = 0
                    
                    // Jump to find block
                    while array[min(step, n)-1] < target:
                        prev = step
                        step += sqrt(n)
                        if prev >= n:
                            return -1
                    
                    // Linear search in block
                    while array[prev] < target:
                        prev++
                        if prev == min(step, n):
                            return -1
                    
                    // Check if found
                    if array[prev] == target:
                        return prev
                    
                    return -1
                """,
                .swift: """
                func jumpSearch(_ array: [Int], target: Int) -> Int? {
                    let n = array.count
                    let step = Int(sqrt(Double(n)))
                    var prev = 0
                    var curr = step - 1
                    
                    // Jump to find the block
                    while curr < n && array[curr] < target {
                        prev = curr + 1
                        curr = min(curr + step, n - 1)
                    }
                    
                    // Linear search within block
                    for i in prev...min(curr, n - 1) {
                        if array[i] == target {
                            return i
                        }
                    }
                    
                    return nil
                }
                
                // Example usage:
                let numbers = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
                if let index = jumpSearch(numbers, target: 13) {
                    print("Found at index \\(index)")
                } else {
                    print("Not found")
                }
                """,
                .python: """
                import math
                
                def jump_search(array, target):
                    n = len(array)
                    step = int(math.sqrt(n))
                    prev = 0
                    
                    # Jump to find the block
                    while prev < n and array[min(step, n) - 1] < target:
                        prev = step
                        step += int(math.sqrt(n))
                        if prev >= n:
                            return -1
                    
                    # Linear search within block
                    while prev < n and array[prev] < target:
                        prev += 1
                        if prev == min(step, n):
                            return -1
                    
                    # Check if found
                    if prev < n and array[prev] == target:
                        return prev
                    
                    return -1
                
                # Example usage:
                numbers = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
                index = jump_search(numbers, 13)
                if index != -1:
                    print(f"Found at index {index}")
                else:
                    print("Not found")
                """,
                .java: """
                public class JumpSearch {
                    public static int jumpSearch(int[] array, int target) {
                        int n = array.length;
                        int step = (int) Math.sqrt(n);
                        int prev = 0;
                        
                        // Jump to find the block
                        while (prev < n && array[Math.min(step, n) - 1] < target) {
                            prev = step;
                            step += (int) Math.sqrt(n);
                            if (prev >= n) {
                                return -1;
                            }
                        }
                        
                        // Linear search within block
                        while (prev < n && array[prev] < target) {
                            prev++;
                            if (prev == Math.min(step, n)) {
                                return -1;
                            }
                        }
                        
                        // Check if found
                        if (prev < n && array[prev] == target) {
                            return prev;
                        }
                        
                        return -1;
                    }
                    
                    public static void main(String[] args) {
                        int[] numbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
                        int index = jumpSearch(numbers, 13);
                        if (index != -1) {
                            System.out.println("Found at index " + index);
                        } else {
                            System.out.println("Not found");
                        }
                    }
                }
                """,
                .cpp: """
                #include <iostream>
                #include <cmath>
                #include <vector>
                
                int jumpSearch(const std::vector<int>& array, int target) {
                    int n = array.size();
                    int step = sqrt(n);
                    int prev = 0;
                    
                    // Jump to find the block
                    while (prev < n && array[std::min(step, n) - 1] < target) {
                        prev = step;
                        step += sqrt(n);
                        if (prev >= n) {
                            return -1;
                        }
                    }
                    
                    // Linear search within block
                    while (prev < n && array[prev] < target) {
                        prev++;
                        if (prev == std::min(step, n)) {
                            return -1;
                        }
                    }
                    
                    // Check if found
                    if (prev < n && array[prev] == target) {
                        return prev;
                    }
                    
                    return -1;
                }
                
                int main() {
                    std::vector<int> numbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
                    int index = jumpSearch(numbers, 13);
                    if (index != -1) {
                        std::cout << "Found at index " << index << std::endl;
                    } else {
                        std::cout << "Not found" << std::endl;
                    }
                    return 0;
                }
                """,
                .javascript: """
                function jumpSearch(array, target) {
                    const n = array.length;
                    const step = Math.floor(Math.sqrt(n));
                    let prev = 0;
                    let curr = step - 1;
                    
                    // Jump to find the block
                    while (curr < n && array[curr] < target) {
                        prev = curr + 1;
                        curr = Math.min(curr + step, n - 1);
                    }
                    
                    // Linear search within block
                    for (let i = prev; i <= Math.min(curr, n - 1); i++) {
                        if (array[i] === target) {
                            return i;
                        }
                    }
                    
                    return -1;
                }
                
                // Example usage:
                const numbers = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
                const index = jumpSearch(numbers, 13);
                if (index !== -1) {
                    console.log(`Found at index ${index}`);
                } else {
                    console.log("Not found");
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [1, 3, 4, 6, 7, 9, 12, 15, 18],
                target: 12,
                expectedOutput: "Found at index 6",
                explanation: "With array size 9, jump size is √9 = 3. Jump to indices 2, 5, 8. At index 8 (value 18), we find 18 > 12, so we linear search from index 6 to 8 and find 12 at index 6."
            ),
            steps: [
                AlgorithmStep(
                    title: "Calculate Jump Size",
                    description: "Calculate optimal jump size as √n where n is the array length",
                    type: .start
                ),
                AlgorithmStep(
                    title: "Jump Forward",
                    description: "Jump ahead by step size until finding a value >= target",
                    type: .process
                ),
                AlgorithmStep(
                    title: "Check Block",
                    description: "Compare current element with target to determine if target is in this block",
                    type: .decision
                ),
                AlgorithmStep(
                    title: "Continue Jumping",
                    description: "If current value < target, continue jumping forward",
                    type: .process
                ),
                AlgorithmStep(
                    title: "Linear Search",
                    description: "Once block is identified, perform linear search within that block",
                    type: .process
                ),
                AlgorithmStep(
                    title: "Return Result",
                    description: "Return index if found, -1 if not found in the block",
                    type: .end
                )
            ]
        )
    }
}
