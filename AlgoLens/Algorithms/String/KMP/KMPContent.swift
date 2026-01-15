//
//  KMPContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func kmpContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "The Knuth-Morris-Pratt (KMP) algorithm is an efficient string matching algorithm that preprocesses the pattern to avoid unnecessary comparisons. It uses a Longest Prefix Suffix (LPS) array to skip characters smartly, eliminating redundant comparisons when a mismatch occurs.",
            whenToUse: [
                "When searching for patterns in large texts",
                "When pattern length is significant",
                "In text editors for efficient search functionality",
                "For DNA sequence matching in bioinformatics",
                "When multiple pattern searches are needed on the same text"
            ],
            keyIdea: "Preprocess the pattern to create an LPS array that tells us how many characters we can skip when a mismatch occurs, avoiding redundant comparisons.",
            codeImplementations: [
                .pseudocode: """
                function computeLPS(pattern):
                    m = length(pattern)
                    lps = array of size m initialized to 0
                    len = 0
                    i = 1
                    
                    while i < m:
                        if pattern[i] == pattern[len]:
                            len = len + 1
                            lps[i] = len
                            i = i + 1
                        else:
                            if len != 0:
                                len = lps[len - 1]
                            else:
                                lps[i] = 0
                                i = i + 1
                    return lps

                function KMPSearch(text, pattern):
                    n = length(text)
                    m = length(pattern)
                    lps = computeLPS(pattern)
                    
                    i = 0  // index for text
                    j = 0  // index for pattern
                    
                    while i < n:
                        if pattern[j] == text[i]:
                            i = i + 1
                            j = j + 1
                        
                        if j == m:
                            print "Pattern found at index", i - j
                            j = lps[j - 1]
                        else if i < n and pattern[j] != text[i]:
                            if j != 0:
                                j = lps[j - 1]
                            else:
                                i = i + 1
                """,
                .c: """
                void computeLPS(char *pattern, int m, int *lps) {
                    int len = 0;
                    lps[0] = 0;
                    int i = 1;
                    
                    while (i < m) {
                        if (pattern[i] == pattern[len]) {
                            len++;
                            lps[i] = len;
                            i++;
                        } else {
                            if (len != 0) {
                                len = lps[len - 1];
                            } else {
                                lps[i] = 0;
                                i++;
                            }
                        }
                    }
                }

                void KMPSearch(char *text, char *pattern) {
                    int n = strlen(text);
                    int m = strlen(pattern);
                    int lps[m];
                    
                    computeLPS(pattern, m, lps);
                    
                    int i = 0, j = 0;
                    while (i < n) {
                        if (pattern[j] == text[i]) {
                            i++;
                            j++;
                        }
                        
                        if (j == m) {
                            printf("Pattern found at index %d\\n", i - j);
                            j = lps[j - 1];
                        } else if (i < n && pattern[j] != text[i]) {
                            if (j != 0)
                                j = lps[j - 1];
                            else
                                i++;
                        }
                    }
                }
                """,
                .cpp: """
                void computeLPS(string pattern, vector<int>& lps) {
                    int m = pattern.length();
                    int len = 0;
                    lps[0] = 0;
                    int i = 1;
                    
                    while (i < m) {
                        if (pattern[i] == pattern[len]) {
                            len++;
                            lps[i] = len;
                            i++;
                        } else {
                            if (len != 0) {
                                len = lps[len - 1];
                            } else {
                                lps[i] = 0;
                                i++;
                            }
                        }
                    }
                }

                void KMPSearch(string text, string pattern) {
                    int n = text.length();
                    int m = pattern.length();
                    vector<int> lps(m);
                    
                    computeLPS(pattern, lps);
                    
                    int i = 0, j = 0;
                    while (i < n) {
                        if (pattern[j] == text[i]) {
                            i++;
                            j++;
                        }
                        
                        if (j == m) {
                            cout << "Pattern found at index " << i - j << endl;
                            j = lps[j - 1];
                        } else if (i < n && pattern[j] != text[i]) {
                            if (j != 0)
                                j = lps[j - 1];
                            else
                                i++;
                        }
                    }
                }
                """,
                .java: """
                public void computeLPS(String pattern, int[] lps) {
                    int m = pattern.length();
                    int len = 0;
                    lps[0] = 0;
                    int i = 1;
                    
                    while (i < m) {
                        if (pattern.charAt(i) == pattern.charAt(len)) {
                            len++;
                            lps[i] = len;
                            i++;
                        } else {
                            if (len != 0) {
                                len = lps[len - 1];
                            } else {
                                lps[i] = 0;
                                i++;
                            }
                        }
                    }
                }

                public void KMPSearch(String text, String pattern) {
                    int n = text.length();
                    int m = pattern.length();
                    int[] lps = new int[m];
                    
                    computeLPS(pattern, lps);
                    
                    int i = 0, j = 0;
                    while (i < n) {
                        if (pattern.charAt(j) == text.charAt(i)) {
                            i++;
                            j++;
                        }
                        
                        if (j == m) {
                            System.out.println("Pattern found at index " + (i - j));
                            j = lps[j - 1];
                        } else if (i < n && pattern.charAt(j) != text.charAt(i)) {
                            if (j != 0)
                                j = lps[j - 1];
                            else
                                i++;
                        }
                    }
                }
                """,
                .python: """
                def compute_lps(pattern):
                    m = len(pattern)
                    lps = [0] * m
                    length = 0
                    i = 1
                    
                    while i < m:
                        if pattern[i] == pattern[length]:
                            length += 1
                            lps[i] = length
                            i += 1
                        else:
                            if length != 0:
                                length = lps[length - 1]
                            else:
                                lps[i] = 0
                                i += 1
                    return lps

                def kmp_search(text, pattern):
                    n = len(text)
                    m = len(pattern)
                    lps = compute_lps(pattern)
                    
                    i = 0  # index for text
                    j = 0  # index for pattern
                    
                    while i < n:
                        if pattern[j] == text[i]:
                            i += 1
                            j += 1
                        
                        if j == m:
                            print(f"Pattern found at index {i - j}")
                            j = lps[j - 1]
                        elif i < n and pattern[j] != text[i]:
                            if j != 0:
                                j = lps[j - 1]
                            else:
                                i += 1
                """,
                .swift: """
                func computeLPS(_ pattern: String) -> [Int] {
                    let patternArray = Array(pattern)
                    let m = patternArray.count
                    var lps = [Int](repeating: 0, count: m)
                    var len = 0
                    var i = 1
                    
                    while i < m {
                        if patternArray[i] == patternArray[len] {
                            len += 1
                            lps[i] = len
                            i += 1
                        } else {
                            if len != 0 {
                                len = lps[len - 1]
                            } else {
                                lps[i] = 0
                                i += 1
                            }
                        }
                    }
                    return lps
                }

                func kmpSearch(_ text: String, pattern: String) {
                    let textArray = Array(text)
                    let patternArray = Array(pattern)
                    let n = textArray.count
                    let m = patternArray.count
                    let lps = computeLPS(pattern)
                    
                    var i = 0
                    var j = 0
                    
                    while i < n {
                        if patternArray[j] == textArray[i] {
                            i += 1
                            j += 1
                        }
                        
                        if j == m {
                            print("Pattern found at index \\(i - j)")
                            j = lps[j - 1]
                        } else if i < n && patternArray[j] != textArray[i] {
                            if j != 0 {
                                j = lps[j - 1]
                            } else {
                                i += 1
                            }
                        }
                    }
                }
                """,
                .javascript: """
                function computeLPS(pattern) {
                    const m = pattern.length;
                    const lps = new Array(m).fill(0);
                    let len = 0;
                    let i = 1;
                    
                    while (i < m) {
                        if (pattern[i] === pattern[len]) {
                            len++;
                            lps[i] = len;
                            i++;
                        } else {
                            if (len !== 0) {
                                len = lps[len - 1];
                            } else {
                                lps[i] = 0;
                                i++;
                            }
                        }
                    }
                    return lps;
                }

                function kmpSearch(text, pattern) {
                    const n = text.length;
                    const m = pattern.length;
                    const lps = computeLPS(pattern);
                    
                    let i = 0;
                    let j = 0;
                    
                    while (i < n) {
                        if (pattern[j] === text[i]) {
                            i++;
                            j++;
                        }
                        
                        if (j === m) {
                            console.log(`Pattern found at index ${i - j}`);
                            j = lps[j - 1];
                        } else if (i < n && pattern[j] !== text[i]) {
                            if (j !== 0) {
                                j = lps[j - 1];
                            } else {
                                i++;
                            }
                        }
                    }
                }
                """
            ],
            example: AlgorithmExample(
                text: "ABABDABACDABABCABAB",
                pattern: "ABABCABAB",
                expectedOutput: "Pattern found at position: 10",
                explanation: "The KMP algorithm first computes the LPS array [0,0,1,2,0,1,2,3,4] for pattern 'ABABCABAB'. Then it efficiently searches through the text 'ABABDABACDABABCABAB' using the LPS array to skip unnecessary comparisons, finding the pattern at index 10."
            ),
            steps: [
                AlgorithmStep(title: "Compute LPS Array", description: "Build the Longest Prefix Suffix array for the pattern", type: .start),
                AlgorithmStep(title: "Initialize Pointers", description: "Set text pointer i=0 and pattern pointer j=0", type: .process),
                AlgorithmStep(title: "Compare Characters", description: "Compare text[i] with pattern[j]", type: .decision),
                AlgorithmStep(title: "Match", description: "If characters match, increment both i and j", type: .success),
                AlgorithmStep(title: "Mismatch", description: "If mismatch and j>0, use LPS[j-1] to skip characters", type: .process),
                AlgorithmStep(title: "Pattern Found", description: "When j equals pattern length, pattern is found", type: .success),
                AlgorithmStep(title: "Continue Search", description: "Use LPS array to continue searching for more matches", type: .process),
                AlgorithmStep(title: "Complete", description: "All positions checked, search complete", type: .end)
            ]
        )
    }
}
