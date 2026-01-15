//
//  ZAlgorithmContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func zAlgorithmContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "The Z Algorithm is an efficient linear-time pattern matching algorithm that computes the Z-array, where each element Z[i] represents the length of the longest substring starting from position i that matches a prefix of the string. It's particularly efficient for finding all occurrences of a pattern in text.",
            whenToUse: [
                "When you need linear time pattern matching",
                "For finding all occurrences of a pattern efficiently",
                "In bioinformatics for DNA sequence matching",
                "When preprocessing time is acceptable for multiple searches",
                "For problems requiring prefix matching information"
            ],
            keyIdea: "Create a concatenated string (pattern + delimiter + text) and compute Z-array. Positions where Z[i] equals pattern length indicate pattern matches.",
            codeImplementations: [
                .pseudocode: """
                function zAlgorithm(text, pattern):
                    combined = pattern + "$" + text
                    n = length(combined)
                    Z = array of size n
                    
                    left = 0, right = 0
                    for i = 1 to n-1:
                        if i > right:
                            left = right = i
                            while right < n and combined[right] == combined[right-left]:
                                right = right + 1
                            Z[i] = right - left
                            right = right - 1
                        else:
                            k = i - left
                            if Z[k] < right - i + 1:
                                Z[i] = Z[k]
                            else:
                                left = i
                                while right < n and combined[right] == combined[right-left]:
                                    right = right + 1
                                Z[i] = right - left
                                right = right - 1
                    
                    patternLen = length(pattern)
                    for i = 0 to n-1:
                        if Z[i] == patternLen:
                            print "Pattern found at index", i - patternLen - 1
                """,
                .c: """
                void computeZArray(char str[], int Z[], int n) {
                    int left = 0, right = 0;
                    
                    for (int i = 1; i < n; i++) {
                        if (i > right) {
                            left = right = i;
                            while (right < n && str[right] == str[right - left])
                                right++;
                            Z[i] = right - left;
                            right--;
                        } else {
                            int k = i - left;
                            if (Z[k] < right - i + 1)
                                Z[i] = Z[k];
                            else {
                                left = i;
                                while (right < n && str[right] == str[right - left])
                                    right++;
                                Z[i] = right - left;
                                right--;
                            }
                        }
                    }
                }

                void zAlgorithm(char text[], char pattern[]) {
                    int patternLen = strlen(pattern);
                    int textLen = strlen(text);
                    int combinedLen = patternLen + textLen + 1;
                    char combined[combinedLen + 1];
                    int Z[combinedLen];
                    
                    strcpy(combined, pattern);
                    strcat(combined, "$");
                    strcat(combined, text);
                    
                    computeZArray(combined, Z, combinedLen);
                    
                    for (int i = 0; i < combinedLen; i++) {
                        if (Z[i] == patternLen)
                            printf("Pattern found at index %d\\n", i - patternLen - 1);
                    }
                }
                """,
                .cpp: """
                vector<int> computeZArray(string str) {
                    int n = str.length();
                    vector<int> Z(n);
                    int left = 0, right = 0;
                    
                    for (int i = 1; i < n; i++) {
                        if (i > right) {
                            left = right = i;
                            while (right < n && str[right] == str[right - left])
                                right++;
                            Z[i] = right - left;
                            right--;
                        } else {
                            int k = i - left;
                            if (Z[k] < right - i + 1)
                                Z[i] = Z[k];
                            else {
                                left = i;
                                while (right < n && str[right] == str[right - left])
                                    right++;
                                Z[i] = right - left;
                                right--;
                            }
                        }
                    }
                    return Z;
                }

                void zAlgorithm(string text, string pattern) {
                    string combined = pattern + "$" + text;
                    vector<int> Z = computeZArray(combined);
                    int patternLen = pattern.length();
                    
                    for (int i = 0; i < combined.length(); i++) {
                        if (Z[i] == patternLen)
                            cout << "Pattern found at index " << i - patternLen - 1 << endl;
                    }
                }
                """,
                .java: """
                public int[] computeZArray(String str) {
                    int n = str.length();
                    int[] Z = new int[n];
                    int left = 0, right = 0;
                    
                    for (int i = 1; i < n; i++) {
                        if (i > right) {
                            left = right = i;
                            while (right < n && str.charAt(right) == str.charAt(right - left))
                                right++;
                            Z[i] = right - left;
                            right--;
                        } else {
                            int k = i - left;
                            if (Z[k] < right - i + 1)
                                Z[i] = Z[k];
                            else {
                                left = i;
                                while (right < n && str.charAt(right) == str.charAt(right - left))
                                    right++;
                                Z[i] = right - left;
                                right--;
                            }
                        }
                    }
                    return Z;
                }

                public void zAlgorithm(String text, String pattern) {
                    String combined = pattern + "$" + text;
                    int[] Z = computeZArray(combined);
                    int patternLen = pattern.length();
                    
                    for (int i = 0; i < combined.length(); i++) {
                        if (Z[i] == patternLen)
                            System.out.println("Pattern found at index " + (i - patternLen - 1));
                    }
                }
                """,
                .python: """
                def compute_z_array(s):
                    n = len(s)
                    Z = [0] * n
                    left = right = 0
                    
                    for i in range(1, n):
                        if i > right:
                            left = right = i
                            while right < n and s[right] == s[right - left]:
                                right += 1
                            Z[i] = right - left
                            right -= 1
                        else:
                            k = i - left
                            if Z[k] < right - i + 1:
                                Z[i] = Z[k]
                            else:
                                left = i
                                while right < n and s[right] == s[right - left]:
                                    right += 1
                                Z[i] = right - left
                                right -= 1
                    return Z

                def z_algorithm(text, pattern):
                    combined = pattern + "$" + text
                    Z = compute_z_array(combined)
                    pattern_len = len(pattern)
                    
                    for i in range(len(combined)):
                        if Z[i] == pattern_len:
                            print(f"Pattern found at index {i - pattern_len - 1}")
                """,
                .swift: """
                func computeZArray(_ str: String) -> [Int] {
                    let chars = Array(str)
                    let n = chars.count
                    var Z = Array(repeating: 0, count: n)
                    var left = 0, right = 0
                    
                    for i in 1..<n {
                        if i > right {
                            left = i
                            right = i
                            while right < n && chars[right] == chars[right - left] {
                                right += 1
                            }
                            Z[i] = right - left
                            right -= 1
                        } else {
                            let k = i - left
                            if Z[k] < right - i + 1 {
                                Z[i] = Z[k]
                            } else {
                                left = i
                                while right < n && chars[right] == chars[right - left] {
                                    right += 1
                                }
                                Z[i] = right - left
                                right -= 1
                            }
                        }
                    }
                    return Z
                }

                func zAlgorithm(_ text: String, pattern: String) {
                    let combined = pattern + "$" + text
                    let Z = computeZArray(combined)
                    let patternLen = pattern.count
                    
                    for i in 0..<Z.count {
                        if Z[i] == patternLen {
                            print("Pattern found at index \\(i - patternLen - 1)")
                        }
                    }
                }
                """,
                .javascript: """
                function computeZArray(str) {
                    const n = str.length;
                    const Z = new Array(n).fill(0);
                    let left = 0, right = 0;
                    
                    for (let i = 1; i < n; i++) {
                        if (i > right) {
                            left = right = i;
                            while (right < n && str[right] === str[right - left])
                                right++;
                            Z[i] = right - left;
                            right--;
                        } else {
                            const k = i - left;
                            if (Z[k] < right - i + 1)
                                Z[i] = Z[k];
                            else {
                                left = i;
                                while (right < n && str[right] === str[right - left])
                                    right++;
                                Z[i] = right - left;
                                right--;
                            }
                        }
                    }
                    return Z;
                }

                function zAlgorithm(text, pattern) {
                    const combined = pattern + "$" + text;
                    const Z = computeZArray(combined);
                    const patternLen = pattern.length;
                    
                    for (let i = 0; i < combined.length; i++) {
                        if (Z[i] === patternLen) {
                            console.log(`Pattern found at index ${i - patternLen - 1}`);
                        }
                    }
                }
                """
            ],
            example: AlgorithmExample(
                text: "ABABDABACDABABCABAB",
                pattern: "ABABCABAB",
                expectedOutput: "Pattern found at position: 10",
                explanation: "The algorithm creates the string 'ABABCABAB$ABABDABACDABABCABAB' and computes the Z-array. Positions where Z[i] equals the pattern length (9) indicate matches. The pattern 'ABABCABAB' is found at index 10 in the original text."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Concatenate pattern with '$' separator and text", type: .start),
                AlgorithmStep(title: "Compute Z-Array", description: "Calculate Z values for each position using Z-box optimization", type: .process),
                AlgorithmStep(title: "Use Z-Box", description: "Utilize previously computed information to speed up calculation", type: .process),
                AlgorithmStep(title: "Extend Match", description: "Extend match when outside Z-box or value exceeds box boundary", type: .decision),
                AlgorithmStep(title: "Check Z-Values", description: "Scan Z-array for values equal to pattern length", type: .process),
                AlgorithmStep(title: "Pattern Found", description: "Z[i] == pattern length indicates match at position i - pattern length - 1", type: .success),
                AlgorithmStep(title: "Continue", description: "Process remaining positions in the combined string", type: .process),
                AlgorithmStep(title: "Complete", description: "All matches found in linear time", type: .end)
            ]
        )
    }
}
