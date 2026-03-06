import SwiftUI

struct ProfileView: View {
    @Environment(AppViewModel.self) private var appVM
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    avatarSection
                    progressSection
                    statsGrid
                    conceptsLearned
                    resetSection
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(DojoTheme.surfaceBackground)
            .navigationTitle("Profile")
            .alert("Reset All Progress?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    withAnimation {
                        appVM.userProgress.resetAll()
                    }
                }
            } message: {
                Text("This will clear all lesson completions, challenge scores, and quiz progress. This cannot be undone.")
            }
        }
    }

    // MARK: - Avatar

    private var avatarSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(DojoTheme.heroGradient)
                    .frame(width: 100, height: 100)

                Text(appVM.userProgress.masteryEmoji)
                    .font(.system(size: 48))
            }

            Text(appVM.userProgress.masteryTitle)
                .font(.title.bold())

            Text("\(appVM.userProgress.xpPoints) XP earned")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
    }

    // MARK: - Progress

    private var progressSection: some View {
        VStack(spacing: 16) {
            Text("Overall Mastery")
                .sectionHeader()

            ProgressRing(
                progress: appVM.userProgress.overallProgress,
                lineWidth: 12,
                size: 140,
                gradient: DojoTheme.heroGradient
            )

            HStack(spacing: 30) {
                progressLabel(
                    label: "Lessons",
                    count: appVM.userProgress.completedLessons.count,
                    total: appVM.userProgress.totalLessons,
                    color: .blue
                )
                progressLabel(
                    label: "Challenges",
                    count: appVM.userProgress.completedChallenges.count,
                    total: appVM.userProgress.totalChallenges,
                    color: .orange
                )
            }
        }
        .padding()
        .glassCard()
    }

    private func progressLabel(label: String, count: Int, total: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(count)/\(total)")
                .font(.title2.bold().monospacedDigit())
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Stats

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statTile(icon: "flame.fill", label: "Current Streak", value: "\(appVM.userProgress.currentStreak) days", color: .orange)
            statTile(icon: "star.fill", label: "XP Points", value: "\(appVM.userProgress.xpPoints)", color: .yellow)
            statTile(icon: "brain.fill", label: "Mastery Level", value: appVM.userProgress.masteryTitle, color: .purple)
            statTile(icon: "trophy.fill", label: "Challenges Won", value: "\(appVM.userProgress.completedChallenges.count)", color: .blue)
        }
    }

    private func statTile(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassCard()
    }

    // MARK: - Concepts Learned

    private var conceptsLearned: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Concepts Explored")
                .sectionHeader()

            let completedLessonObjects = Lesson.allLessons.filter { appVM.userProgress.isLessonComplete($0.id) }
            let allConcepts = completedLessonObjects.flatMap { $0.concepts }

            if allConcepts.isEmpty {
                Text("Complete lessons to see your concepts here!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                FlowLayout(spacing: 6) {
                    ForEach(allConcepts, id: \.self) { concept in
                        Text(concept)
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.purple.opacity(0.1)))
                            .foregroundStyle(.purple)
                    }
                }
            }
        }
    }

    // MARK: - Reset

    private var resetSection: some View {
        Button(role: .destructive) {
            showResetConfirmation = true
        } label: {
            Label("Reset All Progress", systemImage: "arrow.counterclockwise")
                .font(.subheadline)
                .foregroundStyle(.red)
        }
        .padding(.top, 8)
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = CGPoint(
                x: bounds.minX + result.positions[index].x,
                y: bounds.minY + result.positions[index].y
            )
            subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (positions, CGSize(width: maxX, height: y + rowHeight))
    }
}

#Preview {
    ProfileView()
        .environment(AppViewModel())
}
