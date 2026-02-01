//
//  TowerOfHanoiContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension AlgorithmContent {
    static func towerOfHanoiContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Tower of Hanoi is a classic mathematical puzzle that demonstrates recursion. Move n disks from source rod to destination rod using an auxiliary rod, with the rule that no larger disk can be placed on a smaller disk.",
            whenToUse: [
                "When learning recursion concepts",
                "For understanding divide-and-conquer strategy",
                "When solving sequential transfer problems",
                "For demonstrating exponential complexity"
            ],
            keyIdea: "To move n disks: move (n-1) disks to auxiliary, move largest disk to destination, then move (n-1) disks from auxiliary to destination.",
            codeImplementations: [
                .pseudocode: """
                function towerOfHanoi(n, source, destination, auxiliary):
                    if n == 1:
                        move disk from source to destination
                        return
                    
                    towerOfHanoi(n-1, source, auxiliary, destination)
                    move disk n from source to destination
                    towerOfHanoi(n-1, auxiliary, destination, source)
                """,
                .c: """
                void towerOfHanoi(int n, char source, char dest, char aux) {
                    if (n == 1) {
                        printf("Move disk 1 from %c to %c\\n", source, dest);
                        return;
                    }
                    towerOfHanoi(n - 1, source, aux, dest);
                    printf("Move disk %d from %c to %c\\n", n, source, dest);
                    towerOfHanoi(n - 1, aux, dest, source);
                }
                """,
                .cpp: """
                void towerOfHanoi(int n, char source, char dest, char aux) {
                    if (n == 1) {
                        cout << "Move disk 1 from " << source << " to " << dest << endl;
                        return;
                    }
                    towerOfHanoi(n - 1, source, aux, dest);
                    cout << "Move disk " << n << " from " << source << " to " << dest << endl;
                    towerOfHanoi(n - 1, aux, dest, source);
                }
                """,
                .java: """
                public void towerOfHanoi(int n, char source, char dest, char aux) {
                    if (n == 1) {
                        System.out.println("Move disk 1 from " + source + " to " + dest);
                        return;
                    }
                    towerOfHanoi(n - 1, source, aux, dest);
                    System.out.println("Move disk " + n + " from " + source + " to " + dest);
                    towerOfHanoi(n - 1, aux, dest, source);
                }
                """,
                .python: """
                def tower_of_hanoi(n, source, dest, aux):
                    if n == 1:
                        print(f"Move disk 1 from {source} to {dest}")
                        return
                    
                    tower_of_hanoi(n - 1, source, aux, dest)
                    print(f"Move disk {n} from {source} to {dest}")
                    tower_of_hanoi(n - 1, aux, dest, source)
                """,
                .swift: """
                func towerOfHanoi(n: Int, source: String, dest: String, aux: String) {
                    if n == 1 {
                        print("Move disk 1 from \\(source) to \\(dest)")
                        return
                    }
                    towerOfHanoi(n: n - 1, source: source, dest: aux, aux: dest)
                    print("Move disk \\(n) from \\(source) to \\(dest)")
                    towerOfHanoi(n: n - 1, source: aux, dest: dest, aux: source)
                }
                """,
                .javascript: """
                function towerOfHanoi(n, source, dest, aux) {
                    if (n === 1) {
                        console.log(`Move disk 1 from ${source} to ${dest}`);
                        return;
                    }
                    towerOfHanoi(n - 1, source, aux, dest);
                    console.log(`Move disk ${n} from ${source} to ${dest}`);
                    towerOfHanoi(n - 1, aux, dest, source);
                }
                """
            ],
            
            steps: [
                AlgorithmStep(title: "Base Case", description: "If n = 1, move disk directly to destination", type: .start),
                AlgorithmStep(title: "Move n-1 to Auxiliary", description: "Recursively move (n-1) disks from source to auxiliary using destination", type: .process),
                AlgorithmStep(title: "Move Largest Disk", description: "Move the largest disk (nth) from source to destination", type: .decision),
                AlgorithmStep(title: "Move n-1 to Destination", description: "Recursively move (n-1) disks from auxiliary to destination using source", type: .process),
                AlgorithmStep(title: "Complete", description: "All disks successfully moved to destination", type: .success),
                AlgorithmStep(title: "Total Moves", description: "Minimum moves required: 2^n - 1", type: .end)
            ]
        )
    }
}

