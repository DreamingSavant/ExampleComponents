import SwiftUI

struct ReferenceView: View {
    @Environment(AppViewModel.self) private var appVM
    @State private var searchText = ""
    @State private var selectedCategory: ReferenceCategory = .views

    enum ReferenceCategory: String, CaseIterable {
        case views = "Views"
        case layout = "Layout"
        case controls = "Controls"
        case data = "Data Flow"
        case modifiers = "Modifiers"
        case patterns = "Patterns"

        var icon: String {
            switch self {
            case .views: return "text.justify.leading"
            case .layout: return "square.grid.3x3"
            case .controls: return "slider.horizontal.3"
            case .data: return "arrow.triangle.2.circlepath"
            case .modifiers: return "paintbrush"
            case .patterns: return "puzzlepiece.extension"
            }
        }

        var color: Color {
            switch self {
            case .views: return .purple
            case .layout: return .blue
            case .controls: return .green
            case .data: return .teal
            case .modifiers: return .orange
            case .patterns: return .pink
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    categoryPicker
                    referenceCards
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(DojoTheme.surfaceBackground)
            .navigationTitle("Reference")
            .searchable(text: $searchText, prompt: "Search concepts...")
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "text.book.closed.fill")
                .font(.largeTitle)
                .foregroundStyle(DojoTheme.heroGradient)

            Text("SwiftUI Cheat Sheet")
                .font(.title2.bold())

            Text("Quick reference for every concept")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ReferenceCategory.allCases, id: \.self) { category in
                    Button {
                        withAnimation(.snappy) { selectedCategory = category }
                    } label: {
                        Label(category.rawValue, systemImage: category.icon)
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(selectedCategory == category ? category.color : Color(.systemGray5))
                            )
                            .foregroundStyle(selectedCategory == category ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var referenceCards: some View {
        VStack(spacing: 12) {
            ForEach(filteredEntries, id: \.title) { entry in
                ReferenceEntryCard(entry: entry)
            }

            if filteredEntries.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No matching concepts")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            }
        }
    }

    private var filteredEntries: [ReferenceEntry] {
        let entries = ReferenceEntry.entries(for: selectedCategory)
        if searchText.isEmpty { return entries }
        return entries.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.summary.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Reference Entry

struct ReferenceEntry {
    let title: String
    let summary: String
    let code: String
    let day: Int
    let color: Color

    static func entries(for category: ReferenceView.ReferenceCategory) -> [ReferenceEntry] {
        switch category {
        case .views: return viewEntries
        case .layout: return layoutEntries
        case .controls: return controlEntries
        case .data: return dataEntries
        case .modifiers: return modifierEntries
        case .patterns: return patternEntries
        }
    }

    static let viewEntries: [ReferenceEntry] = [
        ReferenceEntry(title: "Text", summary: "Display styled text content. Chain modifiers for font, color, alignment.", code: "Text(\"Hello\")\n    .font(.title.bold())\n    .foregroundStyle(.blue)", day: 1, color: .purple),
        ReferenceEntry(title: "Image (SF Symbol)", summary: "Display vector icons from Apple's 6,000+ symbol library.", code: "Image(systemName: \"star.fill\")\n    .font(.title)\n    .foregroundStyle(.yellow)", day: 1, color: .purple),
        ReferenceEntry(title: "Label", summary: "Icon + text that adapts to context (toolbar shows icon only, list shows both).", code: "Label(\"Favorites\", systemImage: \"heart.fill\")", day: 1, color: .purple),
        ReferenceEntry(title: "Color & Gradient", summary: "Solid colors adapt to dark mode. Gradients add visual depth.", code: "LinearGradient(\n    colors: [.blue, .purple],\n    startPoint: .top,\n    endPoint: .bottom\n)", day: 1, color: .purple),
    ]

    static let layoutEntries: [ReferenceEntry] = [
        ReferenceEntry(title: "VStack / HStack / ZStack", summary: "Vertical, horizontal, and depth-layered containers. Nest for any layout.", code: "VStack(spacing: 12) {\n    Text(\"Top\")\n    Text(\"Bottom\")\n}", day: 2, color: .blue),
        ReferenceEntry(title: "Spacer", summary: "Expands to fill available space, pushing siblings apart.", code: "HStack {\n    Text(\"Left\")\n    Spacer()\n    Text(\"Right\")\n}", day: 2, color: .blue),
        ReferenceEntry(title: ".frame()", summary: "Set size constraints. maxWidth: .infinity for full-width.", code: "Text(\"Wide\")\n    .frame(maxWidth: .infinity,\n           alignment: .leading)", day: 2, color: .blue),
        ReferenceEntry(title: ".padding()", summary: "Add breathing room around content. Specify edges and amount.", code: "Text(\"Padded\")\n    .padding(.horizontal, 16)\n    .padding(.vertical, 12)", day: 2, color: .blue),
        ReferenceEntry(title: "LazyVGrid", summary: "Grid layout with flexible/fixed/adaptive columns. Lazy = performant.", code: "LazyVGrid(columns: [\n    GridItem(.flexible()),\n    GridItem(.flexible())\n]) { ... }", day: 2, color: .blue),
        ReferenceEntry(title: "GeometryReader", summary: "Access container size for proportional layouts. Use sparingly.", code: "GeometryReader { geo in\n    Color.blue\n        .frame(width: geo.size.width * 0.5)\n}", day: 2, color: .blue),
    ]

    static let controlEntries: [ReferenceEntry] = [
        ReferenceEntry(title: "Button", summary: "Tappable action trigger. Styles: plain, bordered, borderedProminent.", code: "Button(\"Save\") { save() }\n    .buttonStyle(.borderedProminent)", day: 3, color: .green),
        ReferenceEntry(title: "Toggle", summary: "Boolean on/off switch. Requires Binding<Bool>.", code: "Toggle(\"Notifications\",\n       isOn: $isEnabled)", day: 3, color: .green),
        ReferenceEntry(title: "Slider", summary: "Continuous value in a range. Add step: for discrete values.", code: "Slider(value: $volume,\n       in: 0...100, step: 1)", day: 3, color: .green),
        ReferenceEntry(title: "Picker", summary: "Select from options. Styles: segmented, menu, wheel, inline.", code: "Picker(\"Size\", selection: $size) {\n    ForEach(sizes, id: \\.self) {\n        Text($0)\n    }\n}\n.pickerStyle(.segmented)", day: 3, color: .green),
        ReferenceEntry(title: "TextField / SecureField", summary: "Single-line text input. SecureField hides input for passwords.", code: "TextField(\"Email\", text: $email)\n    .textFieldStyle(.roundedBorder)", day: 3, color: .green),
        ReferenceEntry(title: "TextEditor", summary: "Multi-line text input for longer content like notes or comments.", code: "TextEditor(text: $notes)\n    .frame(height: 100)", day: 3, color: .green),
        ReferenceEntry(title: "Menu", summary: "Contextual action popup. Supports sub-menus and destructive roles.", code: "Menu(\"Options\") {\n    Button(\"Copy\") { }\n    Button(\"Delete\",\n           role: .destructive) { }\n}", day: 3, color: .green),
    ]

    static let dataEntries: [ReferenceEntry] = [
        ReferenceEntry(title: "@State", summary: "View-owned mutable state. Always private. Changes trigger re-render.", code: "@State private var count = 0\n\nText(\"\\(count)\")\nButton(\"+\") { count += 1 }", day: 5, color: .teal),
        ReferenceEntry(title: "@Binding", summary: "Two-way reference to parent's @State. Passed with $ prefix.", code: "// Parent passes: $value\nstruct Child: View {\n    @Binding var value: Bool\n}", day: 5, color: .teal),
        ReferenceEntry(title: "@Observable", summary: "Modern observation macro. Auto-tracks all stored properties. Property-level updates.", code: "@Observable\nclass ViewModel {\n    var name = \"\"  // auto-tracked\n}", day: 5, color: .teal),
        ReferenceEntry(title: "@AppStorage", summary: "Persists simple values in UserDefaults across app launches.", code: "@AppStorage(\"theme\")\nprivate var isDark = false", day: 5, color: .teal),
        ReferenceEntry(title: "@Environment", summary: "Read system values (colorScheme, dismiss) or injected objects.", code: "@Environment(\\.colorScheme)\nvar scheme\n@Environment(MyVM.self) var vm", day: 5, color: .teal),
        ReferenceEntry(title: ".task / .onAppear", summary: ".task for async work with auto-cancel. .onAppear for sync setup.", code: "Text(\"Hi\")\n    .task {\n        data = await fetch()\n    }", day: 5, color: .teal),
    ]

    static let modifierEntries: [ReferenceEntry] = [
        ReferenceEntry(title: ".foregroundStyle()", summary: "Set text/icon color. Supports gradients and any ShapeStyle.", code: "Text(\"Gradient\")\n    .foregroundStyle(\n        LinearGradient(...))", day: 1, color: .orange),
        ReferenceEntry(title: ".background()", summary: "Place content behind the view. Respects the view's frame.", code: "Text(\"Card\")\n    .padding()\n    .background(\n        RoundedRectangle(cornerRadius: 12)\n            .fill(.blue.opacity(0.1)))", day: 7, color: .orange),
        ReferenceEntry(title: ".overlay()", summary: "Place content in front of the view, positioned by alignment.", code: "Image(\"photo\")\n    .overlay(alignment: .topTrailing) {\n        Badge()\n    }", day: 7, color: .orange),
        ReferenceEntry(title: ".clipShape()", summary: "Mask view to any Shape. Content outside is hidden.", code: "Image(\"avatar\")\n    .clipShape(Circle())", day: 7, color: .orange),
        ReferenceEntry(title: "ViewModifier", summary: "Package reusable modifier chains. Apply via .modifier() or extension.", code: "struct CardStyle: ViewModifier {\n    func body(content: Content)\n        -> some View {\n        content\n            .padding()\n            .background(.ultraThinMaterial)\n            .cornerRadius(12)\n    }\n}", day: 7, color: .orange),
        ReferenceEntry(title: ".animation(value:)", summary: "Implicit animation: animates whenever the watched value changes.", code: "Circle()\n    .offset(x: offset)\n    .animation(.spring, value: offset)", day: 6, color: .orange),
    ]

    static let patternEntries: [ReferenceEntry] = [
        ReferenceEntry(title: "NavigationStack", summary: "Value-based navigation. Push data, define destinations by type.", code: "NavigationStack {\n    List(items) { item in\n        NavigationLink(value: item) {\n            Text(item.name)\n        }\n    }\n    .navigationDestination(\n        for: Item.self) { DetailView(item: $0) }\n}", day: 4, color: .pink),
        ReferenceEntry(title: "Sheet / FullScreenCover", summary: "Modal presentation. Sheet = card with drag dismiss. FullScreen = immersive.", code: ".sheet(isPresented: $show) {\n    MyView()\n        .presentationDetents(\n            [.medium, .large])\n}", day: 7, color: .pink),
        ReferenceEntry(title: "Alert / ConfirmationDialog", summary: "System dialogs for messages and action choices.", code: ".alert(\"Title\",\n       isPresented: $show) {\n    Button(\"OK\") { }\n} message: {\n    Text(\"Body\")\n}", day: 7, color: .pink),
        ReferenceEntry(title: "List with Features", summary: "Data rows with swipe delete, reorder, sections, and search.", code: "List {\n    ForEach(items) { item in\n        Text(item.name)\n    }\n    .onDelete { ... }\n    .onMove { ... }\n}\n.searchable(text: $search)", day: 4, color: .pink),
        ReferenceEntry(title: "withAnimation", summary: "Explicit animation: wrap state changes to animate affected views.", code: "withAnimation(.spring) {\n    isExpanded.toggle()\n}", day: 6, color: .pink),
        ReferenceEntry(title: "matchedGeometryEffect", summary: "Hero transition between views sharing an ID and @Namespace.", code: "@Namespace var ns\n\nRoundedRectangle()\n    .matchedGeometryEffect(\n        id: \"hero\", in: ns)", day: 6, color: .pink),
    ]
}

// MARK: - Reference Entry Card

struct ReferenceEntryCard: View {
    let entry: ReferenceEntry
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.snappy) { isExpanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.title)
                            .font(.headline)
                            .foregroundStyle(entry.color)
                        Text(entry.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    HStack(spacing: 6) {
                        Text("Day \(entry.day)")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(entry.color.opacity(0.15)))
                            .foregroundStyle(entry.color)

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                CodeSnippetView(code: entry.code, title: "\(entry.title).swift")
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(entry.color.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(entry.color.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ReferenceView()
        .environment(AppViewModel())
}
