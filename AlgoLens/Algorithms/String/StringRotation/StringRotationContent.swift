//
//  StringRotationContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func stringRotationContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "String Rotation checks if one string is a rotation of another by using a clever trick: concatenating the first string with itself. If the second string is a substring of this concatenation, then it must be a rotation. For example, 'waterbottle' rotated becomes 'erbottlewat', and 'erbottlewat' appears in 'waterbottlewaterbottle'.",
            whenToUse: [
                "When checking if strings are rotations of each other",
                "In circular buffer or array problems",
                "For pattern matching in cyclic structures",
                "In interview coding questions"
            ],
            keyIdea: "If s2 is a rotation of s1, then s2 will always be a substring of s1+s1. For example, all rotations of 'abc' ('abc', 'bca', 'cab') are substrings of 'abcabc'.",
            codeImplementations: [
                .pseudocode: """
                function isRotation(s1, s2):
                    if length(s1) != length(s2) or length(s1) == 0:
                        return false
                    
                    concatenated = s1 + s1
                    return contains(concatenated, s2)
                """,
                .c: """
                bool isRotation(char* s1, char* s2) {
                    int len1 = strlen(s1);
                    int len2 = strlen(s2);
                    
                    if (len1 != len2 || len1 == 0)
                        return false;
                    
                    char concatenated[len1 * 2 + 1];
                    strcpy(concatenated, s1);
                    strcat(concatenated, s1);
                    
                    return strstr(concatenated, s2) != NULL;
                }
                """,
                .cpp: """
                bool isRotation(string s1, string s2) {
                    if (s1.length() != s2.length() || s1.empty())
                        return false;
                    
                    string concatenated = s1 + s1;
                    return concatenated.find(s2) != string::npos;
                }
                """,
                .java: """
                public boolean isRotation(String s1, String s2) {
                    if (s1.length() != s2.length() || s1.isEmpty())
                        return false;
                    
                    String concatenated = s1 + s1;
                    return concatenated.contains(s2);
                }
                """,
                .python: """
                def is_rotation(s1, s2):
                    if len(s1) != len(s2) or len(s1) == 0:
                        return False
                    
                    concatenated = s1 + s1
                    return s2 in concatenated
                """,
                .swift: """
                func isRotation(_ s1: String, _ s2: String) -> Bool {
                    guard s1.count == s2.count && !s1.isEmpty else {
                        return false
                    }
                    
                    let concatenated = s1 + s1
                    return concatenated.contains(s2)
                }
                """,
                .javascript: """
                function isRotation(s1, s2) {
                    if (s1.length !== s2.length || s1.length === 0) {
                        return false;
                    }
                    
                    const concatenated = s1 + s1;
                    return concatenated.includes(s2);
                }
                """
            ],
            example: AlgorithmExample(
                text: "WATERBOTTLE + WATERBOTTLE = WATERBOTTLEWATERBOTTLE",
                pattern: "ERBOTTLEWAT",
                expectedOutput: "True - ERBOTTLEWAT is found in the concatenated string",
                explanation: "Since 'ERBOTTLEWAT' appears in 'WATERBOTTLEWATERBOTTLE', it confirms that 'ERBOTTLEWAT' is a rotation of 'WATERBOTTLE'. The rotation moves 'WAT' from the beginning to the end."
            ),
            steps: [
                AlgorithmStep(title: "Check Lengths", description: "Verify both strings have equal length", type: .start),
                AlgorithmStep(title: "Length Validation", description: "If lengths differ, strings cannot be rotations", type: .decision),
                AlgorithmStep(title: "Concatenate", description: "Create new string by concatenating s1 with itself (s1+s1)", type: .process),
                AlgorithmStep(title: "Search", description: "Check if s2 is a substring of concatenated string", type: .process),
                AlgorithmStep(title: "Found", description: "If s2 is found, it's a rotation of s1", type: .success),
                AlgorithmStep(title: "Not Found", description: "If s2 is not found, it's not a rotation", type: .process),
                AlgorithmStep(title: "Complete", description: "Return the result", type: .end)
            ]
        )
    }
}
