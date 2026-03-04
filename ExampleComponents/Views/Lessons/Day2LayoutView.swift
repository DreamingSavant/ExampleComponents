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
            VStack(spacing: 28) {
                header
                stacksPlayground
                spacerAndPadding
                frameAndAlignment
                geometryReaderSection
                gridSection
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
