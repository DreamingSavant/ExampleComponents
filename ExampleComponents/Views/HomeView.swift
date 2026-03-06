import SwiftUI

struct HomeView: View {
    @Environment(AppViewModel.self) private var appVM

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    heroSection
                    streakAndProgress
                    todaysLesson
                    quickActions
                    achievementsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(DojoTheme.surfaceBackground)
            .navigationTitle("SwiftUI Dojo")
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(DojoTheme.heroGradient)
                    .frame(height: 180)

                VStack(spacing: 8) {
                    Text("\(appVM.userProgress.masteryEmoji)")
                        .font(.system(size: 44))

                    Text("Welcome, \(appVM.userProgress.masteryTitle)!")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text("Your 7-day SwiftUI mastery journey")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))

                    Text("\(appVM.userProgress.xpPoints) XP")
                        .font(.caption.bold().monospacedDigit())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.2)))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Streak & Progress

    private var streakAndProgress: some View {
        HStack(spacing: 16) {
            statCard(
                icon: "flame.fill",
                value: "\(appVM.userProgress.currentStreak)",
                label: "Day Streak",
                color: .orange
            )

            statCard(
                icon: "checkmark.circle.fill",
                value: "\(appVM.userProgress.completedLessons.count)/7",
                label: "Lessons",
                color: .green
            )

            statCard(
                icon: "trophy.fill",
                value: "\(appVM.userProgress.completedChallenges.count)/\(appVM.userProgress.totalChallenges)",
                label: "Challenges",
                color: .yellow
            )
        }
    }

    private func statCard(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title3.bold().monospacedDigit())

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassCard()
    }

    // MARK: - Today's Lesson

    private var todaysLesson: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continue Learning")
                .sectionHeader()

            let nextLesson = nextIncompleteLesson
            LessonCard(
                lesson: nextLesson,
                isCompleted: appVM.userProgress.isLessonComplete(nextLesson.id)
            ) {
                appVM.selectedTab = .lessons
            }
        }
    }

    private var nextIncompleteLesson: Lesson {
        Lesson.allLessons.first { !appVM.userProgress.isLessonComplete($0.id) }
            ?? Lesson.allLessons[0]
    }

    // MARK: - Quick Actions

    private var quickActions: some View {
        VStack(spacing: 12) {
            Button {
                appVM.selectedTab = .challenges
            } label: {
                HStack {
                    Image(systemName: "bolt.fill")
                        .font(.title2)
                    Text("Quick Challenge")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                }
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(DojoTheme.warmGradient)
                )
            }
            .buttonStyle(.plain)

            Button {
                appVM.selectedTab = .reference
            } label: {
                HStack {
                    Image(systemName: "text.book.closed.fill")
                        .font(.title2)
                    Text("Concept Reference")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                }
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(DojoTheme.coolGradient)
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Achievements

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .sectionHeader()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    AchievementBadge(title: "First Steps", icon: "figure.walk", color: .blue, isUnlocked: appVM.userProgress.completedLessons.count >= 1)
                    AchievementBadge(title: "Layout Pro", icon: "square.grid.3x3", color: .orange, isUnlocked: appVM.userProgress.isLessonComplete(2))
                    AchievementBadge(title: "Control Freak", icon: "slider.horizontal.3", color: .green, isUnlocked: appVM.userProgress.isLessonComplete(3))
                    AchievementBadge(title: "Navigator", icon: "map.fill", color: .teal, isUnlocked: appVM.userProgress.isLessonComplete(4))
                    AchievementBadge(title: "Data Wizard", icon: "wand.and.rays", color: .purple, isUnlocked: appVM.userProgress.isLessonComplete(5))
                    AchievementBadge(title: "Animator", icon: "sparkles", color: .pink, isUnlocked: appVM.userProgress.isLessonComplete(6))
                    AchievementBadge(title: "Grand Master", icon: "crown.fill", color: .yellow, isUnlocked: appVM.userProgress.completedLessons.count == 7)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AppViewModel())
}
