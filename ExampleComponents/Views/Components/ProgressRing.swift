import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    var gradient: LinearGradient = DojoTheme.heroGradient

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    HStack(spacing: 30) {
        ProgressRing(progress: 0.25, lineWidth: 8, size: 80)
        ProgressRing(progress: 0.65, lineWidth: 10, size: 100, gradient: DojoTheme.warmGradient)
        ProgressRing(progress: 1.0, lineWidth: 12, size: 120, gradient: DojoTheme.successGradient)
    }
    .padding()
}
