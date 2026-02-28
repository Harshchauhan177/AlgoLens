//
//  UserProgressManager.swift
//  AlgoLens
//
//  Created by harsh chauhan on 28/02/26.
//

import Foundation
import Combine

// MARK: - Quiz History Entry
struct QuizHistoryEntry: Codable, Identifiable {
    var id: String { "\(algorithmName)-\(date.timeIntervalSince1970)" }
    let algorithmName: String
    let categoryName: String
    let score: Int
    let totalQuestions: Int
    let date: Date
    
    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(score) / Double(totalQuestions) * 100
    }
}

// MARK: - User Progress Manager
@MainActor
class UserProgressManager: ObservableObject {
    static let shared = UserProgressManager()
    
    // MARK: - UserDefaults Keys
    private enum Keys {
        static let viewedAlgorithms = "viewedAlgorithms"
        static let visualizationsStarted = "visualizationsStarted"
        static let visualizationAlgorithms = "visualizationAlgorithms"
        static let quizzesCompleted = "quizzesCompleted"
        static let quizHistory = "quizHistory"
        static let totalQuizScore = "totalQuizScore"
        static let totalQuizQuestions = "totalQuizQuestions"
        static let firstLaunchDate = "firstLaunchDate"
        static let lastActiveDate = "lastActiveDate"
        static let currentStreak = "currentStreak"
        static let longestStreak = "longestStreak"
        static let categoryViewCounts = "categoryViewCounts"
    }
    
    // MARK: - Published Properties
    @Published var viewedAlgorithms: Set<String> = []
    @Published var visualizationsStarted: Int = 0
    @Published var visualizationAlgorithms: Set<String> = []
    @Published var quizzesCompleted: Int = 0
    @Published var quizHistory: [QuizHistoryEntry] = []
    @Published var totalQuizScore: Int = 0
    @Published var totalQuizQuestions: Int = 0
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var firstLaunchDate: Date = Date()
    @Published var lastActiveDate: Date = Date()
    @Published var categoryViewCounts: [String: Int] = [:]
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Init
    private init() {
        loadAll()
        updateStreak()
    }
    
    // MARK: - Load
    private func loadAll() {
        if let saved = defaults.array(forKey: Keys.viewedAlgorithms) as? [String] {
            viewedAlgorithms = Set(saved)
        }
        
        visualizationsStarted = defaults.integer(forKey: Keys.visualizationsStarted)
        
        if let saved = defaults.array(forKey: Keys.visualizationAlgorithms) as? [String] {
            visualizationAlgorithms = Set(saved)
        }
        
        quizzesCompleted = defaults.integer(forKey: Keys.quizzesCompleted)
        totalQuizScore = defaults.integer(forKey: Keys.totalQuizScore)
        totalQuizQuestions = defaults.integer(forKey: Keys.totalQuizQuestions)
        currentStreak = defaults.integer(forKey: Keys.currentStreak)
        longestStreak = defaults.integer(forKey: Keys.longestStreak)
        
        if let data = defaults.data(forKey: Keys.quizHistory),
           let decoded = try? JSONDecoder().decode([QuizHistoryEntry].self, from: data) {
            quizHistory = decoded
        }
        
        if let date = defaults.object(forKey: Keys.firstLaunchDate) as? Date {
            firstLaunchDate = date
        } else {
            firstLaunchDate = Date()
            defaults.set(firstLaunchDate, forKey: Keys.firstLaunchDate)
        }
        
        if let date = defaults.object(forKey: Keys.lastActiveDate) as? Date {
            lastActiveDate = date
        } else {
            lastActiveDate = Date()
            defaults.set(lastActiveDate, forKey: Keys.lastActiveDate)
        }
        
        if let saved = defaults.dictionary(forKey: Keys.categoryViewCounts) as? [String: Int] {
            categoryViewCounts = saved
        }
    }
    
    // MARK: - Track Algorithm Viewed
    func trackAlgorithmViewed(_ algorithmName: String, categoryName: String) {
        viewedAlgorithms.insert(algorithmName)
        defaults.set(Array(viewedAlgorithms), forKey: Keys.viewedAlgorithms)
        
        let current = categoryViewCounts[categoryName] ?? 0
        categoryViewCounts[categoryName] = current + 1
        defaults.set(categoryViewCounts, forKey: Keys.categoryViewCounts)
        
        updateStreak()
    }
    
    // MARK: - Track Visualization Started
    func trackVisualizationStarted(_ algorithmName: String) {
        visualizationsStarted += 1
        defaults.set(visualizationsStarted, forKey: Keys.visualizationsStarted)
        
        visualizationAlgorithms.insert(algorithmName)
        defaults.set(Array(visualizationAlgorithms), forKey: Keys.visualizationAlgorithms)
        
        updateStreak()
    }
    
