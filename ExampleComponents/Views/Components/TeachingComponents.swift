import SwiftUI

// MARK: - Lesson Objective

struct LessonObjectiveView: View {
    let day: Int
    let title: String
    let objectives: [String]
    let estimatedMinutes: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .font(.title3)
                    .foregroundStyle(color)
                Text("Today's Objective")
                    .font(.headline)
                    .foregroundStyle(color)
            }

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(objectives.enumerated()), id: \.offset) { _, objective in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle")
                            .font(.caption)
                            .foregroundStyle(color)
                            .padding(.top, 2)
                        Text(objective)
                            .font(.subheadline)
                    }
                }
            }

            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("~\(estimatedMinutes) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Concept Explainer

struct ConceptExplainer: View {
    let title: String
    let explanation: String
    var whyItMatters: String? = nil
    var whenToUse: String? = nil
    let color: Color

    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(color)
                Spacer()
                Button {
                    withAnimation(.snappy) { isExpanded.toggle() }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            if isExpanded {
                Text(explanation)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)

                if let why = whyItMatters {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                            .padding(.top, 2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Why it matters")
                                .font(.caption.bold())
                                .foregroundStyle(.yellow)
                            Text(why)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if let when = whenToUse {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(.top, 2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("When to use")
                                .font(.caption.bold())
                                .foregroundStyle(.blue)
                            Text(when)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.04))
        )
    }
}

// MARK: - Tip Box

enum TipBoxStyle {
    case tip, warning, mistake, info

    var icon: String {
        switch self {
        case .tip: return "lightbulb.max.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .mistake: return "xmark.octagon.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .tip: return .yellow
        case .warning: return .orange
        case .mistake: return .red
        case .info: return .blue
        }
    }

    var label: String {
        switch self {
        case .tip: return "Pro Tip"
        case .warning: return "Watch Out"
        case .mistake: return "Common Mistake"
        case .info: return "Good to Know"
        }
    }
}

struct TipBox: View {
    let style: TipBoxStyle
    let content: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: style.icon)
                .font(.body)
                .foregroundStyle(style.color)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(style.label)
                    .font(.caption.bold())
                    .foregroundStyle(style.color)
                Text(content)
                    .font(.caption)
                    .foregroundStyle(.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(style.color.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style.color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Key Takeaways

struct KeyTakeawaysView: View {
    let takeaways: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile.fill")
                    .foregroundStyle(color)
                Text("Key Takeaways")
                    .font(.headline)
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(takeaways.enumerated()), id: \.offset) { index, takeaway in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.caption2.bold().monospacedDigit())
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                            .background(Circle().fill(color))
                        Text(takeaway)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Mini Quiz

struct MiniQuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

struct MiniQuizView: View {
    let title: String
    let questions: [MiniQuizQuestion]
    let color: Color

    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var hasAnswered = false
    @State private var correctCount = 0
    @State private var isComplete = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.fill")
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(color)
                Spacer()
                if !isComplete {
                    Text("\(currentIndex + 1)/\(questions.count)")
                        .font(.caption.bold().monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }

            if isComplete {
                completeState
            } else if currentIndex < questions.count {
                questionCard(questions[currentIndex])
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func questionCard(_ q: MiniQuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(q.question)
                .font(.subheadline.bold())
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 8) {
                ForEach(Array(q.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        guard !hasAnswered else { return }
                        selectedAnswer = index
                        hasAnswered = true
                        if index == q.correctIndex { correctCount += 1 }
                    } label: {
                        HStack {
                            Text(["A", "B", "C", "D"][index])
                                .font(.caption2.bold().monospaced())
                                .foregroundStyle(.secondary)
                                .frame(width: 22, height: 22)
                                .background(Circle().fill(Color(.systemGray5)))

                            Text(option)
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)

                            Spacer()

                            if hasAnswered {
                                if index == q.correctIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else if index == selectedAnswer {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(answerBackground(for: index, correct: q.correctIndex))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(answerBorder(for: index, correct: q.correctIndex), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(hasAnswered)
                }
            }

            if hasAnswered {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: selectedAnswer == q.correctIndex ? "lightbulb.fill" : "exclamationmark.triangle.fill")
                        .foregroundStyle(selectedAnswer == q.correctIndex ? .yellow : .orange)
                        .font(.caption)
                    Text(q.explanation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                .transition(.opacity.combined(with: .move(edge: .bottom)))

                Button {
                    withAnimation(.snappy) {
                        if currentIndex + 1 >= questions.count {
                            isComplete = true
                        } else {
                            currentIndex += 1
                            selectedAnswer = nil
                            hasAnswered = false
                        }
                    }
                } label: {
                    Text(currentIndex + 1 >= questions.count ? "See Results" : "Next →")
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(color))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
        .animation(.gentle, value: hasAnswered)
    }

    private var completeState: some View {
        VStack(spacing: 10) {
            let perfect = correctCount == questions.count
            Image(systemName: perfect ? "star.fill" : "checkmark.circle")
                .font(.title)
                .foregroundStyle(perfect ? .yellow : color)

            Text(perfect ? "Perfect Score!" : "\(correctCount)/\(questions.count) Correct")
                .font(.headline)

            Text(perfect ? "You've mastered this concept!" : "Review the sections above and try again.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                withAnimation(.snappy) {
                    currentIndex = 0
                    selectedAnswer = nil
                    hasAnswered = false
                    correctCount = 0
                    isComplete = false
                }
            }
            .font(.caption.bold())
            .buttonStyle(.bordered)
            .tint(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private func answerBackground(for index: Int, correct: Int) -> Color {
        guard hasAnswered else { return Color(.systemGray6) }
        if index == correct { return .green.opacity(0.1) }
        if index == selectedAnswer { return .red.opacity(0.1) }
        return Color(.systemGray6)
    }

    private func answerBorder(for index: Int, correct: Int) -> Color {
        guard hasAnswered else { return .clear }
        if index == correct { return .green.opacity(0.4) }
        if index == selectedAnswer && index != correct { return .red.opacity(0.4) }
        return .clear
    }
}

// MARK: - Previews

#Preview("Lesson Objective") {
    LessonObjectiveView(
        day: 1,
        title: "Build a solid foundation with SwiftUI's core display views",
        objectives: ["Understand how Text works", "Use SF Symbols", "Create gradients"],
        estimatedMinutes: 10,
        color: .purple
    )
    .padding()
}

#Preview("Concept Explainer") {
    ConceptExplainer(
        title: "Understanding Text",
        explanation: "Text is the most basic building block in SwiftUI.",
        whyItMatters: "Every app displays text. Mastering it is essential.",
        whenToUse: "Whenever you need to display static or dynamic text content.",
        color: .purple
    )
    .padding()
}

#Preview("Tip Box") {
    VStack(spacing: 12) {
        TipBox(style: .tip, content: "Use semantic font styles for accessibility.")
        TipBox(style: .mistake, content: "Don't use .foregroundColor() — it's deprecated.")
        TipBox(style: .warning, content: "GeometryReader should be used sparingly.")
        TipBox(style: .info, content: "Labels automatically adapt to context.")
    }
    .padding()
}

#Preview("Key Takeaways") {
    KeyTakeawaysView(
        takeaways: ["Text is your most-used view", "Use semantic fonts", "Prefer SF Symbols"],
        color: .purple
    )
    .padding()
}
