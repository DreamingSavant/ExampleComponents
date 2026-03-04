import SwiftUI

struct Day4ListsNavigationView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var searchText = ""
    @State private var showBasicList = true
    @State private var expandedSection = true
    @State private var multiSelection = Set<String>()
    @State private var demoItems = [
        DemoItem(name: "SwiftUI", icon: "swift", color: .orange),
        DemoItem(name: "UIKit", icon: "iphone", color: .blue),
        DemoItem(name: "AppKit", icon: "macwindow", color: .purple),
        DemoItem(name: "WatchKit", icon: "applewatch", color: .green),
        DemoItem(name: "WidgetKit", icon: "rectangle.3.group", color: .pink),
        DemoItem(name: "ARKit", icon: "arkit", color: .teal),
    ]

    @State private var scrollTarget: Int? = nil
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
            VStack(spacing: 28) {
                header
                listSection
                sectionAndDisclosure
                swipeActionsSection
                scrollViewSection
                tabViewSection
                searchableSection
                navigationSection
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
        ComponentShowcase(title: "TabView", description: "Page-style tabs and tab bars", color: lessonColor) {
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
