import SwiftUI

struct ChallengesView: View {
    @Environment(AppViewModel.self) private var appVM
    @State private var challengeVM = ChallengeViewModel()
    @State private var selectedDay: Int? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if challengeVM.isComplete || challengeVM.showResult {
                    resultView
                } else if let challenge = challengeVM.currentChallenge {
                    activeChallenge(challenge)
                } else {
                    daySelector
                }
            }
            .navigationTitle("Challenges")
            .background(DojoTheme.surfaceBackground)
        }
    }

    // MARK: - Day Selector

    private var daySelector: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Choose a Topic")
                    .font(.title2.bold())
                    .padding(.top)

                Text("Test your knowledge for each day's lesson")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                allChallengesButton

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Lesson.allLessons) { lesson in
                        dayCard(lesson)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
    }

    private var allChallengesButton: some View {
        Button {
            challengeVM = ChallengeViewModel()
            challengeVM.restart()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                Text("All Challenges")
                    .font(.headline)
                Spacer()
                Text("\(Challenge.allChallenges.count) Questions")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(DojoTheme.heroGradient)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private func dayCard(_ lesson: Lesson) -> some View {
        let dayCount = Challenge.allChallenges.filter { $0.lessonDay == lesson.day }.count
        return Button {
            challengeVM = ChallengeViewModel(forDay: lesson.day)
        } label: {
            VStack(spacing: 8) {
                Image(systemName: lesson.icon)
                    .font(.title)
                    .foregroundStyle(DojoTheme.color(for: lesson.color))

                Text("Day \(lesson.day)")
                    .font(.headline)

                Text(lesson.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(dayCount) Qs")
                    .font(.caption2.bold())
                    .foregroundStyle(DojoTheme.color(for: lesson.color))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .glassCard()
        }
        .buttonStyle(.plain)
    }

    // MARK: - Active Challenge

    private func activeChallenge(_ challenge: Challenge) -> some View {
        VStack(spacing: 16) {
            progressBar

            ScrollView {
                ChallengeCardView(
                    challenge: challenge,
                    selectedAnswer: challengeVM.selectedAnswer,
                    hasAnswered: challengeVM.hasAnswered,
                    onSelectAnswer: { challengeVM.selectAnswer($0) }
                )
                .padding(.horizontal)
            }

            if challengeVM.hasAnswered {
                Button {
                    withAnimation {
                        challengeVM.nextChallenge()
                    }
                } label: {
                    Text(challengeVM.currentIndex + 1 >= challengeVM.challenges.count ? "See Results" : "Next Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(DojoTheme.heroGradient)
                        )
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .transition(.move(edge: .bottom))
            }
        }
        .padding(.bottom)
    }

    private var progressBar: some View {
        VStack(spacing: 4) {
            HStack {
                Text("Question \(challengeVM.currentIndex + 1) of \(challengeVM.challenges.count)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("\(challengeVM.correctCount)").font(.caption.bold())
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                    Text("\(challengeVM.incorrectCount)").font(.caption.bold())
                }
            }
            .padding(.horizontal)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(DojoTheme.heroGradient)
                        .frame(width: geo.size.width * CGFloat(challengeVM.currentIndex + 1) / CGFloat(max(challengeVM.challenges.count, 1)))
                        .animation(.snappy, value: challengeVM.currentIndex)
                }
            }
            .frame(height: 6)
            .padding(.horizontal)
        }
    }

    // MARK: - Result

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: challengeVM.scorePercentage >= 0.7 ? "party.popper.fill" : "arrow.counterclockwise")
                .font(.system(size: 60))
                .foregroundStyle(challengeVM.scorePercentage >= 0.7 ? .yellow : .orange)
                .symbolEffect(.bounce, value: challengeVM.showResult)

            Text(challengeVM.scorePercentage >= 0.7 ? "Great Job!" : "Keep Practicing!")
                .font(.largeTitle.bold())

            ProgressRing(
                progress: challengeVM.scorePercentage,
                lineWidth: 10,
                size: 120,
                gradient: challengeVM.scorePercentage >= 0.7 ? DojoTheme.successGradient : DojoTheme.warmGradient
            )

            Text("\(challengeVM.correctCount) out of \(challengeVM.challenges.count) correct")
                .font(.title3)
                .foregroundStyle(.secondary)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    withAnimation { challengeVM.restart() }
                } label: {
                    Label("Retry", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemGray5)))
                }
                .buttonStyle(.plain)

                Button {
                    for c in challengeVM.challenges {
                        appVM.userProgress.markChallengeComplete(c.id)
                    }
                    withAnimation {
                        challengeVM = ChallengeViewModel(forDay: -1)
                    }
                } label: {
                    Label("Done", systemImage: "checkmark")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(DojoTheme.heroGradient))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ChallengesView()
        .environment(AppViewModel())
}
