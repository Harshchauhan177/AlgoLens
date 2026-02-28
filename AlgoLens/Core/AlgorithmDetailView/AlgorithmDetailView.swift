//
//  AlgorithmDetailView.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct AlgorithmDetailView: View {
    @StateObject private var viewModel: AlgorithmDetailViewModel
    @State private var showQuiz = false
    
    init(algorithm: Algorithm) {
        _viewModel = StateObject(wrappedValue: AlgorithmDetailViewModel(algorithm: algorithm))
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Theme.Colors.backgroundGradientStart,
                    Theme.Colors.backgroundGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Scrollable Content Area
                ScrollView {
                    VStack(spacing: 0) {
                        // Subtitle (moved from header)
                        Text(viewModel.algorithm.description)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.large)
                            .padding(.top, Theme.Spacing.small)
                            .padding(.bottom, Theme.Spacing.medium)
                        
                        // Enhanced Tab Picker
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.medium) {
                                ForEach(AlgorithmDetailViewModel.DetailTab.allCases, id: \.self) { tab in
                                    EnhancedTabButton(
                                        tab: tab,
                                        isSelected: viewModel.selectedTab == tab
                                    ) {
                                        viewModel.selectTab(tab)
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.large)
                        }
                        .padding(.bottom, Theme.Spacing.medium)
                        
                        // Tab Content
                        Group {
                            switch viewModel.selectedTab {
                            case .explanation:
                                ExplanationTabView(content: viewModel.content, algorithm: viewModel.algorithm)
                            case .pseudocode:
                                PseudocodeTabView(content: viewModel.content)
                            case .howItWorks:
                                HowItWorksTabView(content: viewModel.content)
                            }
                        }
                        .animation(.easeInOut(duration: 0.25), value: viewModel.selectedTab)
                    }
                }
                
                // Compact Bottom Action Bar (Side-by-Side Buttons)
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(spacing: Theme.Spacing.medium) {
                        // Primary Action: Visualize
                        Button(action: {
                            viewModel.startVisualization()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Visualize")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.4, blue: 0.9),
                                        Color(red: 0.5, green: 0.3, blue: 0.9)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 3)
                        }
                        
                        // Secondary Action: Quiz
                        Button(action: {
                            showQuiz = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("Quiz")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.25), lineWidth: 1.5)
                            )
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.small + 2)
                    .padding(.bottom, Theme.Spacing.small + 4)
                }
                .background(
                    Color.white.opacity(0.5)
                        .background(.ultraThinMaterial)
                )
            }
        }
        .navigationTitle(viewModel.algorithm.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $viewModel.showVisualization) {
            // Navigate to visualization screen
            // Searching Algorithms
            if viewModel.algorithm.name == "Linear Search" {
                LinearSearchVisualizationView()
            } else if viewModel.algorithm.name == "Binary Search" {
                BinarySearchVisualizationView()
            } else if viewModel.algorithm.name == "Jump Search" {
                JumpSearchView()
            } else if viewModel.algorithm.name == "Exponential Search" {
                ExponentialSearchView()
            } else if viewModel.algorithm.name == "Interpolation Search" {
                InterpolationSearchView()
            } else if viewModel.algorithm.name == "Fibonacci Search" {
                FibonacciSearchView()
            }
            // Sorting Algorithms
            else if viewModel.algorithm.name == "Bubble Sort" {
                BubbleSortVisualizationView()
            } else if viewModel.algorithm.name == "Selection Sort" {
                SelectionSortVisualizationView()
            } else if viewModel.algorithm.name == "Insertion Sort" {
                InsertionSortVisualizationView()
            } else if viewModel.algorithm.name == "Merge Sort" {
                MergeSortVisualizationView()
            } else if viewModel.algorithm.name == "Quick Sort" {
                QuickSortVisualizationView()
            } else if viewModel.algorithm.name == "Heap Sort" {
                HeapSortVisualizationView()
            } else if viewModel.algorithm.name == "Counting Sort" {
                CountingSortVisualizationView()
            }
            // Array Algorithms
            else if viewModel.algorithm.name == "Two Pointer" {
                TwoPointerVisualizationView()
            } else if viewModel.algorithm.name == "Sliding Window" {
                SlidingWindowVisualizationView()
            } else if viewModel.algorithm.name == "Prefix Sum" {
                PrefixSumVisualizationView()
            } else if viewModel.algorithm.name == "Kadane's Algorithm" {
                KadaneVisualizationView()
            } else if viewModel.algorithm.name == "Moore's Voting" {
                MooreVotingVisualizationView()
            } else if viewModel.algorithm.name == "Dutch National Flag" {
                DutchNationalFlagVisualizationView()
            } else if viewModel.algorithm.name == "Subarray Sum" {
                SubarraySumVisualizationView()
            }
            // String Algorithms
            else if viewModel.algorithm.name == "Naive String Matching" {
                NaiveStringMatchingVisualizationView()
            } else if viewModel.algorithm.name == "KMP Algorithm" {
                KMPVisualizationView()
            } else if viewModel.algorithm.name == "Rabin-Karp" {
                RabinKarpVisualizationView()
            } else if viewModel.algorithm.name == "Z Algorithm" {
                ZAlgorithmVisualizationView()
            } else if viewModel.algorithm.name == "Longest Palindromic Substring" {
                LongestPalindromicSubstringVisualizationView()
            } else if viewModel.algorithm.name == "Anagram Check" {
                AnagramCheckVisualizationView()
            } else if viewModel.algorithm.name == "String Rotation" {
                StringRotationVisualizationView()
            } else if viewModel.algorithm.name == "Subsequence Check" {
                SubsequenceCheckVisualizationView()
            }
            // Recursion & Backtracking Algorithms
            else if viewModel.algorithm.name == "Tower of Hanoi" {
                TowerOfHanoiVisualizationView()
            } else if viewModel.algorithm.name == "N-Queens" {
                NQueensVisualizationView()
            } else if viewModel.algorithm.name == "Rat in a Maze" {
                RatInMazeVisualizationView()
            } else if viewModel.algorithm.name == "Word Search" {
                WordSearchVisualizationView()
            }
            // Dynamic Programming Algorithms
            else if viewModel.algorithm.name == "Fibonacci (DP)" {
                FibonacciDPView()
            }
            else {
                AlgorithmPlaceholderView(algorithm: viewModel.algorithm)
            }
        }
        .navigationDestination(isPresented: $showQuiz) {
            // Navigate to quiz screen
            QuizView(algorithm: viewModel.algorithm)
        }
    }
}

// MARK: - Enhanced Tab Button
struct EnhancedTabButton: View {
    let tab: AlgorithmDetailViewModel.DetailTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .semibold))
                
                Text(tab.rawValue)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : Theme.Colors.secondaryText)
            .padding(.horizontal, Theme.Spacing.medium + 2)
            .padding(.vertical, Theme.Spacing.small + 2)
            .background(
                ZStack {
                    if isSelected {
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        Color(.systemBackground).opacity(0.6)
                    }
                }
            )
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
        }
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        AlgorithmDetailView(
            algorithm: Algorithm(
                name: "Linear Search",
                description: "Search elements one by one",
                icon: "arrow.forward.circle.fill",
                complexity: Algorithm.Complexity(time: "O(n)", space: "O(1)"),
                category: AlgorithmCategory.allCategories[0]
            )
        )
    }
}
