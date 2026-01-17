////
////  RatInMazeContent.swift
////  AlgoLens
////
////  Created by harsh chauhan on 17/01/26.
////
//
//import Foundation
//
//extension AlgorithmContent {
//    static func ratInMazeContent() -> AlgorithmContent {
//        AlgorithmContent(
//            introduction: """
//            Rat in a Maze is a classic backtracking problem where a rat must find a path from the starting position (top-left) to the destination (bottom-right) in a maze.
//            
//            The maze is represented as a 2D grid where:
//            • 1 represents an open path (the rat can move through)
//            • 0 represents a blocked cell (wall)
//            
//            The rat can move in four directions: Down, Up, Right, and Left. The goal is to find all possible paths or determine if a path exists.
//            """,
//            
//            howItWorks: """
//            The algorithm uses backtracking with recursion:
//            
//            1. **Start**: Begin at position (0, 0)
//            
//            2. **Mark Current Cell**: Mark as visited to avoid cycles
//            
//            3. **Check Base Cases**:
//               • If reached destination, record the path
//               • If out of bounds, blocked, or visited, return
//            
//            4. **Try All Directions**: Recursively explore:
//               • Down (i+1, j)
//               • Right (i, j+1)
//               • Up (i-1, j)
//               • Left (i, j-1)
//            
//            5. **Backtrack**: Unmark current cell to explore other paths
//            
//            **Key Features**:
//            • Explores all possible paths systematically
//            • Uses a visited matrix to prevent cycles
//            • Backtracks when a path leads to a dead end
//            """,
//            
//            realWorldApplications: """
//            • **Robot Navigation**: Autonomous robots finding paths in environments
//            • **Game Development**: AI pathfinding in maze games
//            • **Network Routing**: Finding routes in network topology
//            • **Puzzle Solvers**: Solving maze and labyrinth puzzles
//            • **GPS Navigation**: Route finding with obstacles
//            • **Evacuation Planning**: Finding escape routes in buildings
//            • **Circuit Design**: Routing traces on PCBs
//            """,
//            
//            codeExample: """
//            func solveMaze(_ maze: [[Int]]) -> [String] {
//                let n = maze.count
//                var visited = Array(repeating: Array(repeating: false, count: n), count: n)
//                var paths: [String] = []
//                var currentPath = ""
//                
//                func isSafe(_ x: Int, _ y: Int) -> Bool {
//                    return x >= 0 && x < n && y >= 0 && y < n && 
//                           maze[x][y] == 1 && !visited[x][y]
//                }
//                
//                func solve(_ x: Int, _ y: Int, _ path: String) {
//                    // Reached destination
//                    if x == n - 1 && y == n - 1 {
//                        paths.append(path)
//                        return
//                    }
//                    
//                    visited[x][y] = true
//                    
//                    // Move Down
//                    if isSafe(x + 1, y) {
//                        solve(x + 1, y, path + "D")
//                    }
//                    
//                    // Move Right
//                    if isSafe(x, y + 1) {
//                        solve(x, y + 1, path + "R")
//                    }
//                    
//                    // Move Up
//                    if isSafe(x - 1, y) {
//                        solve(x - 1, y, path + "U")
//                    }
//                    
//                    // Move Left
//                    if isSafe(x, y - 1) {
//                        solve(x, y - 1, path + "L")
//                    }
//                    
//                    // Backtrack
//                    visited[x][y] = false
//                }
//                
//                if maze[0][0] == 1 {
//                    solve(0, 0, "")
//                }
//                
//                return paths
//            }
//            
//            // Example usage
//            let maze = [
//                [1, 0, 0, 0],
//                [1, 1, 0, 1],
//                [0, 1, 0, 0],
//                [1, 1, 1, 1]
//            ]
//            let paths = solveMaze(maze)
//            print("Found \\(paths.count) paths: \\(paths)")
//            """
//        )
//    }
//}
