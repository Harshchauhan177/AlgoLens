//
//  SubsequenceCheckContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func subsequenceCheckContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Subsequence Check algorithm determines if one string is a subsequence of another by checking if all characters of the first string appear in the second string in the same relative order. A subsequence can be derived by deleting some or no elements without changing the order of remaining elements.",
            whenToUse: [
                "When checking if a pattern exists in a sequence",
                "For DNA sequence matching",
                "In text filtering and search operations",
                "For stream processing and log analysis"
            ],
            keyIdea: "Use two pointers to traverse both strings, advancing the subsequence pointer only when characters match, and the main string pointer always.",
            codeImplementations: [
                .pseudocode: """
                function isSubsequence(s, t):
                    i = 0  // pointer for subsequence
                    j = 0  // pointer for main string
                    
                    while i < length(s) and j < length(t):
                        if s[i] == t[j]:
                            i = i + 1
                        j = j + 1
                    
                    return i == length(s)
                """,
                .c: """
                bool isSubsequence(char* s, char* t) {
                    int i = 0, j = 0;
                    int sLen = strlen(s);
                    int tLen = strlen(t);
                    
                    while (i < sLen && j < tLen) {
                        if (s[i] == t[j]) {
                            i++;
                        }
                        j++;
                    }
                    
                    return i == sLen;
                }
                """,
                .cpp: """
                bool isSubsequence(string s, string t) {
                    int i = 0, j = 0;
                    
                    while (i < s.length() && j < t.length()) {
                        if (s[i] == t[j]) {
                            i++;
                        }
                        j++;
                    }
                    
                    return i == s.length();
                }
                """,
                .java: """
                public boolean isSubsequence(String s, String t) {
                    int i = 0, j = 0;
                    
                    while (i < s.length() && j < t.length()) {
                        if (s.charAt(i) == t.charAt(j)) {
                            i++;
                        }
                        j++;
                    }
                    
                    return i == s.length();
                }
                """,
                .python: """
                def is_subsequence(s, t):
                    i, j = 0, 0
                    
                    while i < len(s) and j < len(t):
                        if s[i] == t[j]):
                            i += 1
                        j += 1
                    
                    return i == len(s)
                """,
                .swift: """
                func isSubsequence(_ s: String, _ t: String) -> Bool {
                    let sArray = Array(s)
                    let tArray = Array(t)
                    var i = 0, j = 0
                    
                    while i < sArray.count && j < tArray.count {
                        if sArray[i] == tArray[j] {
                            i += 1
                        }
                        j += 1
                    }
                    
                    return i == sArray.count
                }
                """,
                .javascript: """
                function isSubsequence(s, t) {
                    let i = 0, j = 0;
                    
                    while (i < s.length && j < t.length) {
                        if (s[i] === t[j]) {
                            i++;
                        }
                        j++;
                    }
                    
                    return i === s.length;
                }
                """
            ],
            example: AlgorithmExample(
                text: "ahbgdc",
                pattern: "abc",
                expectedOutput: "True - 'abc' is a subsequence of 'ahbgdc'",
                explanation: "We check if 'abc' is a subsequence of 'ahbgdc'. The characters 'a', 'b', 'c' appear in order in 'ahbgdc' (positions 0, 2, 5), so it is a valid subsequence."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set two pointers: i=0 for subsequence, j=0 for main string", type: .start),
                AlgorithmStep(title: "Compare Characters", description: "Compare characters at both pointers", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If characters match, advance both pointers", type: .success),
                AlgorithmStep(title: "No Match", description: "If characters don't match, advance only main string pointer", type: .process),
                AlgorithmStep(title: "Continue", description: "Repeat until one string is exhausted", type: .process),
                AlgorithmStep(title: "Check Result", description: "If subsequence pointer reached end, it's a valid subsequence", type: .decision),
                AlgorithmStep(title: "Complete", description: "Return result: true if subsequence found, false otherwise", type: .end)
            ]
        )
    }
}
