////
////  TowerOfHanoiContent.swift
////  AlgoLens
////
////  Created by harsh chauhan on 17/01/26.
////
//
//import Foundation
//
//extension AlgorithmContent {
//    static func towerOfHanoiContent() -> AlgorithmContent {
//        AlgorithmContent(
//            introduction: """
//            The Tower of Hanoi is a classic mathematical puzzle that demonstrates the power of recursion. The puzzle consists of three rods and a number of disks of different sizes that can slide onto any rod.
//            
//            The puzzle starts with all disks stacked in ascending order on one rod (smallest on top), creating a conical shape. The objective is to move the entire stack to another rod, following these rules:
//            
//            1. Only one disk can be moved at a time
//            2. A disk can only be moved if it's the top disk on a stack
//            3. No disk may be placed on top of a smaller disk
//            
//            The minimum number of moves required to solve the puzzle is 2^n - 1, where n is the number of disks.
//            """,
//            
//            howItWorks: """
//            The algorithm uses a divide-and-conquer approach:
//            
//            1. **Base Case**: If there's only 1 disk, move it directly from source to destination
//            
//            2. **Recursive Case** (for n disks):
//               • Move (n-1) disks from source to auxiliary rod (using destination as spare)
//               • Move the largest disk from source to destination
//               • Move (n-1) disks from auxiliary to destination (using source as spare)
//            
//            The recursion naturally handles the constraint that larger disks cannot be placed on smaller ones.
//            
//            **Key Insight**: To move n disks, we recursively solve the problem for (n-1) disks twice, with one direct move of the largest disk in between.
//            """,
//            
//            realWorldApplications: """
//            • **Backup Systems**: Sequential data backup and restoration
//            • **Puzzle Games**: Foundation for many recursive puzzle games
//            • **Algorithm Teaching**: Demonstrates recursion concepts
//            • **Stack Operations**: Understanding stack data structures
//            • **Resource Management**: Planning sequential resource transfers
//            • **Computer Science Education**: Classic example of divide-and-conquer
//            """,
//            
//            codeExample: """
//            func towerOfHanoi(n: Int, source: String, destination: String, auxiliary: String) -> [String] {
//                var moves: [String] = []
//                
//                func solve(_ n: Int, _ from: String, _ to: String, _ aux: String) {
//                    if n == 1 {
//                        // Base case: move single disk
//                        moves.append("Move disk 1 from \\(from) to \\(to)")
//                        return
//                    }
//                    
//                    // Move n-1 disks from source to auxiliary
//                    solve(n - 1, from, aux, to)
//                    
//                    // Move largest disk from source to destination
//                    moves.append("Move disk \\(n) from \\(from) to \\(to)")
//                    
//                    // Move n-1 disks from auxiliary to destination
//                    solve(n - 1, aux, to, from)
//                }
//                
//                solve(n, source, destination, auxiliary)
//                return moves
//            }
//            
//            // Example usage
//            let moves = towerOfHanoi(n: 3, source: "A", destination: "C", auxiliary: "B")
//            for move in moves {
//                print(move)
//            }
//            
//            // Output:
//            // Move disk 1 from A to C
//            // Move disk 2 from A to B
//            // Move disk 1 from C to B
//            // Move disk 3 from A to C
//            // Move disk 1 from B to A
//            // Move disk 2 from B to C
//            // Move disk 1 from A to C
//            """
//        )
//    }
//}