    // MARK: - Track Quiz Completed
    func trackQuizCompleted(algorithmName: String, categoryName: String, score: Int, totalQuestions: Int) {
        quizzesCompleted += 1
        defaults.set(quizzesCompleted, forKey: Keys.quizzesCompleted)
        
        totalQuizScore += score
        defaults.set(totalQuizScore, forKey: Keys.totalQuizScore)
        
        totalQuizQuestions += totalQuestions
        defaults.set(totalQuizQuestions, forKey: Keys.totalQuizQuestions)
        
        let entry = QuizHistoryEntry(
            algorithmName: algorithmName,
            categoryName: categoryName,
            score: score,
            totalQuestions: totalQuestions,
            date: Date()
        )
        quizHistory.append(entry)
        
        if let encoded = try? JSONEncoder().encode(quizHistory) {
            defaults.set(encoded, forKey: Keys.quizHistory)
        }
        
        updateStreak()
    }
    
    // MARK: - Streak Management
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActive = calendar.startOfDay(for: lastActiveDate)
        
        if today == lastActive {
            // Same day, no change
        } else if calendar.isDate(today, inSameDayAs: lastActive.addingTimeInterval(86400)) {
            // Consecutive day
            currentStreak += 1
            if currentStreak > longestStreak {
                longestStreak = currentStreak
                defaults.set(longestStreak, forKey: Keys.longestStreak)
            }
        } else {
            // Streak broken
            currentStreak = 1
        }
        
        defaults.set(currentStreak, forKey: Keys.currentStreak)
        lastActiveDate = Date()
        defaults.set(lastActiveDate, forKey: Keys.lastActiveDate)
    }
    
    // MARK: - Computed Properties
    
    var totalAlgorithmsAvailable: Int {
        return Algorithm.searchingAlgorithms.count +
               Algorithm.sortingAlgorithms.count +
               Algorithm.arrayAlgorithms.count +
               Algorithm.stringAlgorithms.count +
               Algorithm.recursionAlgorithms.count +
               Algorithm.DPAlgorithms.count
    }
    
    var totalCategoriesExplored: Int {
        return categoryViewCounts.keys.count
    }
    
    var overallQuizPercentage: Double {
        guard totalQuizQuestions > 0 else { return 0 }
        return Double(totalQuizScore) / Double(totalQuizQuestions) * 100
    }
    
    var daysSinceFirstLaunch: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: firstLaunchDate, to: Date())
        return max(components.day ?? 0, 0)
    }
    
    var recentQuizzes: [QuizHistoryEntry] {
        return Array(quizHistory.sorted { $0.date > $1.date }.prefix(10))
    }
    
    func algorithmsViewedInCategory(_ categoryName: String) -> Int {
        let algorithms: [Algorithm]
        switch categoryName {
        case "Searching Algorithms": algorithms = Algorithm.searchingAlgorithms
        case "Sorting Algorithms": algorithms = Algorithm.sortingAlgorithms
        case "Array Algorithms": algorithms = Algorithm.arrayAlgorithms
        case "String Algorithms": algorithms = Algorithm.stringAlgorithms
        case "Recursion & Backtracking": algorithms = Algorithm.recursionAlgorithms
        case "Dynamic Programming": algorithms = Algorithm.DPAlgorithms
        default: return 0
        }
        return algorithms.filter { viewedAlgorithms.contains($0.name) }.count
    }
    
    func totalAlgorithmsInCategory(_ categoryName: String) -> Int {
        switch categoryName {
        case "Searching Algorithms": return Algorithm.searchingAlgorithms.count
        case "Sorting Algorithms": return Algorithm.sortingAlgorithms.count
        case "Array Algorithms": return Algorithm.arrayAlgorithms.count
        case "String Algorithms": return Algorithm.stringAlgorithms.count
        case "Recursion & Backtracking": return Algorithm.recursionAlgorithms.count
        case "Dynamic Programming": return Algorithm.DPAlgorithms.count
        default: return 0
        }
    }
    
    func categoryProgress(_ categoryName: String) -> Double {
        let total = totalAlgorithmsInCategory(categoryName)
        guard total > 0 else { return 0 }
        return Double(algorithmsViewedInCategory(categoryName)) / Double(total)
    }
    
    func bestQuizScore(for algorithmName: String) -> QuizHistoryEntry? {
        return quizHistory
            .filter { $0.algorithmName == algorithmName }
            .max { $0.percentage < $1.percentage }
    }
    
    // MARK: - Reset
    func resetAllProgress() {
        viewedAlgorithms = []
        visualizationsStarted = 0
        visualizationAlgorithms = []
        quizzesCompleted = 0
        quizHistory = []
        totalQuizScore = 0
        totalQuizQuestions = 0
        currentStreak = 1
        categoryViewCounts = [:]
        
        defaults.removeObject(forKey: Keys.viewedAlgorithms)
        defaults.removeObject(forKey: Keys.visualizationsStarted)
        defaults.removeObject(forKey: Keys.visualizationAlgorithms)
        defaults.removeObject(forKey: Keys.quizzesCompleted)
        defaults.removeObject(forKey: Keys.quizHistory)
        defaults.removeObject(forKey: Keys.totalQuizScore)
        defaults.removeObject(forKey: Keys.totalQuizQuestions)
        defaults.removeObject(forKey: Keys.categoryViewCounts)
        defaults.set(1, forKey: Keys.currentStreak)
    }
}
