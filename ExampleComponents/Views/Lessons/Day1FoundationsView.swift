import SwiftUI

struct Day1FoundationsView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var fontSize: CGFloat = 24
    @State private var fontWeight: Font.Weight = .regular
    @State private var textColor: Color = .primary
    @State private var showGradient = false
    @State private var selectedSymbol = "star.fill"
    @State private var symbolSize: CGFloat = 40
    @State private var symbolColor: Color = .blue
    @State private var renderingMode: SymbolRenderingMode = .monochrome

    private let sampleSymbols = [
        "star.fill", "heart.fill", "bolt.fill", "flame.fill",
        "leaf.fill", "drop.fill", "moon.fill", "sun.max.fill",
        "cloud.rain.fill", "snowflake", "sparkles", "wand.and.stars",
    ]

    private let lessonColor = DojoTheme.color(for: "lessonPurple")

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "Understanding Text",
                    explanation: "Text is the most fundamental view in SwiftUI. Unlike UILabel in UIKit, it's a lightweight value type — every modifier you chain returns a new modified copy. This makes Text composable and predictable.",
                    whyItMatters: "Every app displays text. Mastering Text and its modifiers is the foundation for all SwiftUI styling. The patterns you learn here (chaining modifiers) apply to every SwiftUI view.",
                    whenToUse: "Use Text for any static or dynamic text. For user input, use TextField or TextEditor instead.",
                    color: lessonColor
                )
                textSection
                TipBox(style: .mistake, content: "Don't use .foregroundColor() — it's deprecated in iOS 17. Always use .foregroundStyle(), which supports colors, gradients, and any ShapeStyle.")

                ConceptExplainer(
                    title: "The Font System",
                    explanation: "SwiftUI provides semantic font styles (.title, .body, .caption) that automatically scale with the user's Dynamic Type settings. This means your app is accessible by default — if a user increases their text size in Settings, your text responds.",
                    whyItMatters: "Hardcoding font sizes breaks accessibility. Semantic fonts ensure your app works for everyone, from low-vision users to those who prefer compact text.",
                    whenToUse: "Always prefer semantic fonts (.title, .body, .caption) over .system(size:). Use fixed sizes only for decorative elements that shouldn't scale.",
                    color: lessonColor
                )
                fontShowcase
                TipBox(style: .tip, content: "You can combine semantic fonts with weight: Text(\"Hello\").font(.title.bold()). This preserves Dynamic Type scaling while customizing weight.")

                ConceptExplainer(
                    title: "SF Symbols & Images",
                    explanation: "SF Symbols is Apple's library of 6,000+ vector icons designed to work seamlessly with San Francisco (the system font). They scale with Dynamic Type, support multiple rendering modes, and look native on all Apple platforms.",
                    whyItMatters: "Using SF Symbols instead of custom images means your icons automatically match the system style, support accessibility, and don't require image assets.",
                    whenToUse: "Use SF Symbols for standard UI icons (settings, search, heart, etc.). Use custom Image assets for brand-specific graphics or photos.",
                    color: lessonColor
                )
                imageAndSymbolsSection
                TipBox(style: .info, content: "Download the SF Symbols app from Apple to browse all available symbols, test rendering modes, and find the perfect icon for your UI.")

                ConceptExplainer(
                    title: "Label = Icon + Text (Smart)",
                    explanation: "Label combines an icon and text into a single semantic component. The key advantage over HStack { Image; Text } is that Label adapts its layout to context — in a toolbar it might show only the icon, in a list it shows both.",
                    whyItMatters: "Using Label instead of manually combining Image and Text gives SwiftUI the freedom to optimize the presentation for each context, improving consistency and accessibility.",
                    whenToUse: "Use Label whenever you have an icon paired with descriptive text. Use it in List rows, toolbar items, and buttons.",
                    color: lessonColor
                )
                labelsSection

                ConceptExplainer(
                    title: "Colors & Gradients",
                    explanation: "SwiftUI's Color type adapts to light and dark mode automatically when you use system colors (.primary, .secondary) or asset catalog colors. Gradients (Linear, Radial, Angular) add visual richness and can be applied anywhere a ShapeStyle is expected.",
                    whyItMatters: "Understanding the color system helps you build apps that look great in both light and dark mode without extra work. Gradients are essential for modern, polished UI design.",
                    whenToUse: "Use system colors for text and backgrounds (automatic dark mode). Use gradients on backgrounds, buttons, and decorative elements for visual polish.",
                    color: lessonColor
                )
                colorsAndGradientsSection
                TipBox(style: .warning, content: "Avoid hardcoding Color(.white) or Color(.black) for text backgrounds — they won't adapt to dark mode. Use Color(.systemBackground) and .primary instead.")

                takeaways
                miniQuiz
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 1: Foundations")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "paintbrush.fill")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Text, Images & Colors")
                .font(.title2.bold())

            Text("The building blocks of every SwiftUI interface")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    // MARK: - Objective

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 1,
            title: "Build a solid foundation with SwiftUI's core display views",
            objectives: [
                "Style and customize Text with modifiers",
                "Use SF Symbols and understand rendering modes",
                "Create Labels that adapt to context",
                "Apply colors and gradients to any view",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
    }

    // MARK: - Text Section

    private var textSection: some View {
        ComponentShowcase(title: "Text", description: "Display and style text content", color: lessonColor) {
            VStack(spacing: 16) {
                Text("Hello, SwiftUI!")
                    .font(.system(size: fontSize, weight: fontWeight))
                    .foregroundStyle(showGradient ? AnyShapeStyle(DojoTheme.heroGradient) : AnyShapeStyle(textColor))
                    .animation(.snappy, value: fontSize)
                    .animation(.snappy, value: showGradient)

                VStack(spacing: 10) {
                    HStack {
                        Text("Font Size: \(Int(fontSize))pt")
                            .font(.caption)
                        Spacer()
                    }
                    Slider(value: $fontSize, in: 12...48, step: 1)
                        .tint(lessonColor)

                    HStack(spacing: 8) {
                        ForEach(
                            [(Font.Weight.light, "Light"), (.regular, "Regular"), (.bold, "Bold"), (.black, "Black")],
                            id: \.1
                        ) { weight, label in
                            Button(label) {
                                withAnimation { fontWeight = weight }
                            }
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(fontWeight == weight ? lessonColor : Color(.systemGray5)))
                            .foregroundStyle(fontWeight == weight ? .white : .primary)
                        }
                    }

                    Toggle("Gradient Text", isOn: $showGradient)
                        .font(.caption)
                }

                CodeSnippetView(code: """
                Text("Hello, SwiftUI!")
                    .font(.system(size: \(Int(fontSize)),
                          weight: .\(weightName)))
                    .foregroundStyle(\(showGradient ? "gradient" : ".\(colorName)"))
                """, title: "Text.swift")
            }
        }
    }

    private var weightName: String {
        switch fontWeight {
        case .light: return "light"
        case .bold: return "bold"
        case .black: return "black"
        default: return "regular"
        }
    }

    private var colorName: String {
        textColor == .primary ? "primary" : "blue"
    }

    // MARK: - Font Showcase

    private var fontShowcase: some View {
        ComponentShowcase(title: "Font Styles", description: "SwiftUI's built-in typography scale", color: lessonColor) {
            VStack(alignment: .leading, spacing: 8) {
                Group {
                    Text(".largeTitle").font(.largeTitle)
                    Text(".title").font(.title)
                    Text(".title2").font(.title2)
                    Text(".title3").font(.title3)
                    Text(".headline").font(.headline)
                    Text(".body").font(.body)
                    Text(".callout").font(.callout)
                    Text(".subheadline").font(.subheadline)
                    Text(".footnote").font(.footnote)
                    Text(".caption").font(.caption)
                }
                .foregroundStyle(lessonColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - SF Symbols

    private var imageAndSymbolsSection: some View {
        ComponentShowcase(title: "SF Symbols & Images", description: "6,000+ built-in vector icons", color: lessonColor) {
            VStack(spacing: 16) {
                Image(systemName: selectedSymbol)
                    .font(.system(size: symbolSize))
                    .symbolRenderingMode(renderingMode)
                    .foregroundStyle(symbolColor)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(height: 70)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(sampleSymbols, id: \.self) { symbol in
                            Button {
                                withAnimation { selectedSymbol = symbol }
                            } label: {
                                Image(systemName: symbol)
                                    .font(.title2)
                                    .foregroundStyle(selectedSymbol == symbol ? lessonColor : .secondary)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(selectedSymbol == symbol ? lessonColor.opacity(0.12) : Color(.systemGray6))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                HStack {
                    Text("Size: \(Int(symbolSize))")
                        .font(.caption)
                    Slider(value: $symbolSize, in: 16...80, step: 2)
                        .tint(lessonColor)
                }

                ColorPicker("Symbol Color", selection: $symbolColor)
                    .font(.caption)

                CodeSnippetView(code: """
                Image(systemName: "\(selectedSymbol)")
                    .font(.system(size: \(Int(symbolSize))))
                    .foregroundStyle(.\(symbolColorName))
                """, title: "SFSymbol.swift")
            }
        }
    }

    private var symbolColorName: String {
        symbolColor == .blue ? "blue" : "custom"
    }

    // MARK: - Labels

    private var labelsSection: some View {
        ComponentShowcase(title: "Label", description: "Text + Icon combined component", color: lessonColor) {
            VStack(spacing: 12) {
                Label("Favorites", systemImage: "heart.fill")
                    .font(.title3)

                Label("Settings", systemImage: "gear")
                    .font(.title3)
                    .labelStyle(.titleAndIcon)

                Label("Downloads", systemImage: "arrow.down.circle.fill")
                    .font(.title3)
                    .foregroundStyle(lessonColor)

                CodeSnippetView(code: """
                Label("Favorites", systemImage: "heart.fill")
                Label("Settings", systemImage: "gear")
                    .labelStyle(.titleAndIcon)
                """, title: "Label.swift")
            }
        }
    }

    // MARK: - Colors & Gradients

    private var colorsAndGradientsSection: some View {
        ComponentShowcase(title: "Colors & Gradients", description: "Solid colors and gradient fills", color: lessonColor) {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    ForEach([Color.red, .orange, .yellow, .green, .blue, .purple, .pink], id: \.self) { color in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(height: 40)
                    }
                }

                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [.purple, .blue, .teal], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 50)
                    .overlay(Text("LinearGradient").font(.caption.bold()).foregroundStyle(.white))

                RoundedRectangle(cornerRadius: 12)
                    .fill(RadialGradient(colors: [.yellow, .orange, .red], center: .center, startRadius: 5, endRadius: 80))
                    .frame(height: 50)
                    .overlay(Text("RadialGradient").font(.caption.bold()).foregroundStyle(.white))

                RoundedRectangle(cornerRadius: 12)
                    .fill(AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center))
                    .frame(height: 50)
                    .overlay(Text("AngularGradient").font(.caption.bold()).foregroundStyle(.white))

                CodeSnippetView(code: """
                LinearGradient(
                    colors: [.purple, .blue, .teal],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                """, title: "Gradients.swift")
            }
        }
    }

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "Text is your most-used view — chain modifiers to customize it",
                "Use semantic font styles (.title, .body) for automatic accessibility",
                "SF Symbols give you 6,000+ free icons that scale with text",
                "Label adapts its layout to context — smarter than HStack { Image; Text }",
                "Use .foregroundStyle() (not deprecated .foregroundColor()) for colors and gradients",
                "Define custom colors in asset catalogs for automatic dark mode support",
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
                    question: "Why should you prefer .font(.title) over .font(.system(size: 28))?",
                    options: [".title looks better", ".title adapts to Dynamic Type accessibility settings", ".title is faster to render", "No real difference"],
                    correctIndex: 1,
                    explanation: "Semantic fonts like .title automatically scale with the user's Dynamic Type preference, making your app accessible. Fixed sizes don't scale."
                ),
                MiniQuizQuestion(
                    question: "What advantage does Label have over HStack { Image(systemName:); Text() }?",
                    options: ["Label is smaller code", "Label adapts its presentation to context (toolbars show icon only, lists show both)", "Label is animated", "Label supports more icons"],
                    correctIndex: 1,
                    explanation: "Label is a semantic component — SwiftUI can decide the best presentation based on context. In a compact toolbar, it may hide the text. HStack always renders everything."
                ),
                MiniQuizQuestion(
                    question: "Which gradient type creates a circular color spread from a center point?",
                    options: ["LinearGradient", "AngularGradient", "RadialGradient", "ConicalGradient"],
                    correctIndex: 2,
                    explanation: "RadialGradient radiates colors outward from a center point. LinearGradient goes in a direction. AngularGradient sweeps around a center like a conic section."
                ),
            ],
            color: lessonColor
        )
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(1)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(1) ? "Completed!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(1) ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(1) ? AnyShapeStyle(Color.green) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        Day1FoundationsView()
    }
    .environment(AppViewModel())
}
