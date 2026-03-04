import SwiftUI

struct ChallengeCardView: View {
    let challenge: Challenge
    let selectedAnswer: Int?
    let hasAnswered: Bool
    let onSelectAnswer: (Int) -> Void

    var body: some View {
        VStack(spacing: 20) {
            questionHeader

            VStack(spacing: 10) {
                ForEach(Array(challenge.options.enumerated()), id: \.offset) { index, option in
                    AnswerButton(
                        text: option,
                        index: index,
                        isSelected: selectedAnswer == index,
                        isCorrect: index == challenge.correctAnswerIndex,
                        hasAnswered: hasAnswered,
                        action: { onSelectAnswer(index) }
                    )
                }
            }

            if hasAnswered {
                explanationBox
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: DojoTheme.cardCornerRadius)
                .fill(.ultraThinMaterial)
        )
        .animation(.gentle, value: hasAnswered)
    }

    private var questionHeader: some View {
        VStack(spacing: 8) {
            Image(systemName: "questionmark.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(DojoTheme.heroGradient)

            Text(challenge.question)
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var explanationBox: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: selectedAnswer == challenge.correctAnswerIndex ? "lightbulb.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(selectedAnswer == challenge.correctAnswerIndex ? .yellow : .orange)

            Text(challenge.explanation)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct AnswerButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let hasAnswered: Bool
    let action: () -> Void

    private var backgroundColor: Color {
        guard hasAnswered else {
            return isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6)
        }
        if isCorrect { return .green.opacity(0.15) }
        if isSelected && !isCorrect { return .red.opacity(0.15) }
        return Color(.systemGray6)
    }

    private var borderColor: Color {
        guard hasAnswered else {
            return isSelected ? .blue : .clear
        }
        if isCorrect { return .green }
        if isSelected && !isCorrect { return .red }
        return .clear
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(letterForIndex(index))
                    .font(.caption.bold().monospaced())
                    .foregroundStyle(.secondary)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color(.systemGray5)))

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if hasAnswered {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : (isSelected ? "xmark.circle.fill" : ""))
                        .foregroundStyle(isCorrect ? .green : .red)
                        .transition(.scale)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(borderColor, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(hasAnswered)
    }

    private func letterForIndex(_ index: Int) -> String {
        ["A", "B", "C", "D"][index]
    }
}

#Preview {
    ChallengeCardView(
        challenge: Challenge.allChallenges[0],
        selectedAnswer: nil,
        hasAnswered: false,
        onSelectAnswer: { _ in }
    )
    .padding()
}
