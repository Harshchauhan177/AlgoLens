//
//  NaiveStringMatchingContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func naiveStringMatchingContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Naive String Matching is the simplest pattern matching algorithm that checks for the pattern at every position in the text by comparing characters one by one. It slides the pattern over the text and performs character-by-character comparison.",
            whenToUse: [
                "When the pattern length is very small",
                "For simple text search in small documents",
                "When implementation simplicity is preferred over efficiency",
                "For educational purposes to understand pattern matching"
            ],
            keyIdea: "Slide the pattern over the text one position at a time and check if all characters match at each position.",
            codeImplementations: [
                .pseudocode: """
                function naiveStringMatching(text, pattern):
                    n = length(text)
                    m = length(pattern)
                    
                    for i = 0 to n - m:
                        j = 0
                        while j < m and text[i + j] == pattern[j]:
                            j = j + 1
                        
                        if j == m:
                            print "Pattern found at index", i
                """,
                .c: """
                void naiveStringMatching(char text[], char pattern[]) {
                    int n = strlen(text);
                    int m = strlen(pattern);
                    
                    for (int i = 0; i <= n - m; i++) {
                        int j;
                        for (j = 0; j < m; j++) {
                            if (text[i + j] != pattern[j])
                                break;
                        }
                        if (j == m)
                            printf("Pattern found at index %d\\n", i);
                    }
                }
                """,
                .cpp: """
                void naiveStringMatching(string text, string pattern) {
                    int n = text.length();
                    int m = pattern.length();
                    
                    for (int i = 0; i <= n - m; i++) {
                        int j;
                        for (j = 0; j < m; j++) {
                            if (text[i + j] != pattern[j])
                                break;
                        }
                        if (j == m)
                            cout << "Pattern found at index " << i << endl;
                    }
                }
                """,
                .java: """
                public void naiveStringMatching(String text, String pattern) {
                    int n = text.length();
                    int m = pattern.length();
                    
                    for (int i = 0; i <= n - m; i++) {
                        int j;
                        for (j = 0; j < m; j++) {
                            if (text.charAt(i + j) != pattern.charAt(j))
                                break;
                        }
                        if (j == m)
                            System.out.println("Pattern found at index " + i);
                    }
                }
                """,
                .python: """
                def naive_string_matching(text, pattern):
                    n = len(text)
                    m = len(pattern)
                    
                    for i in range(n - m + 1):
                        j = 0
                        while j < m and text[i + j] == pattern[j]:
                            j += 1
                        
                        if j == m:
                            print(f"Pattern found at index {i}")
                """,
                .swift: """
                func naiveStringMatching(_ text: String, pattern: String) {
                    let textArray = Array(text)
                    let patternArray = Array(pattern)
                    let n = textArray.count
                    let m = patternArray.count
                    
                    for i in 0...(n - m) {
                        var j = 0
                        while j < m && textArray[i + j] == patternArray[j] {
                            j += 1
                        }
                        if j == m {
                            print("Pattern found at index \\(i)")
                        }
                    }
                }
                """,
                .javascript: """
                function naiveStringMatching(text, pattern) {
                    const n = text.length;
                    const m = pattern.length;
                    
                    for (let i = 0; i <= n - m; i++) {
                        let j = 0;
                        while (j < m && text[i + j] === pattern[j]) {
                            j++;
                        }
                        if (j === m) {
                            console.log(`Pattern found at index ${i}`);
                        }
                    }
                }
                """
            ],
            example: AlgorithmExample(
                text: "ABABDABACDABABCABAB",
                pattern: "ABABCABAB",
                expectedOutput: "Pattern found at position: 10",
                explanation: "We check each position in the text and compare the pattern character by character. The pattern 'ABABCABAB' matches starting at index 10 in the text 'ABABDABACDABABCABAB'."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Start at position 0 of the text", type: .start),
                AlgorithmStep(title: "Compare Characters", description: "Compare pattern characters with text from current position", type: .decision),
                AlgorithmStep(title: "Match Found", description: "If all characters match, record the position", type: .success),
                AlgorithmStep(title: "Mismatch", description: "If mismatch occurs, stop comparing at this position", type: .process),
                AlgorithmStep(title: "Slide Pattern", description: "Move to next position in text (shift by 1)", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until pattern reaches end of text", type: .process),
                AlgorithmStep(title: "Complete", description: "All positions checked, search complete", type: .end)
            ]
        )
    }
}
