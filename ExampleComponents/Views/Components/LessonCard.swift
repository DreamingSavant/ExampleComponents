import SwiftUI

struct LessonCard: View {
    let lesson: Lesson
    let isCompleted: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                iconBadge
                lessonInfo
                Spacer()
                statusIndicator
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: DojoTheme.cardCornerRadius)
                    .fill(DojoTheme.color(for: lesson.color).opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: DojoTheme.cardCornerRadius)
                            .strokeBorder(
                                DojoTheme.color(for: lesson.color).opacity(isCompleted ? 0.4 : 0.15),
                                lineWidth: 1.5
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.snappy) { isPressed = pressing }
        }, perform: {})
    }

    private var iconBadge: some View {
        ZStack {
            Circle()
                .fill(DojoTheme.lessonGradient(for: lesson.color))
                .frame(width: 52, height: 52)

            Image(systemName: lesson.icon)
                .font(.title2)
                .foregroundStyle(.white)
        }
    }

    private var lessonInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Day \(lesson.day)")
                .font(.caption.bold())
                .foregroundStyle(DojoTheme.color(for: lesson.color))

            Text(lesson.title)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(lesson.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                ForEach(0..<lesson.difficulty.stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(.orange)
                }
            }
        }
    }

    @ViewBuilder
    private var statusIndicator: some View {
        if isCompleted {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.green)
        } else {
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        LessonCard(lesson: Lesson.allLessons[0], isCompleted: true, action: {})
        LessonCard(lesson: Lesson.allLessons[1], isCompleted: false, action: {})
        LessonCard(lesson: Lesson.allLessons[5], isCompleted: false, action: {})
    }
    .padding()
}
