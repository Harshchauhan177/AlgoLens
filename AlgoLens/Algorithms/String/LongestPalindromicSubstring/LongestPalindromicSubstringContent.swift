//
//  LongestPalindromicSubstringContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func longestPalindromicSubstringContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "The Longest Palindromic Substring algorithm finds the longest substring that reads the same forwards and backwards. It uses the expand around center technique, treating each character (and each pair of characters) as a potential center and expanding outward while characters match.",
            whenToUse: [
                "When you need to find palindromes in text",
                "In DNA sequence analysis to find symmetric patterns",
                "For text processing and pattern recognition",
                "In competitive programming problems involving palindromes"
            ],
            keyIdea: "For each possible center position in the string, expand outward while characters match. Check both odd-length (single center) and even-length (two centers) palindromes.",
            codeImplementations: [
                .pseudocode: """
                function longestPalindrome(s):
                    if s is empty:
                        return ""
                    
                    start = 0, maxLen = 1
                    
                    for i = 0 to length(s) - 1:
                        len1 = expandAroundCenter(s, i, i)        // odd length
                        len2 = expandAroundCenter(s, i, i + 1)    // even length
                        len = max(len1, len2)
                        
                        if len > maxLen:
                            maxLen = len
                            start = i - (len - 1) / 2
                    
                    return substring from start with length maxLen

                function expandAroundCenter(s, left, right):
                    while left >= 0 and right < length(s) and s[left] == s[right]:
                        left = left - 1
                        right = right + 1
                    return right - left - 1
                """,
                .c: """
                int expandAroundCenter(char* s, int left, int right, int len) {
                    while (left >= 0 && right < len && s[left] == s[right]) {
                        left--;
                        right++;
                    }
                    return right - left - 1;
                }

                char* longestPalindrome(char* s) {
                    if (s == NULL || strlen(s) == 0) return "";
                    
                    int len = strlen(s);
                    int start = 0, maxLen = 1;
                    
                    for (int i = 0; i < len; i++) {
                        int len1 = expandAroundCenter(s, i, i, len);
                        int len2 = expandAroundCenter(s, i, i + 1, len);
                        int currLen = (len1 > len2) ? len1 : len2;
                        
                        if (currLen > maxLen) {
                            maxLen = currLen;
                            start = i - (currLen - 1) / 2;
                        }
                    }
                    
                    char* result = (char*)malloc((maxLen + 1) * sizeof(char));
                    strncpy(result, s + start, maxLen);
                    result[maxLen] = '\\0';
                    return result;
                }
                """,
                .cpp: """
                class Solution {
                private:
                    int expandAroundCenter(string s, int left, int right) {
                        while (left >= 0 && right < s.length() && 
                               s[left] == s[right]) {
                            left--;
                            right++;
                        }
                        return right - left - 1;
                    }
                    
                public:
                    string longestPalindrome(string s) {
                        if (s.empty()) return "";
                        
                        int start = 0, maxLen = 1;
                        
                        for (int i = 0; i < s.length(); i++) {
                            int len1 = expandAroundCenter(s, i, i);
                            int len2 = expandAroundCenter(s, i, i + 1);
                            int len = max(len1, len2);
                            
                            if (len > maxLen) {
                                maxLen = len;
                                start = i - (len - 1) / 2;
                            }
                        }
                        
                        return s.substr(start, maxLen);
                    }
                };
                """,
                .java: """
                public class Solution {
                    private int expandAroundCenter(String s, int left, int right) {
                        while (left >= 0 && right < s.length() && 
                               s.charAt(left) == s.charAt(right)) {
                            left--;
                            right++;
                        }
                        return right - left - 1;
                    }
                    
                    public String longestPalindrome(String s) {
                        if (s == null || s.isEmpty()) return "";
                        
                        int start = 0, maxLen = 1;
                        
                        for (int i = 0; i < s.length(); i++) {
                            int len1 = expandAroundCenter(s, i, i);
                            int len2 = expandAroundCenter(s, i, i + 1);
                            int len = Math.max(len1, len2);
                            
                            if (len > maxLen) {
                                maxLen = len;
                                start = i - (len - 1) / 2;
                            }
                        }
                        
                        return s.substring(start, start + maxLen);
                    }
                }
                """,
                .python: """
                def longest_palindrome(s):
                    if not s:
                        return ""
                    
                    def expand_around_center(left, right):
                        while left >= 0 and right < len(s) and s[left] == s[right]:
                            left -= 1
                            right += 1
                        return right - left - 1
                    
                    start, max_len = 0, 1
                    
                    for i in range(len(s)):
                        len1 = expand_around_center(i, i)      # odd length
                        len2 = expand_around_center(i, i + 1)  # even length
                        curr_len = max(len1, len2)
                        
                        if curr_len > max_len:
                            max_len = curr_len
                            start = i - (curr_len - 1) // 2
                    
                    return s[start:start + max_len]
                """,
                .swift: """
                func longestPalindrome(_ s: String) -> String {
                    guard !s.isEmpty else { return "" }
                    
                    let chars = Array(s)
                    var start = 0, maxLen = 1
                    
                    func expandAroundCenter(_ left: Int, _ right: Int) -> Int {
                        var l = left, r = right
                        while l >= 0 && r < chars.count && chars[l] == chars[r] {
                            l -= 1
                            r += 1
                        }
                        return r - l - 1
                    }
                    
                    for i in 0..<chars.count {
                        let len1 = expandAroundCenter(i, i)
                        let len2 = expandAroundCenter(i, i + 1)
                        let len = max(len1, len2)
                        
                        if len > maxLen {
                            maxLen = len
                            start = i - (len - 1) / 2
                        }
                    }
                    
                    let startIdx = s.index(s.startIndex, offsetBy: start)
                    let endIdx = s.index(startIdx, offsetBy: maxLen)
                    return String(s[startIdx..<endIdx])
                }
                """,
                .javascript: """
                function longestPalindrome(s) {
                    if (!s) return "";
                    
                    let start = 0, maxLen = 1;
                    
                    function expandAroundCenter(left, right) {
                        while (left >= 0 && right < s.length && 
                               s[left] === s[right]) {
                            left--;
                            right++;
                        }
                        return right - left - 1;
                    }
                    
                    for (let i = 0; i < s.length; i++) {
                        const len1 = expandAroundCenter(i, i);
                        const len2 = expandAroundCenter(i, i + 1);
                        const len = Math.max(len1, len2);
                        
                        if (len > maxLen) {
                            maxLen = len;
                            start = i - Math.floor((len - 1) / 2);
                        }
                    }
                    
                    return s.substring(start, start + maxLen);
                }
                """
            ],
            example: AlgorithmExample(
                text: "babad",
                pattern: "",
                expectedOutput: "bab or aba",
                explanation: "The algorithm checks each position as a potential center. For 'babad', it finds two palindromes of length 3: 'bab' (centered at index 1) and 'aba' (centered at index 2). Either one is a valid answer."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set start position and max length to track longest palindrome", type: .start),
                AlgorithmStep(title: "Iterate Centers", description: "For each character, treat it as a potential palindrome center", type: .process),
                AlgorithmStep(title: "Check Odd Length", description: "Expand around single center (odd length palindromes)", type: .decision),
                AlgorithmStep(title: "Check Even Length", description: "Expand around two centers (even length palindromes)", type: .decision),
                AlgorithmStep(title: "Expand Outward", description: "While characters match, expand left and right", type: .process),
                AlgorithmStep(title: "Update Maximum", description: "If current palindrome is longer, update max length and start position", type: .success),
                AlgorithmStep(title: "Return Result", description: "Extract and return the longest palindrome found", type: .end)
            ]
        )
    }
}
