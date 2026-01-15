//
//  RabinKarpContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func rabinKarpContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Rabin-Karp is an efficient string matching algorithm that uses hashing to find patterns in text. It employs a rolling hash technique to compute hash values for substrings in constant time, making it particularly effective for multiple pattern matching and avoiding unnecessary character comparisons.",
            whenToUse: [
                "When searching for multiple patterns simultaneously",
                "For plagiarism detection in documents",
                "In DNA sequence analysis and bioinformatics",
                "When pattern length is large and hash collisions are rare",
                "For detecting duplicates in large text corpora"
            ],
            keyIdea: "Use hash values to quickly filter potential matches, then verify actual matches character-by-character. Rolling hash allows efficient computation of hash for next window in O(1) time.",
            codeImplementations: [
                .pseudocode: """
                function rabinKarp(text, pattern):
                    n = length(text)
                    m = length(pattern)
                    prime = 101
                    base = 256
                    
                    // Calculate hash of pattern
                    patternHash = hash(pattern)
                    textHash = hash(text[0...m-1])
                    
                    // Calculate highest power for rolling hash
                    h = pow(base, m-1) % prime
                    
                    for i = 0 to n - m:
                        if patternHash == textHash:
                            // Verify character by character
                            if text[i...i+m-1] == pattern:
                                print "Pattern found at index", i
                        
                        if i < n - m:
                            // Calculate rolling hash
                            textHash = (textHash - text[i] * h) * base + text[i+m]
                            textHash = textHash % prime
                """,
                .c: """
                #define d 256
                #define q 101
                
                void rabinKarp(char text[], char pattern[]) {
                    int n = strlen(text);
                    int m = strlen(pattern);
                    int i, j;
                    int p = 0; // hash value for pattern
                    int t = 0; // hash value for text
                    int h = 1;
                    
                    // Calculate h = pow(d, m-1) % q
                    for (i = 0; i < m - 1; i++)
                        h = (h * d) % q;
                    
                    // Calculate hash for pattern and first window
                    for (i = 0; i < m; i++) {
                        p = (d * p + pattern[i]) % q;
                        t = (d * t + text[i]) % q;
                    }
                    
                    // Slide the pattern over text
                    for (i = 0; i <= n - m; i++) {
                        if (p == t) {
                            // Check characters one by one
                            for (j = 0; j < m; j++) {
                                if (text[i + j] != pattern[j])
                                    break;
                            }
                            if (j == m)
                                printf("Pattern found at index %d\\n", i);
                        }
                        
                        // Calculate hash for next window
                        if (i < n - m) {
                            t = (d * (t - text[i] * h) + text[i + m]) % q;
                            if (t < 0)
                                t = t + q;
                        }
                    }
                }
                """,
                .cpp: """
                void rabinKarp(string text, string pattern) {
                    int n = text.length();
                    int m = pattern.length();
                    int d = 256;
                    int q = 101;
                    int h = 1;
                    
                    // Calculate h = pow(d, m-1) % q
                    for (int i = 0; i < m - 1; i++)
                        h = (h * d) % q;
                    
                    // Calculate initial hashes
                    int p = 0, t = 0;
                    for (int i = 0; i < m; i++) {
                        p = (d * p + pattern[i]) % q;
                        t = (d * t + text[i]) % q;
                    }
                    
                    // Slide pattern over text
                    for (int i = 0; i <= n - m; i++) {
                        if (p == t) {
                            bool match = true;
                            for (int j = 0; j < m; j++) {
                                if (text[i + j] != pattern[j]) {
                                    match = false;
                                    break;
                                }
                            }
                            if (match)
                                cout << "Pattern found at index " << i << endl;
                        }
                        
                        if (i < n - m) {
                            t = (d * (t - text[i] * h) + text[i + m]) % q;
                            if (t < 0)
                                t += q;
                        }
                    }
                }
                """,
                .java: """
                public void rabinKarp(String text, String pattern) {
                    int n = text.length();
                    int m = pattern.length();
                    int d = 256;
                    int q = 101;
                    int h = 1;
                    
                    // Calculate h = pow(d, m-1) % q
                    for (int i = 0; i < m - 1; i++)
                        h = (h * d) % q;
                    
                    // Calculate initial hashes
                    int p = 0, t = 0;
                    for (int i = 0; i < m; i++) {
                        p = (d * p + pattern.charAt(i)) % q;
                        t = (d * t + text.charAt(i)) % q;
                    }
                    
                    // Slide pattern over text
                    for (int i = 0; i <= n - m; i++) {
                        if (p == t) {
                            boolean match = true;
                            for (int j = 0; j < m; j++) {
                                if (text.charAt(i + j) != pattern.charAt(j)) {
                                    match = false;
                                    break;
                                }
                            }
                            if (match)
                                System.out.println("Pattern found at index " + i);
                        }
                        
                        if (i < n - m) {
                            t = (d * (t - text.charAt(i) * h) + text.charAt(i + m)) % q;
                            if (t < 0)
                                t += q;
                        }
                    }
                }
                """,
                .python: """
                def rabin_karp(text, pattern):
                    n = len(text)
                    m = len(pattern)
                    d = 256
                    q = 101
                    h = 1
                    
                    # Calculate h = pow(d, m-1) % q
                    for i in range(m - 1):
                        h = (h * d) % q
                    
                    # Calculate initial hashes
                    p = 0
                    t = 0
                    for i in range(m):
                        p = (d * p + ord(pattern[i])) % q
                        t = (d * t + ord(text[i])) % q
                    
                    # Slide pattern over text
                    for i in range(n - m + 1):
                        if p == t:
                            # Check characters one by one
                            if text[i:i+m] == pattern:
                                print(f"Pattern found at index {i}")
                        
                        if i < n - m:
                            t = (d * (t - ord(text[i]) * h) + ord(text[i + m])) % q
                            if t < 0:
                                t += q
                """,
                .swift: """
                func rabinKarp(_ text: String, pattern: String) {
                    let textArray = Array(text)
                    let patternArray = Array(pattern)
                    let n = textArray.count
                    let m = patternArray.count
                    let d = 256
                    let q = 101
                    var h = 1
                    
                    // Calculate h = pow(d, m-1) % q
                    for _ in 0..<(m - 1) {
                        h = (h * d) % q
                    }
                    
                    // Calculate initial hashes
                    var p = 0, t = 0
                    for i in 0..<m {
                        p = (d * p + Int(patternArray[i].asciiValue ?? 0)) % q
                        t = (d * t + Int(textArray[i].asciiValue ?? 0)) % q
                    }
                    
                    // Slide pattern over text
                    for i in 0...(n - m) {
                        if p == t {
                            var match = true
                            for j in 0..<m {
                                if textArray[i + j] != patternArray[j]) {
                                    match = false
                                    break;
                                }
                            }
                            if match {
                                print("Pattern found at index \\(i)")
                            }
                        }
                        
                        if i < n - m {
                            t = (d * (t - Int(textArray[i].asciiValue ?? 0) * h) + Int(textArray[i + m].asciiValue ?? 0)) % q
                            if t < 0 {
                                t += q
                            }
                        }
                    }
                }
                """,
                .javascript: """
                function rabinKarp(text, pattern) {
                    const n = text.length;
                    const m = pattern.length;
                    const d = 256;
                    const q = 101;
                    let h = 1;
                    
                    // Calculate h = pow(d, m-1) % q
                    for (let i = 0; i < m - 1; i++) {
                        h = (h * d) % q;
                    }
                    
                    // Calculate initial hashes
                    let p = 0, t = 0;
                    for (let i = 0; i < m; i++) {
                        p = (d * p + text.charCodeAt(i)) % q;
                        t = (d * t + text.charCodeAt(i)) % q;
                    }
                    
                    // Slide pattern over text
                    for (let i = 0; i <= n - m; i++) {
                        if (p === t) {
                            let match = true;
                            for (let j = 0; j < m; j++) {
                                if (text[i + j] !== pattern[j]) {
                                    match = false;
                                    break;
                                }
                            }
                            if (match) {
                                console.log(`Pattern found at index ${i}`);
                            }
                        }
                        
                        if (i < n - m) {
                            t = (d * (t - text.charCodeAt(i) * h) + text.charCodeAt(i + m)) % q;
                            if (t < 0) {
                                t += q;
                            }
                        }
                    }
                }
                """
            ],
            example: AlgorithmExample(
                text: "GEEKSFORGEEKS",
                pattern: "GEEK",
                expectedOutput: "Pattern found at positions: 0, 8",
                explanation: "The algorithm calculates hash values and uses rolling hash to efficiently check all positions. The pattern 'GEEK' appears at indices 0 and 8 in 'GEEKSFORGEEKS'. When hashes match, character-by-character verification confirms the match."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Calculate hash of pattern and first window of text", type: .start),
                AlgorithmStep(title: "Compare Hashes", description: "Compare pattern hash with current window hash", type: .decision),
                AlgorithmStep(title: "Hash Match", description: "If hashes match, verify characters to avoid false positives", type: .process),
                AlgorithmStep(title: "Pattern Found", description: "If all characters match, record the position", type: .success),
                AlgorithmStep(title: "Rolling Hash", description: "Use rolling hash to compute next window hash in O(1)", type: .process),
                AlgorithmStep(title: "Slide Window", description: "Move to next position using rolling hash technique", type: .process),
                AlgorithmStep(title: "Repeat", description: "Continue until window reaches end of text", type: .process),
                AlgorithmStep(title: "Complete", description: "All positions checked, search complete", type: .end)
            ]
        )
    }
}
