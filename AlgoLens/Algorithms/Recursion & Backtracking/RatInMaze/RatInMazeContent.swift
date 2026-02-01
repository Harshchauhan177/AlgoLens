//
//  RatInMazeContent.swift
//  AlgoLens
//
//  Created by harsh chauhan on 17/01/26.
//

import Foundation

extension AlgorithmContent {
    static func ratInMazeContent(algorithm: Algorithm) -> AlgorithmContent {
        return AlgorithmContent(
            algorithm: algorithm,
            explanation: "Rat in a Maze is a classic backtracking problem where a rat must find a path from the starting position (top-left) to the destination (bottom-right) in a maze. The maze is represented as a 2D grid where 1 represents an open path and 0 represents a blocked cell (wall). The rat can move in four directions: Down, Right, Up, and Left.",
            whenToUse: [
                "When learning backtracking algorithms",
                "For solving pathfinding problems with obstacles",
                "When exploring all possible paths in a grid",
                "In robot navigation and maze-solving applications",
                "For understanding recursion and state management"
            ],
            keyIdea: "Start at the beginning position, try all four directions recursively. Mark visited cells to avoid cycles. If a path leads to a dead end, backtrack and try alternative routes.",
            codeImplementations: [
                .pseudocode: """
                function solveMaze(maze):
                    n = maze.length
                    visited = array of false
                    paths = []
                    
                    function isSafe(x, y):
                        return x in bounds and y in bounds
                               and maze[x][y] == 1 and not visited[x][y]
                    
                    function solve(x, y, path):
                        if x == n-1 and y == n-1:
                            add path to paths
                            return
                        
                        visited[x][y] = true
                        
                        if isSafe(x+1, y): solve(x+1, y, path + "D")  // Down
                        if isSafe(x, y+1): solve(x, y+1, path + "R")  // Right
                        if isSafe(x-1, y): solve(x-1, y, path + "U")  // Up
                        if isSafe(x, y-1): solve(x, y-1, path + "L")  // Left
                        
                        visited[x][y] = false  // Backtrack
                    
                    if maze[0][0] == 1:
                        solve(0, 0, "")
                    
                    return paths
                """,
                .c: """
                #include <stdio.h>
                #include <stdbool.h>
                
                bool isSafe(int maze[][10], int x, int y, int n, bool visited[][10]) {
                    return x >= 0 && x < n && y >= 0 && y < n &&
                           maze[x][y] == 1 && !visited[x][y];
                }
                
                void solve(int maze[][10], int x, int y, int n,
                          bool visited[][10], char path[], int pathLen) {
                    if (x == n-1 && y == n-1) {
                        path[pathLen] = '\\0';
                        printf("%s\\n", path);
                        return;
                    }
                    
                    visited[x][y] = true;
                    
                    // Down
                    if (isSafe(maze, x+1, y, n, visited)) {
                        path[pathLen] = 'D';
                        solve(maze, x+1, y, n, visited, path, pathLen+1);
                    }
                    
                    // Right
                    if (isSafe(maze, x, y+1, n, visited)) {
                        path[pathLen] = 'R';
                        solve(maze, x, y+1, n, visited, path, pathLen+1);
                    }
                    
                    // Up
                    if (isSafe(maze, x-1, y, n, visited)) {
                        path[pathLen] = 'U';
                        solve(maze, x-1, y, n, visited, path, pathLen+1);
                    }
                    
                    // Left
                    if (isSafe(maze, x, y-1, n, visited)) {
                        path[pathLen] = 'L';
                        solve(maze, x, y-1, n, visited, path, pathLen+1);
                    }
                    
                    visited[x][y] = false;  // Backtrack
                }
                """,
                .cpp: """
                class Solution {
                public:
                    vector<string> findPath(vector<vector<int>>& maze) {
                        int n = maze.size();
                        vector<string> paths;
                        vector<vector<bool>> visited(n, vector<bool>(n, false));
                        
                        if (maze[0][0] == 1) {
                            solve(0, 0, maze, n, visited, "", paths);
                        }
                        return paths;
                    }
                    
                private:
                    bool isSafe(int x, int y, vector<vector<int>>& maze, int n,
                               vector<vector<bool>>& visited) {
                        return x >= 0 && x < n && y >= 0 && y < n &&
                               maze[x][y] == 1 && !visited[x][y];
                    }
                    
                    void solve(int x, int y, vector<vector<int>>& maze, int n,
                              vector<vector<bool>>& visited, string path,
                              vector<string>& paths) {
                        if (x == n-1 && y == n-1) {
                            paths.push_back(path);
                            return;
                        }
                        
                        visited[x][y] = true;
                        
                        // Down
                        if (isSafe(x+1, y, maze, n, visited))
                            solve(x+1, y, maze, n, visited, path + "D", paths);
                        
                        // Right
                        if (isSafe(x, y+1, maze, n, visited))
                            solve(x, y+1, maze, n, visited, path + "R", paths);
                        
                        // Up
                        if (isSafe(x-1, y, maze, n, visited))
                            solve(x-1, y, maze, n, visited, path + "U", paths);
                        
                        // Left
                        if (isSafe(x, y-1, maze, n, visited))
                            solve(x, y-1, maze, n, visited, path + "L", paths);
                        
                        visited[x][y] = false;  // Backtrack
                    }
                };
                """,
                .java: """
                public List<String> findPath(int[][] maze) {
                    int n = maze.length;
                    List<String> paths = new ArrayList<>();
                    boolean[][] visited = new boolean[n][n];
                    
                    if (maze[0][0] == 1) {
                        solve(0, 0, maze, n, visited, "", paths);
                    }
                    return paths;
                }
                
                private boolean isSafe(int x, int y, int[][] maze, int n,
                                      boolean[][] visited) {
                    return x >= 0 && x < n && y >= 0 && y < n &&
                           maze[x][y] == 1 && !visited[x][y];
                }
                
                private void solve(int x, int y, int[][] maze, int n,
                                  boolean[][] visited, String path,
                                  List<String> paths) {
                    if (x == n-1 && y == n-1) {
                        paths.add(path);
                        return;
                    }
                    
                    visited[x][y] = true;
                    
                    // Down
                    if (isSafe(x+1, y, maze, n, visited))
                        solve(x+1, y, maze, n, visited, path + "D", paths);
                    
                    // Right
                    if (isSafe(x, y+1, maze, n, visited))
                        solve(x, y+1, maze, n, visited, path + "R", paths);
                    
                    // Up
                    if (isSafe(x-1, y, maze, n, visited))
                        solve(x-1, y, maze, n, visited, path + "U", paths);
                    
                    // Left
                    if (isSafe(x, y-1, maze, n, visited))
                        solve(x, y-1, maze, n, visited, path + "L", paths);
                    
                    visited[x][y] = false;  // Backtrack
                }
                """,
                .python: """
                def find_path(maze):
                    n = len(maze)
                    visited = [[False] * n for _ in range(n)]
                    paths = []
                    
                    def is_safe(x, y):
                        return (0 <= x < n and 0 <= y < n and
                                maze[x][y] == 1 and not visited[x][y])
                    
                    def solve(x, y, path):
                        if x == n-1 and y == n-1:
                            paths.append(path)
                            return
                        
                        visited[x][y] = True
                        
                        # Down
                        if is_safe(x+1, y):
                            solve(x+1, y, path + "D")
                        
                        # Right
                        if is_safe(x, y+1):
                            solve(x, y+1, path + "R")
                        
                        # Up
                        if is_safe(x-1, y):
                            solve(x-1, y, path + "U")
                        
                        # Left
                        if is_safe(x, y-1):
                            solve(x, y-1, path + "L")
                        
                        visited[x][y] = False  # Backtrack
                    
                    if maze[0][0] == 1:
                        solve(0, 0, "")
                    
                    return paths
                
                # Example usage
                maze = [
                    [1, 0, 0, 0],
                    [1, 1, 0, 1],
                    [0, 1, 0, 0],
                    [1, 1, 1, 1]
                ]
                paths = find_path(maze)
                print(f"Found {len(paths)} paths: {paths}")
                """,
                .swift: """
                func findPath(_ maze: [[Int]]) -> [String] {
                    let n = maze.count
                    var visited = Array(repeating: Array(repeating: false, count: n), count: n)
                    var paths: [String] = []
                    
                    func isSafe(_ x: Int, _ y: Int) -> Bool {
                        return x >= 0 && x < n && y >= 0 && y < n &&
                               maze[x][y] == 1 && !visited[x][y]
                    }
                    
                    func solve(_ x: Int, _ y: Int, _ path: String) {
                        if x == n - 1 && y == n - 1 {
                            paths.append(path)
                            return
                        }
                        
                        visited[x][y] = true
                        
                        // Down
                        if isSafe(x + 1, y) {
                            solve(x + 1, y, path + "D")
                        }
                        
                        // Right
                        if isSafe(x, y + 1) {
                            solve(x, y + 1, path + "R")
                        }
                        
                        // Up
                        if isSafe(x - 1, y) {
                            solve(x - 1, y, path + "U")
                        }
                        
                        // Left
                        if isSafe(x, y - 1) {
                            solve(x, y - 1, path + "L")
                        }
                        
                        visited[x][y] = false  // Backtrack
                    }
                    
                    if maze[0][0] == 1 {
                        solve(0, 0, "")
                    }
                    
                    return paths
                }
                """,
                .javascript: """
                function findPath(maze) {
                    const n = maze.length;
                    const visited = Array(n).fill().map(() => Array(n).fill(false));
                    const paths = [];
                    
                    function isSafe(x, y) {
                        return x >= 0 && x < n && y >= 0 && y < n &&
                               maze[x][y] === 1 && !visited[x][y];
                    }
                    
                    function solve(x, y, path) {
                        if (x === n-1 && y === n-1) {
                            paths.push(path);
                            return;
                        }
                        
                        visited[x][y] = true;
                        
                        // Down
                        if (isSafe(x+1, y)) solve(x+1, y, path + "D");
                        
                        // Right
                        if (isSafe(x, y+1)) solve(x, y+1, path + "R");
                        
                        // Up
                        if (isSafe(x-1, y)) solve(x-1, y, path + "U");
                        
                        // Left
                        if (isSafe(x, y-1)) solve(x, y-1, path + "L");
                        
                        visited[x][y] = false;  // Backtrack
                    }
                    
                    if (maze[0][0] === 1) {
                        solve(0, 0, "");
                    }
                    
                    return paths;
                }
                """
            ],
            
            steps: [
                AlgorithmStep(title: "Initialize", description: "Start at position (0, 0) with empty path", type: .start),
                AlgorithmStep(title: "Check Destination", description: "If reached (n-1, n-1), record the path", type: .decision),
                AlgorithmStep(title: "Mark Visited", description: "Mark current cell as visited to prevent cycles", type: .process),
                AlgorithmStep(title: "Try Down", description: "If safe, recursively move down (x+1, y)", type: .process),
                AlgorithmStep(title: "Try Right", description: "If safe, recursively move right (x, y+1)", type: .process),
                AlgorithmStep(title: "Try Up", description: "If safe, recursively move up (x-1, y)", type: .process),
                AlgorithmStep(title: "Try Left", description: "If safe, recursively move left (x, y-1)", type: .process),
                AlgorithmStep(title: "Backtrack", description: "Unmark current cell to explore other paths", type: .process),
                AlgorithmStep(title: "Complete", description: "Time: O(2^(N²)), Space: O(N²) for recursion and visited array", type: .end)
            ]
        )
    }
}
