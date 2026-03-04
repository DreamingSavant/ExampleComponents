import SwiftUI

struct LessonListView: View {
    @Environment(AppViewModel.self) private var appVM

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    progressOverview
                    lessonsList
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(DojoTheme.surfaceBackground)
            .navigationTitle("Lessons")
        }
    }

    private var progressOverview: some View {
        HStack(spacing: 20) {
            ProgressRing(
                progress: appVM.userProgress.lessonsProgress,
                lineWidth: 8,
                size: 80,
                gradient: DojoTheme.heroGradient
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("\(appVM.userProgress.completedLessons.count) of 7 Complete")
                    .font(.headline)
                Text("Each lesson takes ~10 minutes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Master SwiftUI in a week!")
                    .font(.caption)
                    .foregroundStyle(.purple)
            }
        }
        .padding()
        .glassCard()
        .padding(.top, 8)
    }

    private var lessonsList: some View {
        VStack(spacing: 12) {
            ForEach(Lesson.allLessons) { lesson in
                NavigationLink(value: lesson) {
                    LessonCard(
                        lesson: lesson,
                        isCompleted: appVM.userProgress.isLessonComplete(lesson.id),
                        action: {}
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: Lesson.self) { lesson in
            lessonDetail(for: lesson)
        }
    }

    @ViewBuilder
    private func lessonDetail(for lesson: Lesson) -> some View {
        switch lesson.day {
        case 1: Day1FoundationsView()
        case 2: Day2LayoutView()
        case 3: Day3ControlsView()
        case 4: Day4ListsNavigationView()
        case 5: Day5StateDataFlowView()
        case 6: Day6AnimationDrawingView()
        case 7: Day7AdvancedView()
        default: Text("Coming Soon")
        }
    }
}

#Preview {
    LessonListView()
        .environment(AppViewModel())
}
