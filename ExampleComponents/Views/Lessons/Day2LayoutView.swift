import SwiftUI

struct Day2LayoutView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var stackType: StackType = .vstack
    @State private var spacing: CGFloat = 10
    @State private var alignment: Int = 1
    @State private var showSpacer = false
    @State private var gridColumns = 3
    @State private var useGeometryReader = false

    private let lessonColor = DojoTheme.color(for: "lessonBlue")

    enum StackType: String, CaseIterable {
        case vstack = "VStack"
        case hstack = "HStack"
        case zstack = "ZStack"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "The Stack Layout Model",
                    explanation: "SwiftUI uses three primary containers to arrange views: VStack (vertical), HStack (horizontal), and ZStack (depth/layering). Unlike CSS flexbox or auto layout, SwiftUI stacks are simple and composable — you nest them to create any layout.",
                    whyItMatters: "Every screen you build is a combination of stacks. Understanding how they distribute space and align children is the single most important layout skill in SwiftUI.",
                    whenToUse: "VStack for top-to-bottom flow (forms, lists). HStack for side-by-side items (toolbars, stats). ZStack for overlapping content (badges on images, custom cards).",
                    color: lessonColor
                )
                stacksPlayground
                TipBox(style: .tip, content: "Stacks only hold 10 direct children. For more, wrap groups of views in Group { } or break them into smaller sub-views.")

                ConceptExplainer(
                    title: "Spacer & Padding",
                    explanation: "Spacer is a flexible view that expands to fill available space — it pushes sibling views apart. Padding adds breathing room around a view's content. Together, they control whitespace, which is critical for readable, professional layouts.",
                    whyItMatters: "Good whitespace separates amateur UIs from professional ones. Spacer gives you alignment control, while padding gives you breathing room. Master both for clean layouts.",
                    whenToUse: "Use Spacer to push views to edges or create proportional gaps. Use .padding() to add consistent insets around content.",
                    color: lessonColor
                )
                spacerAndPadding
                TipBox(style: .warning, content: "Spacer() is greedy — it takes ALL available space. If you put two Spacers in a stack, they split the space equally. Use Spacer(minLength:) to set a minimum gap.")

                ConceptExplainer(
                    title: "Frame & Alignment",
                    explanation: "The .frame() modifier sets size constraints on a view. Use fixed values (.frame(width: 100)) for exact sizes, or maxWidth/maxHeight for flexible sizing. The alignment parameter controls where content sits within the frame.",
                    whyItMatters: "Understanding frame is key to controlling view sizes. The common pattern .frame(maxWidth: .infinity) makes a view expand to fill its container — essential for full-width buttons and cards.",
                    whenToUse: "Use fixed frames for icons and badges. Use maxWidth: .infinity for full-width elements. Combine with alignment for precise positioning.",
                    color: lessonColor
                )
                frameAndAlignment

                ConceptExplainer(
                    title: "GeometryReader",
                    explanation: "GeometryReader gives you the exact size and position of its container through a GeometryProxy. This lets you create proportional layouts (e.g., '30% of parent width'). However, it changes layout behavior — it always expands to fill available space.",
                    whyItMatters: "Sometimes you need to know a container's size to create responsive layouts. GeometryReader is the tool for this, but it should be used sparingly.",
                    whenToUse: "Use for proportional sizing, reading scroll positions, or container-relative positioning. Avoid when standard layout tools (stacks, padding, frame) can achieve the same result.",
                    color: lessonColor
                )
                geometryReaderSection
                TipBox(style: .mistake, content: "Common mistake: Using GeometryReader when .frame(maxWidth: .infinity) would suffice. GeometryReader is greedy and changes layout behavior. Try simpler tools first.")

                ConceptExplainer(
                    title: "LazyVGrid",
                    explanation: "LazyVGrid creates grid layouts using column definitions (GridItem). 'Lazy' means it only creates views that are currently visible — important for performance with large datasets. You define columns as .flexible(), .fixed(width), or .adaptive(minimum:).",
                    whyItMatters: "Grids are essential for photo galleries, icon grids, dashboards, and any collection display. The lazy loading means you can have thousands of items without memory issues.",
                    whenToUse: "Use for collections displayed in grid form. Use .flexible() columns for equal-width cells, .adaptive(minimum:) for automatic column count based on available width.",
                    color: lessonColor
                )
                gridSection
                TipBox(style: .tip, content: "Use GridItem(.adaptive(minimum: 80)) to let SwiftUI automatically determine the number of columns based on screen width — perfect for responsive layouts on iPhone and iPad.")

                takeaways
                miniQuiz
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 2: Layout")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.grid.3x3.fill")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Stacks, Grids & Spacing")
                .font(.title2.bold())

            Text("How SwiftUI arranges views in space")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top)
    }

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 2,
            title: "Master SwiftUI's layout system to build any screen",
            objectives: [
                "Arrange views with VStack, HStack, and ZStack",
                "Control whitespace with Spacer and padding",
                "Set view sizes with frame and alignment",
                "Build responsive grids with LazyVGrid",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
    }

    // MARK: - Stacks Playground

    private var stacksPlayground: some View {
        ComponentShowcase(title: "Stacks", description: "VStack, HStack, ZStack — the layout trinity", color: lessonColor) {
            VStack(spacing: 16) {
                Picker("Stack Type", selection: $stackType) {
                    ForEach(StackType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Spacing: \(Int(spacing))")
                        .font(.caption)
                    Slider(value: $spacing, in: 0...30, step: 2)
                        .tint(lessonColor)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 200)

                    stackPreview
                        .animation(.snappy, value: stackType)
                        .animation(.snappy, value: spacing)
                }

                CodeSnippetView(code: """
                \(stackType.rawValue)(spacing: \(Int(spacing))) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                        .frame(width: 50, height: 50)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.green)
                        .frame(width: 50, height: 50)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.orange)
                        .frame(width: 50, height: 50)
                }
                """, title: "Stacks.swift")
            }
        }
    }

    @ViewBuilder
    private var stackPreview: some View {
        let shapes = Group {
            RoundedRectangle(cornerRadius: 8).fill(.blue).frame(width: 50, height: 50)
            RoundedRectangle(cornerRadius: 8).fill(.green).frame(width: 50, height: 50)
            RoundedRectangle(cornerRadius: 8).fill(.orange).frame(width: 50, height: 50)
        }

        switch stackType {
        case .vstack:
            VStack(spacing: spacing) { shapes }
        case .hstack:
            HStack(spacing: spacing) { shapes }
        case .zstack:
            ZStack { shapes }
        }
    }

    // MARK: - Spacer & Padding

    private var spacerAndPadding: some View {
        ComponentShowcase(title: "Spacer & Padding", description: "Control whitespace and breathing room", color: lessonColor) {
            VStack(spacing: 16) {
                Toggle("Show Spacer", isOn: $showSpacer.animation(.snappy))
                    .font(.caption)

                HStack {
                    Circle().fill(.blue).frame(width: 30, height: 30)
                    if showSpacer { Spacer() }
                    Circle().fill(.green).frame(width: 30, height: 30)
                    if showSpacer { Spacer() }
                    Circle().fill(.orange).frame(width: 30, height: 30)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

                VStack(alignment: .leading, spacing: 4) {
                    Text(".padding() — all sides")
                        .font(.caption).foregroundStyle(.secondary)
                    Text(".padding(.horizontal) — left & right")
                        .font(.caption).foregroundStyle(.secondary)
                    Text(".padding(.top, 20) — specific side & value")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                CodeSnippetView(code: """
                HStack {
                    Circle().fill(.blue)
                    \(showSpacer ? "Spacer()" : "// No spacer")
                    Circle().fill(.green)
                    \(showSpacer ? "Spacer()" : "")
                    Circle().fill(.orange)
                }
                .padding()
                """, title: "Spacer.swift")
            }
        }
    }

    // MARK: - Frame & Alignment

    private var frameAndAlignment: some View {
        ComponentShowcase(title: "Frame & Alignment", description: "Control size and positioning", color: lessonColor) {
            VStack(spacing: 16) {
                Picker("Alignment", selection: $alignment) {
                    Text("Leading").tag(0)
                    Text("Center").tag(1)
                    Text("Trailing").tag(2)
                }
                .pickerStyle(.segmented)

                let currentAlignment: Alignment = [.leading, .center, .trailing][alignment]

                RoundedRectangle(cornerRadius: 8)
                    .fill(lessonColor)
                    .frame(width: 80, height: 40)
                    .frame(maxWidth: .infinity, alignment: currentAlignment)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    .animation(.snappy, value: alignment)

                CodeSnippetView(code: """
                Text("Hello")
                    .frame(maxWidth: .infinity,
                           alignment: .\(["leading", "center", "trailing"][alignment]))
                """, title: "Frame.swift")
            }
        }
    }

    // MARK: - GeometryReader

    private var geometryReaderSection: some View {
        ComponentShowcase(title: "GeometryReader", description: "Access parent container dimensions", color: lessonColor) {
            VStack(spacing: 16) {
                Toggle("Use GeometryReader", isOn: $useGeometryReader.animation(.snappy))
                    .font(.caption)

                if useGeometryReader {
                    GeometryReader { geo in
                        HStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.blue)
                                .frame(width: geo.size.width * 0.3)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.green)
                                .frame(width: geo.size.width * 0.5)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.orange)
                        }
                        .overlay(
                            Text("Width: \(Int(geo.size.width))pt")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                        )
                    }
                    .frame(height: 50)
                } else {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 6).fill(.blue).frame(height: 50)
                        RoundedRectangle(cornerRadius: 6).fill(.green).frame(height: 50)
                        RoundedRectangle(cornerRadius: 6).fill(.orange).frame(height: 50)
                    }
                }

                CodeSnippetView(code: """
                GeometryReader { geo in
                    HStack {
                        Color.blue
                            .frame(width: geo.size.width * 0.3)
                        Color.green
                            .frame(width: geo.size.width * 0.5)
                        Color.orange
                    }
                }
                """, title: "GeometryReader.swift")
            }
        }
    }

    // MARK: - Grid

    private var gridSection: some View {
        ComponentShowcase(title: "LazyVGrid", description: "Flexible grid layouts with columns", color: lessonColor) {
            VStack(spacing: 16) {
                Stepper("Columns: \(gridColumns)", value: $gridColumns, in: 2...5)
                    .font(.caption)

                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: gridColumns)

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<9, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                [Color.red, .orange, .yellow, .green, .teal, .blue, .indigo, .purple, .pink][index]
                                    .opacity(0.7)
                            )
                            .frame(height: 50)
                            .overlay(Text("\(index + 1)").font(.caption.bold()).foregroundStyle(.white))
                    }
                }
                .animation(.snappy, value: gridColumns)

                CodeSnippetView(code: """
                let columns = Array(
                    repeating: GridItem(.flexible()),
                    count: \(gridColumns)
                )
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<9, id: \\.self) { i in
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 50)
                    }
                }
                """, title: "LazyVGrid.swift")
            }
        }
    }

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "VStack = vertical, HStack = horizontal, ZStack = layered — nest them for any layout",
                "Spacer expands to fill available space — use it to push views apart",
                ".padding() adds breathing room; .frame() sets size constraints",
                ".frame(maxWidth: .infinity) is the pattern for full-width elements",
                "GeometryReader is powerful but greedy — prefer simpler layout tools when possible",
                "LazyVGrid with GridItem columns creates performant, responsive grids",
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
                    question: "You want three buttons in a row. Which stack should you use?",
                    options: ["VStack", "HStack", "ZStack", "LazyVGrid"],
                    correctIndex: 1,
                    explanation: "HStack arranges children horizontally in a row. VStack is for vertical stacking, ZStack for layering."
                ),
                MiniQuizQuestion(
                    question: "What happens if you put a single Spacer() between two Text views in an HStack?",
                    options: ["Nothing visible changes", "The texts are pushed to opposite edges", "The spacer has fixed 8pt width", "It crashes"],
                    correctIndex: 1,
                    explanation: "Spacer expands to fill all available space, pushing the two Text views to the leading and trailing edges of the HStack."
                ),
                MiniQuizQuestion(
                    question: "When is GeometryReader the WRONG choice?",
                    options: ["When you need proportional widths", "When .frame(maxWidth: .infinity) would work just as well", "When reading scroll position", "When adapting to container size"],
                    correctIndex: 1,
                    explanation: "GeometryReader is overkill for simple full-width layouts. Use .frame(maxWidth: .infinity) instead — it's simpler and doesn't change layout behavior."
                ),
            ],
            color: lessonColor
        )
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(2)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(2) ? "Completed!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(2) ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(2) ? AnyShapeStyle(Color.green) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        Day2LayoutView()
    }
    .environment(AppViewModel())
}
