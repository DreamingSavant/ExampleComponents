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
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "Explicit Animation: withAnimation",
                    explanation: "withAnimation wraps a state change so that SwiftUI animates all view properties affected by that change. You control the animation curve (spring, easeIn, linear) and duration. This is 'explicit' because YOU decide when to animate.",
                    whyItMatters: "Animation is what separates a flat, static app from a polished, professional one. Explicit animation gives you precise control over what animates and when.",
                    whenToUse: "Use withAnimation when you change state in response to user actions (button taps, gestures). You wrap the state change, not the view. SwiftUI figures out what changed and animates it.",
                    color: lessonColor
                )
                explicitAnimationSection
                TipBox(style: .tip, content: "Spring animations feel more natural than linear ones. Use .spring(response:dampingFraction:) — lower damping = more bounce. Most Apple apps use spring animations.")

                ConceptExplainer(
                    title: "Implicit Animation: .animation()",
                    explanation: ".animation(_:value:) attaches an animation to a specific value. Whenever that value changes — regardless of how — the view animates. This is 'implicit' because the animation is always active, watching for changes.",
                    whyItMatters: "Implicit animations are great for views that should always animate when a value changes (like a progress bar or rotating icon). You set it once and it works automatically.",
                    whenToUse: "Use .animation(value:) for values that should always animate when they change. Use withAnimation for one-time state changes you want to control explicitly.",
                    color: lessonColor
                )
                implicitAnimationSection
                TipBox(style: .mistake, content: "Common mistake: Using .animation() without the value: parameter. The old version without value: is deprecated and can cause unexpected animations. Always specify which value to watch.")

                ConceptExplainer(
                    title: "Transitions: Enter & Exit Animations",
                    explanation: "Transitions define how views animate when they appear or disappear from the view hierarchy (if/else, ForEach). Built-in transitions include .opacity, .slide, .scale, .move(edge:). Use .asymmetric for different enter/exit animations.",
                    whyItMatters: "Without transitions, views pop in/out instantly, which feels jarring. Transitions add polish by smoothly introducing and removing views.",
                    whenToUse: "Apply .transition() to views inside if/else blocks or conditional rendering. The parent must have an animation (via withAnimation or .animation) for transitions to work.",
                    color: lessonColor
                )
                transitionsSection
                TipBox(style: .warning, content: "Transitions only work when the view is added/removed from the hierarchy (if/else). Changing opacity to 0 is NOT a transition — the view is still in the hierarchy. Use conditional rendering for transitions.")

                ConceptExplainer(
                    title: "matchedGeometryEffect: Hero Animations",
                    explanation: "matchedGeometryEffect creates smooth 'hero' transitions between two views that share the same ID and @Namespace. SwiftUI interpolates the size and position, creating the illusion of one view morphing into another.",
                    whyItMatters: "Hero animations are the signature of polished apps (App Store cards, photo zoom). They provide visual continuity during navigation, helping users understand spatial relationships.",
                    whenToUse: "Use for expand/collapse transitions, card-to-detail animations, and any case where two views represent the same conceptual item at different sizes or positions.",
                    color: lessonColor
                )
                matchedGeometrySection

                ConceptExplainer(
                    title: "Shapes & Custom Drawing",
                    explanation: "SwiftUI provides built-in shapes (Circle, Rectangle, Capsule, Ellipse, RoundedRectangle) and the Shape protocol for custom shapes. Shapes conform to View so you can use them directly. Custom shapes implement path(in:) to define geometry.",
                    whyItMatters: "Shapes are used everywhere: avatars (Circle clipShape), cards (RoundedRectangle), progress indicators, and custom UI elements. Understanding Shape lets you create any visual element.",
                    whenToUse: "Use built-in shapes for standard UI elements. Create custom shapes (Shape protocol) for unique graphics like stars, waves, or custom progress rings.",
                    color: lessonColor
                )
                shapesSection
                customShapeSection

                ConceptExplainer(
                    title: "Path: Freeform Vector Drawing",
                    explanation: "Path lets you draw arbitrary vector graphics using move, line, curve, and arc commands — similar to SVG path data. For animated shapes, implement animatableData to tell SwiftUI which values to interpolate.",
                    whyItMatters: "Path gives you unlimited creative freedom for custom graphics, charts, wave animations, and decorative elements that no built-in view can provide.",
                    whenToUse: "Use for custom progress indicators, chart lines, wave effects, and any graphic that requires freeform vector drawing. For simple shapes, prefer built-in ones.",
                    color: lessonColor
                )
                pathDrawingSection
                TipBox(style: .info, content: "To animate a custom shape smoothly, implement animatableData. Without it, SwiftUI can't interpolate between states and the shape will jump instantly.")

                takeaways
                miniQuiz
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

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 6,
            title: "Add animation and custom graphics to make your app feel alive",
            objectives: [
                "Use withAnimation for explicit, controlled animations",
                "Understand implicit animations with .animation(value:)",
                "Create enter/exit transitions and hero animations",
                "Draw custom shapes with the Shape protocol and Path",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
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
                        var path = Path()
                        // Calculate star vertices using trig
                        // Alternate between outer/inner radius
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

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "withAnimation wraps state changes for explicit control; .animation(value:) watches values implicitly",
                "Spring animations feel the most natural — use them as your default",
                "Transitions require conditional rendering (if/else) to trigger enter/exit animations",
                "matchedGeometryEffect morphs between views sharing an ID + @Namespace",
                "Custom shapes implement path(in:) — add animatableData for smooth animation",
                "Path gives unlimited drawing freedom but use built-in shapes when they suffice",
            ],
            color: lessonColor
        )
    }

    // MARK: - Mini Quiz

    private var miniQuiz: some View {
        MiniQuizView(
            title: "Check Your Understanding",
            questions: [
                MiniQuizQuestion(
                    question: "You want a button tap to smoothly move a circle from left to right. What's the best approach?",
                    options: [".animation() on the circle", "withAnimation { offset.toggle() } in the button action", "Timer to update position", "UIView.animate"],
                    correctIndex: 1,
                    explanation: "withAnimation wraps the state change (toggling the offset) so SwiftUI animates the circle's movement. This is explicit animation — you choose when it happens."
                ),
                MiniQuizQuestion(
                    question: "Why doesn't a transition work when you change a view's opacity to 0?",
                    options: ["Opacity can't be animated", "The view is still in the hierarchy — transitions need if/else to add/remove views", "You need .animation()", "Transitions only work on shapes"],
                    correctIndex: 1,
                    explanation: "Transitions trigger when views enter/leave the view tree. Changing opacity to 0 hides the view but keeps it in the hierarchy. Use if/else for transitions."
                ),
                MiniQuizQuestion(
                    question: "What do you need for matchedGeometryEffect to work?",
                    options: ["Just a shared ID", "A shared ID and @Namespace", "A NavigationLink", "UIKit interop"],
                    correctIndex: 1,
                    explanation: "matchedGeometryEffect requires both a shared ID string and a @Namespace declared with the property wrapper. Both views reference the same ID within the same namespace."
                ),
            ],
            color: lessonColor
        )
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
