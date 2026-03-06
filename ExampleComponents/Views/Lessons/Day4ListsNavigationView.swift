import SwiftUI

struct Day4ListsNavigationView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var searchText = ""
    @State private var expandedSection = true
    @State private var demoItems = [
        DemoItem(name: "SwiftUI", icon: "swift", color: .orange),
        DemoItem(name: "UIKit", icon: "iphone", color: .blue),
        DemoItem(name: "AppKit", icon: "macwindow", color: .purple),
        DemoItem(name: "WatchKit", icon: "applewatch", color: .green),
        DemoItem(name: "WidgetKit", icon: "rectangle.3.group", color: .pink),
        DemoItem(name: "ARKit", icon: "arkit", color: .teal),
    ]
    @State private var tabSelection = 0

    private let lessonColor = DojoTheme.color(for: "lessonOrange")

    struct DemoItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "List: SwiftUI's Data Workhorse",
                    explanation: "List is the standard way to display scrollable rows of data. It provides built-in features for free: cell reuse (performance), swipe actions, edit mode (delete/reorder), selection, and section headers. Under the hood, it's backed by UITableView on iOS.",
                    whyItMatters: "Most apps have at least one List screen (settings, messages, contacts). List gives you professional-quality behavior without manual implementation. Understanding when to use List vs ScrollView is a key architectural decision.",
                    whenToUse: "Use List for data-driven rows where you want built-in features (swipe, edit, select). Use ScrollView + LazyVStack for custom layouts that don't need List's features.",
                    color: lessonColor
                )
                listSection
                TipBox(style: .tip, content: "Use .listStyle(.plain) for edge-to-edge rows, .insetGrouped for the iOS Settings look, and .sidebar for iPad navigation columns.")

                ConceptExplainer(
                    title: "Section & DisclosureGroup",
                    explanation: "Section groups rows under headers/footers within a List. DisclosureGroup creates collapsible sections that expand/collapse on tap. Both help organize complex data into digestible groups.",
                    whyItMatters: "Good information architecture separates great apps from mediocre ones. Sections and disclosure groups let you organize dense content (like settings screens) into scannable groups.",
                    whenToUse: "Use Section in Lists for grouped headers. Use DisclosureGroup for collapsible content, FAQ sections, and expandable details.",
                    color: lessonColor
                )
                sectionAndDisclosure

                ConceptExplainer(
                    title: "Swipe Actions",
                    explanation: "Swipe actions add custom buttons that appear when the user swipes a row. You can add actions on both leading and trailing edges. This is the standard iOS pattern for quick actions like delete, flag, or archive.",
                    whyItMatters: "Swipe actions are an expected iOS interaction pattern. Users intuitively swipe to delete in Mail, Messages, and most apps. Not supporting this makes your app feel incomplete.",
                    whenToUse: "Use on List rows for quick actions (delete, flag, archive). .onDelete on ForEach is the simpler API for delete-only. .swipeActions gives full control.",
                    color: lessonColor
                )
                swipeActionsSection

                ConceptExplainer(
                    title: "ScrollView",
                    explanation: "ScrollView creates a scrollable region. Unlike List, it doesn't provide cell reuse or built-in features — you get full control over layout. Use LazyVStack or LazyHStack inside for performance with large datasets.",
                    whyItMatters: "ScrollView is the foundation for custom scrollable layouts. Combined with Lazy stacks, it handles any scrollable UI that doesn't fit the List model (horizontal carousels, custom cards, mixed content).",
                    whenToUse: "Use ScrollView for custom scrollable layouts, horizontal carousels, and pages. Pair with LazyVStack/LazyHStack for performance with many items.",
                    color: lessonColor
                )
                scrollViewSection
                TipBox(style: .warning, content: "Always use LazyVStack (not VStack) inside ScrollView for long lists. VStack creates ALL views immediately; LazyVStack only creates visible ones. This matters for performance with 100+ items.")

                ConceptExplainer(
                    title: "TabView (Page Style)",
                    explanation: "TabView with .tabViewStyle(.page) creates swipeable pages — like an onboarding flow or image carousel. Each child becomes a page. The page indicator dots appear automatically.",
                    whyItMatters: "Page-style TabViews are the standard pattern for onboarding screens, image galleries, and tutorial walkthroughs. It's built-in and requires minimal code.",
                    whenToUse: "Use for onboarding flows, image carousels, and any swipeable page content. For the app's main tab bar, use TabView with Tab items instead.",
                    color: lessonColor
                )
                tabViewSection

                ConceptExplainer(
                    title: "NavigationStack: Modern Navigation",
                    explanation: "NavigationStack (iOS 16+) replaces the deprecated NavigationView. It uses value-based, type-safe navigation with .navigationDestination(for:). This means you push data values, not views, making navigation programmatically controllable.",
                    whyItMatters: "Type-safe navigation prevents crashes and enables deep linking. With NavigationPath, you can programmatically push/pop screens, save/restore navigation state, and handle universal links.",
                    whenToUse: "Use NavigationStack for any drill-down navigation (master-detail). Always prefer it over NavigationView (deprecated). Use NavigationSplitView for sidebar-based iPad layouts.",
                    color: lessonColor
                )
                searchableSection
                navigationSection
                TipBox(style: .mistake, content: "Common mistake: Still using NavigationView. It's deprecated since iOS 16. NavigationStack offers value-based navigation, programmatic control, and better performance.")

                takeaways
                miniQuiz
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 4: Lists & Nav")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "list.bullet.rectangle.fill")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Scroll, Navigate & Organize")
                .font(.title2.bold())

            Text("Display collections and navigate between views")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 4,
            title: "Build data-driven screens with lists, scroll views, and navigation",
            objectives: [
                "Display data with List and its built-in features",
                "Organize content with Section and DisclosureGroup",
                "Add swipe actions and search to lists",
                "Navigate with NavigationStack and value-based routing",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
    }

    // MARK: - List

    private var listSection: some View {
        ComponentShowcase(title: "List", description: "The workhorse of data display", color: lessonColor) {
            VStack(spacing: 12) {
                List {
                    ForEach(filteredItems) { item in
                        HStack(spacing: 12) {
                            Image(systemName: item.icon)
                                .font(.title3)
                                .foregroundStyle(item.color)
                                .frame(width: 30)
                            Text(item.name)
                                .font(.body)
                        }
                    }
                    .onDelete { offsets in
                        demoItems.remove(atOffsets: offsets)
                    }
                    .onMove { from, to in
                        demoItems.move(fromOffsets: from, toOffset: to)
                    }
                }
                .listStyle(.insetGrouped)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                CodeSnippetView(code: """
                List {
                    ForEach(items) { item in
                        HStack {
                            Image(systemName: item.icon)
                            Text(item.name)
                        }
                    }
                    .onDelete { offsets in
                        items.remove(atOffsets: offsets)
                    }
                    .onMove { from, to in
                        items.move(fromOffsets: from, toOffset: to)
                    }
                }
                .listStyle(.insetGrouped)
                """, title: "List.swift")
            }
        }
    }

    private var filteredItems: [DemoItem] {
        if searchText.isEmpty { return demoItems }
        return demoItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - Section & DisclosureGroup

    private var sectionAndDisclosure: some View {
        ComponentShowcase(title: "Section & DisclosureGroup", description: "Organize content into collapsible groups", color: lessonColor) {
            VStack(spacing: 12) {
                DisclosureGroup("Frameworks", isExpanded: $expandedSection) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("SwiftUI", systemImage: "swift")
                        Label("Combine", systemImage: "arrow.triangle.2.circlepath")
                        Label("SwiftData", systemImage: "cylinder.split.1x2")
                    }
                    .padding(.top, 4)
                }
                .tint(lessonColor)

                DisclosureGroup("Tools") {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Xcode", systemImage: "hammer.fill")
                        Label("Instruments", systemImage: "gauge.with.dots.needle.33percent")
                        Label("Simulator", systemImage: "iphone")
                    }
                    .padding(.top, 4)
                }
                .tint(lessonColor)

                CodeSnippetView(code: """
                DisclosureGroup("Title",
                    isExpanded: $expanded) {
                    Label("Item", systemImage: "star")
                }
                """, title: "DisclosureGroup.swift")
            }
        }
    }

    // MARK: - Swipe Actions

    private var swipeActionsSection: some View {
        ComponentShowcase(title: "Swipe Actions", description: "Custom swipe gestures on rows", color: lessonColor) {
            VStack(spacing: 12) {
                List {
                    ForEach(["Inbox", "Archive", "Sent"], id: \.self) { item in
                        Text(item)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {} label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {} label: {
                                    Label("Flag", systemImage: "flag")
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .leading) {
                                Button {} label: {
                                    Label("Pin", systemImage: "pin")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .listStyle(.insetGrouped)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                CodeSnippetView(code: """
                Text("Inbox")
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) { }
                            label: { Label("Delete",
                                systemImage: "trash") }
                    }
                    .swipeActions(edge: .leading) {
                        Button { } label: {
                            Label("Pin", systemImage: "pin")
                        }.tint(.blue)
                    }
                """, title: "SwipeActions.swift")
            }
        }
    }

    // MARK: - ScrollView

    private var scrollViewSection: some View {
        ComponentShowcase(title: "ScrollView", description: "Horizontal and vertical scrolling", color: lessonColor) {
            VStack(spacing: 12) {
                Text("Horizontal Scroll")
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<10, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill([Color.blue, .green, .orange, .purple, .pink][i % 5].gradient)
                                .frame(width: 100, height: 80)
                                .overlay(
                                    Text("Card \(i + 1)")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                    .padding(.vertical, 2)
                }

                CodeSnippetView(code: """
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<10, id: \\.self) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 100, height: 80)
                        }
                    }
                }
                """, title: "ScrollView.swift")
            }
        }
    }

    // MARK: - TabView

    private var tabViewSection: some View {
        ComponentShowcase(title: "TabView (Page Style)", description: "Swipeable pages", color: lessonColor) {
            VStack(spacing: 12) {
                TabView(selection: $tabSelection) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue.gradient)
                        .overlay(
                            VStack {
                                Image(systemName: "1.circle.fill").font(.largeTitle)
                                Text("Page One").font(.headline)
                            }.foregroundStyle(.white)
                        )
                        .tag(0)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(.green.gradient)
                        .overlay(
                            VStack {
                                Image(systemName: "2.circle.fill").font(.largeTitle)
                                Text("Page Two").font(.headline)
                            }.foregroundStyle(.white)
                        )
                        .tag(1)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(.orange.gradient)
                        .overlay(
                            VStack {
                                Image(systemName: "3.circle.fill").font(.largeTitle)
                                Text("Page Three").font(.headline)
                            }.foregroundStyle(.white)
                        )
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                CodeSnippetView(code: """
                TabView {
                    Text("Page 1").tag(0)
                    Text("Page 2").tag(1)
                }
                .tabViewStyle(.page)
                """, title: "TabView.swift")
            }
        }
    }

    // MARK: - Searchable

    private var searchableSection: some View {
        ComponentShowcase(title: ".searchable", description: "Built-in search bar integration", color: lessonColor) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search frameworks...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))

                if !searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(filteredItems) { item in
                            Label(item.name, systemImage: item.icon)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                CodeSnippetView(code: """
                NavigationStack {
                    List { ... }
                    .searchable(text: $searchText)
                }
                """, title: "Searchable.swift")
            }
        }
    }

    // MARK: - NavigationStack

    private var navigationSection: some View {
        ComponentShowcase(title: "NavigationStack", description: "Value-based, type-safe navigation", color: lessonColor) {
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Type-safe with .navigationDestination(for:)", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                    Label("Supports deep linking via NavigationPath", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                    Label("Replaces NavigationView (deprecated)", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }

                CodeSnippetView(code: """
                NavigationStack {
                    List(items) { item in
                        NavigationLink(value: item) {
                            Text(item.name)
                        }
                    }
                    .navigationDestination(for: Item.self) {
                        DetailView(item: $0)
                    }
                    .navigationTitle("Items")
                }
                """, title: "NavigationStack.swift")
            }
        }
    }

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "List provides swipe, delete, reorder, and selection for free — use it for data rows",
                "ScrollView + LazyVStack for custom layouts that don't need List features",
                "Section and DisclosureGroup organize complex data into scannable groups",
                "NavigationStack with .navigationDestination is the modern, type-safe navigation pattern",
                ".searchable() adds a native search bar — no custom TextField needed",
                "Always use LazyVStack inside ScrollView for performance with many items",
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
                    question: "You're building a settings screen with grouped rows. Which should you use?",
                    options: ["ScrollView + VStack", "List with .insetGrouped style", "LazyVGrid", "TabView"],
                    correctIndex: 1,
                    explanation: "List with .insetGrouped style gives you the standard iOS Settings appearance with grouped sections, automatic styling, and built-in features."
                ),
                MiniQuizQuestion(
                    question: "Why is NavigationStack preferred over NavigationView?",
                    options: ["It's faster", "It supports value-based, type-safe navigation with programmatic control", "It has more animations", "NavigationView still works fine"],
                    correctIndex: 1,
                    explanation: "NavigationStack uses value types for routing, supports NavigationPath for programmatic control, and enables deep linking. NavigationView is deprecated."
                ),
                MiniQuizQuestion(
                    question: "What's the performance difference between VStack and LazyVStack inside a ScrollView?",
                    options: ["No difference", "VStack creates all views upfront; LazyVStack only creates visible ones", "LazyVStack is slower", "VStack doesn't work in ScrollView"],
                    correctIndex: 1,
                    explanation: "LazyVStack defers view creation until they're about to appear on screen. With 1000+ items, this prevents huge memory usage and slow initial load."
                ),
            ],
            color: lessonColor
        )
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(4)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(4) ? "Completed!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(4) ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(4) ? AnyShapeStyle(Color.green) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        Day4ListsNavigationView()
    }
    .environment(AppViewModel())
}
