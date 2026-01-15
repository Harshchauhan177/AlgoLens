//
//  AnagramCheckContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func anagramCheckContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Anagram Check determines if two strings are anagrams by verifying that they contain the same characters with the same frequencies. Two strings are anagrams if one can be formed by rearranging the letters of the other.",
            whenToUse: [
                "When checking if two words or phrases are rearrangements of each other",
                "For word games and puzzle applications",
                "In spell checkers to suggest alternative words",
                "For cryptography and text analysis"
            ],
            keyIdea: "Count the frequency of each character in both strings and verify they match. If all character frequencies are identical, the strings are anagrams.",
            codeImplementations: [
                .pseudocode: """
                function checkAnagram(str1, str2):
                    if length(str1) != length(str2):
                        return false
                    
                    charCount = empty map
                    
                    for each char in str1:
                        charCount[char] = charCount[char] + 1
                    
                    for each char in str2:
                        if charCount[char] == 0 or not exists:
                            return false
                        charCount[char] = charCount[char] - 1
                    
                    return true
                """,
                .c: """
                bool checkAnagram(char str1[], char str2[]) {
                    if (strlen(str1) != strlen(str2))
                        return false;
                    
                    int charCount[256] = {0};
                    
                    for (int i = 0; str1[i]; i++)
                        charCount[(int)str1[i]]++;
                    
                    for (int i = 0; str2[i]; i++) {
                        if (charCount[(int)str2[i]] == 0)
                            return false;
                        charCount[(int)str2[i]]--;
                    }
                    
                    return true;
                }
                """,
                .cpp: """
                bool checkAnagram(string str1, string str2) {
                    if (str1.length() != str2.length())
                        return false;
                    
                    unordered_map<char, int> charCount;
                    
                    for (char c : str1)
                        charCount[c]++;
                    
                    for (char c : str2) {
                        if (charCount[c] == 0)
                            return false;
                        charCount[c]--;
                    }
                    
                    return true;
                }
                """,
                .java: """
                public boolean checkAnagram(String str1, String str2) {
                    if (str1.length() != str2.length())
                        return false;
                    
                    HashMap<Character, Integer> charCount = new HashMap<>();
                    
                    for (char c : str1.toCharArray())
                        charCount.put(c, charCount.getOrDefault(c, 0) + 1);
                    
                    for (char c : str2.toCharArray()) {
                        if (!charCount.containsKey(c) || charCount.get(c) == 0)
                            return false;
                        charCount.put(c, charCount.get(c) - 1);
                    }
                    
                    return true;
                }
                """,
                .python: """
                def check_anagram(str1, str2):
                    if len(str1) != len(str2):
                        return False
                    
                    char_count = {}
                    
                    for char in str1:
                        char_count[char] = char_count.get(char, 0) + 1
                    
                    for char in str2:
                        if char not in char_count or char_count[char] == 0:
                            return False
                        char_count[char] -= 1
                    
                    return True
                """,
                .swift: """
                func checkAnagram(_ str1: String, _ str2: String) -> Bool {
                    guard str1.count == str2.count else { return false }
                    
                    var charCount = [Character: Int]()
                    
                    for char in str1 {
                        charCount[char, default: 0] += 1
                    }
                    
                    for char in str2 {
                        guard let count = charCount[char], count > 0 else {
                            return false
                        }
                        charCount[char] = count - 1
                    }
                    
                    return true
                }
                """,
                .javascript: """
                function checkAnagram(str1, str2) {
                    if (str1.length !== str2.length)
                        return false;
                    
                    const charCount = {};
                    
                    for (let char of str1)
                        charCount[char] = (charCount[char] || 0) + 1;
                    
                    for (let char of str2) {
                        if (!charCount[char] || charCount[char] === 0)
                            return false;
                        charCount[char]--;
                    }
                    
                    return true;
                }
                """
            ],
            example: AlgorithmExample(
                text: "listen",
                pattern: "silent",
                expectedOutput: "True - Strings are anagrams",
                explanation: "Both strings contain the same characters with the same frequencies: l(1), i(1), s(1), t(1), e(1), n(1). Therefore, 'listen' and 'silent' are anagrams."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Check if both strings have the same length", type: .start),
                AlgorithmStep(title: "Count Characters", description: "Count frequency of each character in first string", type: .process),
                AlgorithmStep(title: "Verify Characters", description: "For each character in second string, check and decrement count", type: .decision),
                AlgorithmStep(title: "Character Found", description: "Character exists with positive count, decrement it", type: .success),
                AlgorithmStep(title: "Character Missing", description: "Character not found or count is zero, not an anagram", type: .process),
                AlgorithmStep(title: "Check Complete", description: "All characters verified successfully", type: .process),
                AlgorithmStep(title: "Result", description: "Return true if anagram, false otherwise", type: .end)
            ]
        )
    }
}
