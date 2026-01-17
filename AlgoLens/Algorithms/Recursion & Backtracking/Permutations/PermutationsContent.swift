////
////  PermutationsContent.swift
////  AlgoLens
////
////  Created by harsh chauhan on 17/01/26.
////
//
//import Foundation
//
//extension AlgorithmContent {
//    static func permutationsContent() -> AlgorithmContent {
//        AlgorithmContent(
//            introduction: """
//            Permutations generate all possible arrangements of a collection of items where the order matters. For n distinct items, there are n! (n factorial) possible permutations.
//            
//            For example, the permutations of [1, 2, 3] are:
//            [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]
//            
//            This is a fundamental problem in combinatorics with applications in optimization, scheduling, and cryptography.
//            """,
//            
//            howItWorks: """
//            The algorithm uses backtracking with recursion:
//            
//            1. **Start with Empty Arrangement**: Begin building permutation from scratch
//            
//            2. **Choose Element**: At each step, choose an unused element
//            
//            3. **Add to Current Path**: Append chosen element to current permutation
//            
//            4. **Mark as Used**: Track which elements are already in current permutation
//            
//            5. **Recursive Build**:
//               • If all elements used, add permutation to results
//               • Otherwise, recursively choose next element
//            
//            6. **Backtrack**: Remove last element and try next option
//            
//            **Alternative Approach** (Swap Method):
//            • Fix elements one by one
//            • Swap current element with each element after it
//            • Recursively permute remaining elements
//            • Swap back (backtrack)
//            
//            **Key Insight**: Each position can be filled with any unused element, creating n choices for first position, n-1 for second, etc.
//            """,
//            
//            realWorldApplications: """
//            • **Scheduling**: Finding all possible task orderings
//            • **Cryptography**: Generating encryption keys
//            • **Genetic Algorithms**: Creating diverse populations
//            • **Optimization**: Traveling Salesman Problem variations
//            • **Testing**: Generating test case combinations
//            • **Game Development**: Puzzle solving and AI
//            • **Combinatorial Problems**: Exploring solution spaces
//            • **Data Analysis**: Permutation tests in statistics
//            """,
//            
//            codeExample: """
//            func permute(_ nums: [Int]) -> [[Int]] {
//                var result: [[Int]] = []
//                var current: [Int] = []
//                var used = Array(repeating: false, count: nums.count)
//                
//                func backtrack() {
//                    if current.count == nums.count {
//                        result.append(current)
//                        return
//                    }
//                    
//                    for i in 0..<nums.count {
//                        if used[i] { continue }
//                        
//                        // Choose
//                        current.append(nums[i])
//                        used[i] = true
//                        
//                        // Explore
//                        backtrack()
//                        
//                        // Unchoose (Backtrack)
//                        current.removeLast()
//                        used[i] = false
//                    }
//                }
//                
//                backtrack()
//                return result
//            }
//            
//            // Alternative: Swap method
//            func permuteSwap(_ nums: inout [Int], _ start: Int, _ result: inout [[Int]]) {
//                if start == nums.count {
//                    result.append(nums)
//                    return
//                }
//                
//                for i in start..<nums.count {
//                    nums.swapAt(start, i)
//                    permuteSwap(&nums, start + 1, &result)
//                    nums.swapAt(start, i) // Backtrack
//                }
//            }
//            
//            // Example usage
//            let perms = permute([1, 2, 3])
//            print("Found \\(perms.count) permutations: \\(perms)")
//            // Output: 6 permutations
//            """
//        )
//    }
//}
