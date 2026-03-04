import SwiftUI

struct AchievementBadge: View {
    let title: String
    let icon: String
    let color: Color
    let isUnlocked: Bool

    @State private var showSparkle = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color.opacity(0.15) : Color.gray.opacity(0.08))
                    .frame(width: 64, height: 64)

                Circle()
                    .strokeBorder(isUnlocked ? color : Color.gray.opacity(0.2), lineWidth: 2)
                    .frame(width: 64, height: 64)

                Image(systemName: isUnlocked ? icon : "lock.fill")
                    .font(.title2)
                    .foregroundStyle(isUnlocked ? color : .gray.opacity(0.4))
                    .symbolEffect(.bounce, value: showSparkle)
            }

            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(isUnlocked ? .primary : .secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 80)
        .onAppear {
            if isUnlocked {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSparkle = true
                }
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        AchievementBadge(title: "First Steps", icon: "figure.walk", color: .blue, isUnlocked: true)
        AchievementBadge(title: "Layout Pro", icon: "square.grid.3x3", color: .orange, isUnlocked: true)
        AchievementBadge(title: "Animator", icon: "sparkles", color: .purple, isUnlocked: false)
    }
}
