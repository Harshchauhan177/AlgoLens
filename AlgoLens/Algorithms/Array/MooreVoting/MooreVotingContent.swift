//
//  MooreVotingContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 14/01/26.
//

import Foundation

extension AlgorithmContent {
    static func mooreVotingContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Moore's Voting Algorithm finds the majority element (appearing more than n/2 times) in O(n) time with O(1) space. It uses a clever voting mechanism: maintain a candidate and count, incrementing for matches and decrementing for mismatches. When count reaches 0, elect a new candidate.",
            whenToUse: [
                "Finding the majority element in an array (appears > n/2 times)",
                "Election/voting result determination",
                "Detecting dominant patterns in data streams",
                "Problems requiring constant space and linear time"
            ],
            keyIdea: "The majority element will always 'survive' the voting process. Each occurrence votes for itself; different elements cancel each other out. Since majority > n/2, it will remain as the final candidate. Note: Always verify the candidate actually appears > n/2 times!",
            codeImplementations: [
                .pseudocode: """
                function mooreVoting(array):
                    // Phase 1: Find candidate
                    candidate = null
                    count = 0
                    
                    for i from 0 to length(array)-1:
                        if candidate == null:
                            candidate = array[i]
                            count = 1
                        else if array[i] == candidate:
                            count++
                        else:
                            count--
                            if count == 0:
                                candidate = array[i]
                                count = 1
                    
                    // Phase 2: Verify candidate
                    occurrences = 0
                    for element in array:
                        if element == candidate:
                            occurrences++
                    
                    if occurrences > length(array) / 2:
                        return candidate
                    else:
                        return null  // No majority element
                """,
                .python: """
                def moore_voting(arr):
                    # Phase 1: Find candidate
                    candidate = None
                    count = 0
                    
                    for num in arr:
                        if candidate is None:
                            candidate = num
                            count = 1
                        elif num == candidate:
                            count += 1
                        else:
                            count -= 1
                            if count == 0:
                                candidate = num
                                count = 1
                    
                    # Phase 2: Verify candidate
                    occurrences = arr.count(candidate)
                    
                    if occurrences > len(arr) // 2:
                        return candidate
                    else:
                        return None  # No majority element
                """,
                .swift: """
                func mooreVoting(_ arr: [Int]) -> Int? {
                    // Phase 1: Find candidate
                    var candidate: Int? = nil
                    var count = 0
                    
                    for num in arr {
                        if candidate == nil {
                            candidate = num
                            count = 1
                        } else if num == candidate {
                            count += 1
                        } else {
                            count -= 1
                            if count == 0 {
                                candidate = num
                                count = 1
                            }
                        }
                    }
                    
                    // Phase 2: Verify candidate
                    guard let finalCandidate = candidate else { return nil }
                    let occurrences = arr.filter { $0 == finalCandidate }.count
                    
                    if occurrences > arr.count / 2 {
                        return finalCandidate
                    } else {
                        return nil  // No majority element
                    }
                }
                """,
                .java: """
                public Integer mooreVoting(int[] arr) {
                    // Phase 1: Find candidate
                    Integer candidate = null;
                    int count = 0;
                    
                    for (int num : arr) {
                        if (candidate == null) {
                            candidate = num;
                            count = 1;
                        } else if (num == candidate) {
                            count++;
                        } else {
                            count--;
                            if (count == 0) {
                                candidate = num;
                                count = 1;
                            }
                        }
                    }
                    
                    // Phase 2: Verify candidate
                    if (candidate == null) return null;
                    
                    int occurrences = 0;
                    for (int num : arr) {
                        if (num == candidate) occurrences++;
                    }
                    
                    if (occurrences > arr.length / 2) {
                        return candidate;
                    } else {
                        return null;  // No majority element
                    }
                }
                """,
                .cpp: """
                int mooreVoting(vector<int>& arr) {
                    // Phase 1: Find candidate
                    int candidate;
                    int count = 0;
                    bool hasCandidate = false;
                    
                    for (int num : arr) {
                        if (!hasCandidate) {
                            candidate = num;
                            count = 1;
                            hasCandidate = true;
                        } else if (num == candidate) {
                            count++;
                        } else {
                            count--;
                            if (count == 0) {
                                candidate = num;
                                count = 1;
                            }
                        }
                    }
                    
                    // Phase 2: Verify candidate
                    if (!hasCandidate) return -1;
                    
                    int occurrences = 0;
                    for (int num : arr) {
                        if (num == candidate) occurrences++;
                    }
                    
                    if (occurrences > arr.size() / 2) {
                        return candidate;
                    } else {
                        return -1;  // No majority element
                    }
                }
                """,
                .c: """
                int mooreVoting(int arr[], int n) {
                    // Phase 1: Find candidate
                    int candidate;
                    int count = 0;
                    int hasCandidate = 0;
                    
                    for (int i = 0; i < n; i++) {
                        if (!hasCandidate) {
                            candidate = arr[i];
                            count = 1;
                            hasCandidate = 1;
                        } else if (arr[i] == candidate) {
                            count++;
                        } else {
                            count--;
                            if (count == 0) {
                                candidate = arr[i];
                                count = 1;
                            }
                        }
                    }
                    
                    // Phase 2: Verify candidate
                    if (!hasCandidate) return -1;
                    
                    int occurrences = 0;
                    for (int i = 0; i < n; i++) {
                        if (arr[i] == candidate) occurrences++;
                    }
                    
                    if (occurrences > n / 2) {
                        return candidate;
                    } else {
                        return -1;  // No majority element
                    }
                }
                """,
                .javascript: """
                function mooreVoting(arr) {
                    // Phase 1: Find candidate
                    let candidate = null;
                    let count = 0;
                    
                    for (let num of arr) {
                        if (candidate === null) {
                            candidate = num;
                            count = 1;
                        } else if (num === candidate) {
                            count++;
                        } else {
                            count--;
                            if (count === 0) {
                                candidate = num;
                                count = 1;
                            }
                        }
                    }
                    
                    // Phase 2: Verify candidate
                    if (candidate === null) return null;
                    
                    const occurrences = arr.filter(x => x === candidate).length;
                    
                    if (occurrences > arr.length / 2) {
                        return candidate;
                    } else {
                        return null;  // No majority element
                    }
                }
                """
            ],
            example: AlgorithmExample(
                inputArray: [3, 3, 4, 2, 4, 4, 2, 4, 4],
                target: 0,
                expectedOutput: "Majority: 4",
                explanation: "Element 4 appears 5 times out of 9 (> 4.5), making it the majority element. The algorithm finds it by maintaining a candidate and count through voting."
            ),
            steps: [
                AlgorithmStep(title: "Initialize", description: "Set candidate = nil, count = 0", type: .start),
                AlgorithmStep(title: "Phase 1: Find Candidate", description: "Iterate through array voting for/against candidate", type: .process),
                AlgorithmStep(title: "Match Found", description: "If element equals candidate, increment count", type: .success),
                AlgorithmStep(title: "Mismatch Found", description: "If element differs from candidate, decrement count", type: .process),
                AlgorithmStep(title: "Change Candidate", description: "When count reaches 0, elect new candidate with count = 1", type: .decision),
                AlgorithmStep(title: "Complete Phase 1", description: "Final candidate is the potential majority element", type: .success),
                AlgorithmStep(title: "Phase 2: Verify", description: "Count actual occurrences of candidate in array", type: .process),
                AlgorithmStep(title: "Check Majority", description: "If occurrences > n/2, candidate is majority; else no majority exists", type: .end)
            ]
        )
    }
}
