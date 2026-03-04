import SwiftUI

struct Day6AnimationDrawingView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var isAnimating = false
    @State private var animationType: AnimType = .spring
    @State private var showShape = true
    @State private var shapeType: ShapeKind = .circle
    @State private var rotationDegrees: Double = 0
    @State private var pathProgress: CGFloat = 0
    @State private var phase: CGFloat = 0
    @State private var heroExpanded = false
    @Namespace private var heroNamespace

    private let lessonColor = DojoTheme.color(for: "lessonPink")

    enum AnimType: String, CaseIterable {
        case spring = "Spring"
        case easeIn = "Ease In"
        case easeOut = "Ease Out"
        case linear = "Linear"
        case bouncy = "Bouncy"
    }

    enum ShapeKind: String, CaseIterable {
        case circle = "Circle"
        case rectangle = "Rectangle"
        case capsule = "Capsule"
        case custom = "Star"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header
                explicitAnimationSection
                implicitAnimationSection
                transitionsSection
                matchedGeometrySection
                shapesSection
                customShapeSection
                pathDrawingSection
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 6: Animation")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "wand.and.stars")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Motion, Shapes & Canvas")
                .font(.title2.bold())

            Text("Bring your interfaces to life")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top)
    }

    // MARK: - Explicit Animation

    private var explicitAnimationSection: some View {
        ComponentShowcase(title: "withAnimation", description: "Explicit, controlled animations", color: lessonColor) {
            VStack(spacing: 16) {
                Picker("Type", selection: $animationType) {
                    ForEach(AnimType.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 120)

                    Circle()
                        .fill(lessonColor.gradient)
                        .frame(width: 50, height: 50)
                        .offset(x: isAnimating ? 100 : -100)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }

                Button("Animate") {
                    let anim: Animation = {
                        switch animationType {
                        case .spring: return .spring(response: 0.5, dampingFraction: 0.6)
                        case .easeIn: return .easeIn(duration: 0.6)
                        case .easeOut: return .easeOut(duration: 0.6)
                        case .linear: return .linear(duration: 0.6)
                        case .bouncy: return .spring(response: 0.4, dampingFraction: 0.3)
                        }
                    }()
                    withAnimation(anim) {
                        isAnimating.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(lessonColor)

                CodeSnippetView(code: """
                withAnimation(.spring(response: 0.5,
                                      dampingFraction: 0.6)) {
                    isAnimating.toggle()
                }
                // The view automatically animates all
                // properties affected by the state change
                """, title: "withAnimation.swift")
            }
        }
    }

    // MARK: - Implicit Animation

    private var implicitAnimationSection: some View {
        ComponentShowcase(title: ".animation()", description: "Attach animation to a value change", color: lessonColor) {
            VStack(spacing: 16) {
                HStack {
                    Text("Rotation: \(Int(rotationDegrees))°")
                        .font(.caption)
                    Slider(value: $rotationDegrees, in: 0...360)
                        .tint(lessonColor)
                }

                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(lessonColor)
                    .rotationEffect(.degrees(rotationDegrees))
                    .scaleEffect(1.0 + rotationDegrees / 720)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: rotationDegrees)

                CodeSnippetView(code: """
                Image(systemName: "star.fill")
                    .rotationEffect(.degrees(rotation))
                    .animation(.spring(), value: rotation)
                // Animates whenever 'rotation' changes
                """, title: "ImplicitAnimation.swift")
            }
        }
    }

    // MARK: - Transitions

    private var transitionsSection: some View {
        ComponentShowcase(title: "Transitions", description: "Animate views entering/exiting", color: lessonColor) {
            VStack(spacing: 16) {
                Button(showShape ? "Remove" : "Add") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showShape.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(lessonColor)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 120)

                    if showShape {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(lessonColor.gradient)
                            .frame(width: 80, height: 80)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .slide.combined(with: .opacity)
                            ))
                    }
                }

                CodeSnippetView(code: """
                if showShape {
                    RoundedRectangle(cornerRadius: 16)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .slide.combined(with: .opacity)
                        ))
                }
                """, title: "Transition.swift")
            }
        }
    }

    // MARK: - Matched Geometry

    private var matchedGeometrySection: some View {
        ComponentShowcase(title: "matchedGeometryEffect", description: "Hero animations between views", color: lessonColor) {
            VStack(spacing: 16) {
                if heroExpanded {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(lessonColor.gradient)
                        .matchedGeometryEffect(id: "hero", in: heroNamespace)
                        .frame(height: 200)
                        .overlay(
                            Text("Expanded View")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                heroExpanded = false
                            }
                        }
                } else {
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(lessonColor.gradient)
                            .matchedGeometryEffect(id: "hero", in: heroNamespace)
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    heroExpanded = true
                                }
                            }

                        VStack(alignment: .leading) {
                            Text("Tap to expand")
                                .font(.headline)
                            Text("Uses matchedGeometryEffect")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }

                CodeSnippetView(code: """
                @Namespace private var ns
                
                // Both views share the same ID + namespace
                RoundedRectangle()
                    .matchedGeometryEffect(id: "hero", in: ns)
                // SwiftUI morphs between them automatically
                """, title: "MatchedGeometry.swift")
            }
        }
    }

    // MARK: - Shapes

    private var shapesSection: some View {
        ComponentShowcase(title: "Built-in Shapes", description: "Circle, Rectangle, Capsule, and more", color: lessonColor) {
            VStack(spacing: 16) {
                Picker("Shape", selection: $shapeType) {
                    ForEach(ShapeKind.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)

                ZStack {
                    currentShapeView
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: shapeType)
                }
                .frame(height: 120)

                CodeSnippetView(code: """
                Circle()
                    .fill(.blue.gradient)
                    .frame(width: 100, height: 100)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.red, lineWidth: 3)
                
                Capsule()
                    .fill(.green)
                """, title: "Shapes.swift")
            }
        }
    }

    @ViewBuilder
    private var currentShapeView: some View {
        switch shapeType {
        case .circle:
            Circle().fill(lessonColor.gradient).frame(width: 100, height: 100)
        case .rectangle:
            RoundedRectangle(cornerRadius: 16).fill(lessonColor.gradient).frame(width: 100, height: 100)
        case .capsule:
            Capsule().fill(lessonColor.gradient).frame(width: 100, height: 100)
        case .custom:
            StarShape(points: 5).fill(lessonColor.gradient).frame(width: 100, height: 100)
        }
    }

    // MARK: - Custom Shape

    private var customShapeSection: some View {
        ComponentShowcase(title: "Custom Shape", description: "Create shapes with the Shape protocol", color: lessonColor) {
            VStack(spacing: 16) {
                StarShape(points: 5)
                    .fill(
                        AngularGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                            center: .center
                        )
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(phase * 360))
                    .onAppear {
                        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                            phase = 1
                        }
                    }

                CodeSnippetView(code: """
                struct StarShape: Shape {
                    let points: Int
                    
                    func path(in rect: CGRect) -> Path {
                        // Calculate star vertices
                        // using trigonometry and Path API
                        var path = Path()
                        // ... geometry math here
                        return path
                    }
                }
                """, title: "CustomShape.swift")
            }
        }
    }

    // MARK: - Path Drawing

    private var pathDrawingSection: some View {
        ComponentShowcase(title: "Path", description: "Draw freeform vector graphics", color: lessonColor) {
            VStack(spacing: 16) {
                HStack {
                    Text("Progress: \(Int(pathProgress * 100))%")
                        .font(.caption)
                    Slider(value: $pathProgress, in: 0...1)
                        .tint(lessonColor)
                }

                WaveShape(progress: pathProgress)
                    .stroke(lessonColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(height: 80)
                    .background(
                        WaveShape(progress: pathProgress)
                            .fill(lessonColor.opacity(0.1))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .animation(.spring(response: 0.3), value: pathProgress)

                CodeSnippetView(code: """
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 50))
                    path.addCurve(
                        to: CGPoint(x: 200, y: 50),
                        control1: CGPoint(x: 50, y: 0),
                        control2: CGPoint(x: 150, y: 100)
                    )
                }
                .stroke(.blue, lineWidth: 3)
                """, title: "Path.swift")
            }
        }
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(6)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(6) ? "Completed!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(6) ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(6) ? AnyShapeStyle(Color.green) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Star Shape

struct StarShape: Shape {
    let points: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let totalPoints = points * 2
        let angleIncrement = .pi * 2 / Double(totalPoints)

        var path = Path()
        for i in 0..<totalPoints {
            let angle = angleIncrement * Double(i) - .pi / 2
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Wave Shape

struct WaveShape: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midY = height / 2
        let amplitude = height * 0.3 * progress

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: midY))

        let steps = Int(width)
        for x in 0...steps {
            let relX = CGFloat(x) / width
            let sine = sin(relX * .pi * 4 + progress * .pi * 2)
            let y = midY + sine * amplitude
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    NavigationStack {
        Day6AnimationDrawingView()
    }
    .environment(AppViewModel())
}
