//
//  FibonacciDPContent.swift
//  DPLens
//
//  Created by harsh chauhan on 25/02/26.
//

import Foundation

extension AlgorithmContent {
    static func fibonacciDPContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Fibonacci using Dynamic Programming optimizes the classic recursive approach by storing previously computed values to avoid redundant calculations. This transforms an exponential time algorithm into a linear one.",
            whenToUse: [
                "When you need to calculate large Fibonacci numbers",
                "When recursive solution causes stack overflow",
                "When you want O(n) time instead of O(2^n)",
                "When you need to understand DP fundamentals"
            ],
            keyIdea: "Store each Fibonacci number in an array as you calculate it. Each number is the sum of the previous two: F(n) = F(n-1) + F(n-2).",
            codeImplementations: [
                .pseudocode: """
                function fibonacci(n):
                    if n <= 1:
                        return n
                    
                    dp = array of size (n + 1)
                    dp[0] = 0
                    dp[1] = 1
                    
                    for i from 2 to n:
                        dp[i] = dp[i-1] + dp[i-2]
                    
                    return dp[n]
                """,
                .c: """
                int fibonacci(int n) {
                    if (n <= 1) return n;
                    
                    int dp[n + 1];
                    dp[0] = 0;
                    dp[1] = 1;
                    
                    for (int i = 2; i <= n; i++) {
                        dp[i] = dp[i-1] + dp[i-2];
                    }
                    
                    return dp[n];
                }
                """,
                .cpp: """
                int fibonacci(int n) {
                    if (n <= 1) return n;
                    
                    vector<int> dp(n + 1);
                    dp[0] = 0;
                    dp[1] = 1;
                    
                    for (int i = 2; i <= n; i++) {
                        dp[i] = dp[i-1] + dp[i-2];
                    }
                    
                    return dp[n];
                }
                """,
                .java: """
                public int fibonacci(int n) {
                    if (n <= 1) return n;
                    
                    int[] dp = new int[n + 1];
                    dp[0] = 0;
                    dp[1] = 1;
                    
                    for (int i = 2; i <= n; i++) {
                        dp[i] = dp[i-1] + dp[i-2];
                    }
                    
                    return dp[n];
                }
                """,
                .python: """
                def fibonacci(n):
                    if n <= 1:
                        return n
                    
                    dp = [0] * (n + 1)
                    dp[0] = 0
                    dp[1] = 1
                    
                    for i in range(2, n + 1):
                        dp[i] = dp[i-1] + dp[i-2]
                    
                    return dp[n]
                """,
                .swift: """
                func fibonacci(_ n: Int) -> Int {
                    if n <= 1 { return n }
                    
                    var dp = Array(repeating: 0, count: n + 1)
                    dp[0] = 0
                    dp[1] = 1
                    
                    for i in 2...n {
                        dp[i] = dp[i-1] + dp[i-2]
                    }
                    
                    return dp[n]
                }
                """,
                .javascript: """
                function fibonacci(n) {
                    if (n <= 1) return n;
                    
                    const dp = new Array(n + 1);
                    dp[0] = 0;
                    dp[1] = 1;
                    
                    for (let i = 2; i <= n; i++) {
                        dp[i] = dp[i-1] + dp[i-2];
                    }
                    
                    return dp[n];
                }
                """
            ],
            steps: [
                AlgorithmStep(title: "Base Case Check", description: "If n ≤ 1, return n directly", type: .decision),
                AlgorithmStep(title: "Create DP Array", description: "Initialize array of size n+1", type: .start),
                AlgorithmStep(title: "Set Base Cases", description: "dp[0] = 0, dp[1] = 1", type: .process),
                AlgorithmStep(title: "Fill DP Table", description: "For i from 2 to n: dp[i] = dp[i-1] + dp[i-2]", type: .process),
                AlgorithmStep(title: "Build Solution", description: "Each position uses previous two values", type: .process),
                AlgorithmStep(title: "Return Result", description: "Return dp[n] as the final answer", type: .success)
            ]
        )
    }
}
