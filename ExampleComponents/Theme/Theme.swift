import SwiftUI

enum DojoTheme {

    // MARK: - Lesson Colors

    static let lessonColors: [String: Color] = [
        "lessonPurple": Color(red: 0.55, green: 0.24, blue: 0.86),
        "lessonBlue": Color(red: 0.20, green: 0.45, blue: 0.95),
        "lessonGreen": Color(red: 0.18, green: 0.78, blue: 0.45),
        "lessonOrange": Color(red: 0.95, green: 0.55, blue: 0.15),
        "lessonTeal": Color(red: 0.12, green: 0.72, blue: 0.72),
        "lessonPink": Color(red: 0.92, green: 0.28, blue: 0.58),
        "lessonRed": Color(red: 0.90, green: 0.22, blue: 0.30),
    ]

    static func color(for key: String) -> Color {
        lessonColors[key] ?? .accentColor
    }

    // MARK: - Gradients

    static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.55, green: 0.24, blue: 0.86),
            Color(red: 0.20, green: 0.45, blue: 0.95),
            Color(red: 0.12, green: 0.72, blue: 0.72),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let warmGradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.55, blue: 0.15),
            Color(red: 0.92, green: 0.28, blue: 0.58),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let coolGradient = LinearGradient(
        colors: [
            Color(red: 0.20, green: 0.45, blue: 0.95),
            Color(red: 0.12, green: 0.72, blue: 0.72),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        colors: [
            Color(red: 0.18, green: 0.78, blue: 0.45),
            Color(red: 0.12, green: 0.72, blue: 0.72),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static func lessonGradient(for colorKey: String) -> LinearGradient {
        let base = color(for: colorKey)
        return LinearGradient(
            colors: [base, base.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Card Style

    static let cardCornerRadius: CGFloat = 20
    static let cardShadowRadius: CGFloat = 8

    // MARK: - Backgrounds

    static let surfaceBackground = Color(.systemBackground)
    static let secondarySurface = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
}

// MARK: - Custom View Modifiers

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DojoTheme.cardCornerRadius))
            .shadow(color: .black.opacity(0.08), radius: DojoTheme.cardShadowRadius, y: 4)
    }
}

struct ShowcaseCard: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(color.opacity(0.2), lineWidth: 1)
                    )
            )
    }
}

struct PulsingSymbol: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear { isPulsing = true }
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }

    func showcaseCard(color: Color) -> some View {
        modifier(ShowcaseCard(color: color))
    }

    func pulsingSymbol() -> some View {
        modifier(PulsingSymbol())
    }
}
