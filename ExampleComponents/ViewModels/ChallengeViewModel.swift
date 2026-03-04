import SwiftUI

@Observable
final class ChallengeViewModel {
    private(set) var challenges: [Challenge]
    var currentIndex: Int = 0
    var selectedAnswer: Int? = nil
    var hasAnswered: Bool = false
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var showResult: Bool = false

    var currentChallenge: Challenge? {
        guard currentIndex < challenges.count else { return nil }
        return challenges[currentIndex]
    }

    var isComplete: Bool {
        currentIndex >= challenges.count
    }

    var scorePercentage: Double {
        let total = correctCount + incorrectCount
        guard total > 0 else { return 0 }
        return Double(correctCount) / Double(total)
    }

    init(forDay day: Int? = nil) {
        if let day {
            self.challenges = Challenge.allChallenges.filter { $0.lessonDay == day }
        } else {
            self.challenges = Challenge.allChallenges
        }
    }

    func selectAnswer(_ index: Int) {
        guard !hasAnswered else { return }
        selectedAnswer = index
        hasAnswered = true

        if let challenge = currentChallenge, index == challenge.correctAnswerIndex {
            correctCount += 1
        } else {
            incorrectCount += 1
        }
    }

    func nextChallenge() {
        selectedAnswer = nil
        hasAnswered = false
        currentIndex += 1

        if isComplete {
            showResult = true
        }
    }

    func restart() {
        currentIndex = 0
        selectedAnswer = nil
        hasAnswered = false
        correctCount = 0
        incorrectCount = 0
        showResult = false
    }
}
