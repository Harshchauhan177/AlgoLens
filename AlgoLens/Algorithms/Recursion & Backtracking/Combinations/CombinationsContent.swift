////
////  CombinationsContent.swift
////  AlgoLens
////
////  Created by harsh chauhan on 17/01/26.
////
//
//import Foundation
//
//extension AlgorithmContent {
//    static func combinationsContent() -> AlgorithmContent {
//        AlgorithmContent(
//            introduction: """
//            Combinations generate all possible selections of k elements from a set of n elements where order doesn't matter. The number of combinations is denoted as C(n,k) or "n choose k".
//            
//            For example, choosing 2 elements from [1, 2, 3]:
//            [1,2], [1,3], [2,3]
//            
//            Unlike permutations, [1,2] and [2,1] are considered the same combination. This problem is fundamental in probability, statistics, and combinatorial optimization.
//            """,
//            
//            howItWorks: """
//            The algorithm uses backtracking with a start index to avoid duplicates:
//            
//            1. **Start Position**: Begin with a start index to prevent picking earlier elements
//            
//            2. **Build Combination**: At each step:
//               • Add current element to combination
//               • Only consider elements after current position
//            
//            3. **Size Check**: 
//               • If combination size equals k, add to results
//               • Otherwise, continue building
//            
//            4. **Explore Forward**: Recursively choose from remaining elements
//            
//            5. **Backtrack**: Remove last element and try next option
//            
//            **Key Difference from Permutations**:
//            • Use start index to ensure we only pick elements forward
//            • This prevents generating [2,1] when we already have [1,2]
//            
//            **Formula**: C(n,k) = n! / (k! × (n-k)!)
//            
//            **Pruning**: Start index ensures we don't revisit combinations in different orders.
//            """,
//            
//            realWorldApplications: """
//            • **Lottery Systems**: Calculating winning probabilities
//            • **Team Selection**: Choosing members from a pool
//            • **Committee Formation**: Selecting representatives
//            • **Sampling**: Statistical sampling methods
//            • **Feature Selection**: Machine learning feature combinations
//            • **Portfolio Optimization**: Selecting investment combinations
//            • **Tournament Scheduling**: Creating match pairings
//            • **Genetics**: Gene combination analysis
//            """,
//            
//            codeExample: """
//            func combine(_ n: Int, _ k: Int) -> [[Int]] {
//                var result: [[Int]] = []
//                var current: [Int] = []
//                
//                func backtrack(_ start: Int) {
//                    // Base case: combination is complete
//                    if current.count == k {
//                        result.append(current)
//                        return
//                    }
//                    
//                    // Try all numbers from start to n
//                    for i in start...n {
//                        // Choose
//                        current.append(i)
//                        
//                        // Explore (only elements after current)
//                        backtrack(i + 1)
//                        
//                        // Unchoose (Backtrack)
//                        current.removeLast()
//                    }
//                }
//                
//                backtrack(1)
//                return result
//            }
//            
//            // Alternative: Choose from array
//            func combineArray(_ nums: [Int], _ k: Int) -> [[Int]] {
//                var result: [[Int]] = []
//                var current: [Int] = []
//                
//                func backtrack(_ start: Int) {
//                    if current.count == k {
//                        result.append(current)
//                        return
//                    }
//                    
//                    for i in start..<nums.count {
//                        current.append(nums[i])
//                        backtrack(i + 1)
//                        current.removeLast()
//                    }
//                }
//                
//                backtrack(0)
//                return result
//            }
//            
//            // Example usage
//            let combinations = combine(4, 2)
//            print("C(4,2) = \\(combinations.count) combinations: \\(combinations)")
//            // Output: 6 combinations: [[1,2], [1,3], [1,4], [2,3], [2,4], [3,4]]
//            """
//        )
//    }
//}
