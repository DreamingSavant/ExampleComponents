import Foundation

@Observable
final class UserProgress {
    var completedLessons: Set<Int> = []
    var completedChallenges: Set<Int> = []
    var currentStreak: Int = 0
    var totalTimeSpentMinutes: Int = 0
    var lastAccessDate: Date?

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

    func markLessonComplete(_ lessonId: Int) {
        completedLessons.insert(lessonId)
        updateStreak()
    }

    func markChallengeComplete(_ challengeId: Int) {
        completedChallenges.insert(challengeId)
    }

    func isLessonComplete(_ lessonId: Int) -> Bool {
        completedLessons.contains(lessonId)
    }

    func isChallengeComplete(_ challengeId: Int) -> Bool {
        completedChallenges.contains(challengeId)
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
}
