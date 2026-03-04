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
            VStack(spacing: 28) {
                header
                textSection
                fontShowcase
                imageAndSymbolsSection
                labelsSection
                colorsAndGradientsSection
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
                    .fill(
                        LinearGradient(colors: [.purple, .blue, .teal], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(height: 50)
                    .overlay(Text("LinearGradient").font(.caption.bold()).foregroundStyle(.white))

                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        RadialGradient(colors: [.yellow, .orange, .red], center: .center, startRadius: 5, endRadius: 80)
                    )
                    .frame(height: 50)
                    .overlay(Text("RadialGradient").font(.caption.bold()).foregroundStyle(.white))

                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center)
                    )
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
