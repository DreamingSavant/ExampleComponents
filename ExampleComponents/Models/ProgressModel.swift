import Foundation

@Observable
final class UserProgress {
    var completedLessons: Set<Int> = [] {
        didSet { save() }
    }
    var completedChallenges: Set<Int> = [] {
        didSet { save() }
    }
    var currentStreak: Int = 0 {
        didSet { save() }
    }
    var totalTimeSpentMinutes: Int = 0 {
        didSet { save() }
    }
    var lastAccessDate: Date? {
        didSet { save() }
    }
    var miniQuizScores: [Int: Int] = [:] {
        didSet { save() }
    }

    var totalLessons: Int { Lesson.allLessons.count }
    var totalChallenges: Int { Challenge.allChallenges.count }

    var lessonsProgress: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons.count) / Double(totalLessons)
    }

    var challengesProgress: Double {
        guard totalChallenges > 0 else { return 0 }
        return Double(completedChallenges.count) / Double(totalChallenges)
    }

    var overallProgress: Double {
        (lessonsProgress + challengesProgress) / 2.0
    }

    var xpPoints: Int {
        completedLessons.count * 100 + completedChallenges.count * 25 + miniQuizScores.values.reduce(0, +) * 15
    }

    var masteryTitle: String {
        switch overallProgress {
        case 0..<0.15: return "Padawan"
        case 0.15..<0.35: return "Apprentice"
        case 0.35..<0.55: return "Journeyman"
        case 0.55..<0.75: return "Adept"
        case 0.75..<0.90: return "Expert"
        case 0.90...1.0: return "SwiftUI Master"
        default: return "Padawan"
        }
    }

    var masteryEmoji: String {
        switch overallProgress {
        case 0..<0.15: return "🌱"
        case 0.15..<0.35: return "🌿"
        case 0.35..<0.55: return "🌳"
        case 0.55..<0.75: return "⚡"
        case 0.75..<0.90: return "🔥"
        case 0.90...1.0: return "👑"
        default: return "🌱"
        }
    }

    init() {
        load()
    }

    func markLessonComplete(_ lessonId: Int) {
        completedLessons.insert(lessonId)
        updateStreak()
    }

    func markChallengeComplete(_ challengeId: Int) {
        completedChallenges.insert(challengeId)
    }

    func recordMiniQuizScore(day: Int, correct: Int) {
        let existing = miniQuizScores[day] ?? 0
        if correct > existing {
            miniQuizScores[day] = correct
        }
    }

    func isLessonComplete(_ lessonId: Int) -> Bool {
        completedLessons.contains(lessonId)
    }

    func isChallengeComplete(_ challengeId: Int) -> Bool {
        completedChallenges.contains(challengeId)
    }

    func resetAll() {
        completedLessons = []
        completedChallenges = []
        currentStreak = 0
        totalTimeSpentMinutes = 0
        lastAccessDate = nil
        miniQuizScores = [:]
        clearSaved()
    }

    private func updateStreak() {
        let calendar = Calendar.current
        if let last = lastAccessDate, calendar.isDateInToday(last) {
            return
        } else if let last = lastAccessDate, calendar.isDateInYesterday(last) {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        lastAccessDate = Date()
    }

    // MARK: - Persistence

    private static let lessonsKey = "dojo_completedLessons"
    private static let challengesKey = "dojo_completedChallenges"
    private static let streakKey = "dojo_streak"
    private static let timeKey = "dojo_time"
    private static let dateKey = "dojo_lastDate"
    private static let quizKey = "dojo_miniQuizScores"

    private var isSaving = false

    private func save() {
        guard !isSaving else { return }
        isSaving = true
        defer { isSaving = false }

        let defaults = UserDefaults.standard
        defaults.set(Array(completedLessons), forKey: Self.lessonsKey)
        defaults.set(Array(completedChallenges), forKey: Self.challengesKey)
        defaults.set(currentStreak, forKey: Self.streakKey)
        defaults.set(totalTimeSpentMinutes, forKey: Self.timeKey)
        defaults.set(lastAccessDate?.timeIntervalSince1970, forKey: Self.dateKey)

        let quizData = miniQuizScores.reduce(into: [String: Int]()) { $0["\($1.key)"] = $1.value }
        defaults.set(quizData, forKey: Self.quizKey)
    }

    private func load() {
        let defaults = UserDefaults.standard
        if let lessons = defaults.array(forKey: Self.lessonsKey) as? [Int] {
            completedLessons = Set(lessons)
        }
        if let challenges = defaults.array(forKey: Self.challengesKey) as? [Int] {
            completedChallenges = Set(challenges)
        }
        currentStreak = defaults.integer(forKey: Self.streakKey)
        totalTimeSpentMinutes = defaults.integer(forKey: Self.timeKey)
        if let timestamp = defaults.object(forKey: Self.dateKey) as? Double {
            lastAccessDate = Date(timeIntervalSince1970: timestamp)
        }
        if let quizData = defaults.dictionary(forKey: Self.quizKey) as? [String: Int] {
            miniQuizScores = quizData.reduce(into: [Int: Int]()) { dict, pair in
                if let key = Int(pair.key) { dict[key] = pair.value }
            }
        }
    }

    private func clearSaved() {
        let defaults = UserDefaults.standard
        [Self.lessonsKey, Self.challengesKey, Self.streakKey, Self.timeKey, Self.dateKey, Self.quizKey].forEach {
            defaults.removeObject(forKey: $0)
        }
    }
}
