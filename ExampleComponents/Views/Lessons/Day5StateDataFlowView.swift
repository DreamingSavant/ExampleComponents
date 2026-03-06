import SwiftUI

struct Day5StateDataFlowView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var counter = 0
    @State private var sliderBound: Double = 0.5
    @State private var storedName = ""
    @State private var showEnvironmentDemo = false
    @AppStorage("dojo_saved_count") private var savedCount = 0

    private let lessonColor = DojoTheme.color(for: "lessonTeal")

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "@State: The Source of Truth",
                    explanation: "Every piece of mutable data in SwiftUI needs a clear owner. @State declares that THIS view owns and manages this value. When the value changes, SwiftUI automatically re-renders the view. This is the fundamental reactive pattern: state drives UI.",
                    whyItMatters: "Understanding @State is the foundation of SwiftUI thinking. Unlike UIKit where you manually update labels and images, in SwiftUI you change state and the UI updates itself. This mental shift is the biggest hurdle for UIKit developers.",
                    whenToUse: "Use @State for simple, view-local data: counters, toggle bools, text input, selected items. Always mark it private — if another view needs to write to it, use @Binding instead.",
                    color: lessonColor
                )
                stateSection
                TipBox(style: .mistake, content: "Common mistake: Making @State non-private. If a parent view passes a value to a child's @State, the child gets a copy — changes won't flow back to the parent. Use @Binding for two-way communication.")

                ConceptExplainer(
                    title: "@Binding: Shared Read-Write Access",
                    explanation: "@Binding creates a two-way connection to a @State owned by a parent view. The child can read AND write the value, and changes propagate back to the parent. You pass bindings using the $ prefix: $myValue.",
                    whyItMatters: "Binding is how SwiftUI achieves component reusability. A Slider, Toggle, or TextField all use @Binding to read/write state they don't own. Understanding this pattern is essential for building reusable components.",
                    whenToUse: "Use @Binding when a child view needs to modify a parent's state. Common pattern: parent owns @State, passes $state to child's @Binding.",
                    color: lessonColor
                )
                bindingSection
                TipBox(style: .tip, content: "The $ prefix creates a Binding from a @State. Think of @State as the storage and $state as the remote control. The child gets the remote but not the storage.")

                ConceptExplainer(
                    title: "@Observable: Modern Observation",
                    explanation: "@Observable (iOS 17+) replaces the older ObservableObject/@Published pattern. Mark a class with @Observable and all its stored properties are automatically tracked. SwiftUI only re-renders views that actually READ changed properties — much more efficient.",
                    whyItMatters: "For any non-trivial app, you'll have shared data models (user profile, settings, network state). @Observable is the modern way to share reference-type data across views with automatic, efficient updates.",
                    whenToUse: "Use for shared view models, app state, and data that multiple views need to access. Use with @State for view-owned instances, or .environment() for app-wide injection.",
                    color: lessonColor
                )
                observableSection
                TipBox(style: .info, content: "With @Observable, you don't need @Published anymore. Every stored property is automatically tracked. If a view reads .name but not .age, changing .age won't cause that view to re-render.")

                ConceptExplainer(
                    title: "@AppStorage: Simple Persistence",
                    explanation: "@AppStorage wraps UserDefaults, providing a property wrapper that automatically saves and loads values. It supports String, Int, Double, Bool, URL, and Data. Changes persist across app launches.",
                    whyItMatters: "Every app needs to persist user preferences (theme, onboarding state, settings). @AppStorage makes this trivially easy — one line replaces manual UserDefaults read/write code.",
                    whenToUse: "Use for small, simple preferences: theme choice, has-seen-onboarding, last-selected tab. NOT for large data (use SwiftData or files instead).",
                    color: lessonColor
                )
                appStorageSection
                TipBox(style: .warning, content: "Don't store arrays, complex objects, or sensitive data in @AppStorage. It's backed by UserDefaults (not encrypted, not efficient for large data). Use Keychain for passwords and SwiftData for structured data.")

                ConceptExplainer(
                    title: "@Environment: System & Custom Values",
                    explanation: "@Environment reads values from the SwiftUI environment — a built-in dependency injection system. System values include colorScheme, dynamicTypeSize, dismiss action, and more. You can also inject custom objects with .environment().",
                    whyItMatters: "Environment is how SwiftUI passes data down the view hierarchy without explicit parameter passing. It's the standard pattern for theme data, view models, and system state.",
                    whenToUse: "Use @Environment for system values (colorScheme, dismiss) and for injecting @Observable objects that multiple views need. Use .environment(myVM) to inject, @Environment(MyVM.self) to read.",
                    color: lessonColor
                )
                environmentSection

                ConceptExplainer(
                    title: "Lifecycle Modifiers",
                    explanation: "SwiftUI provides modifiers to hook into a view's lifecycle: .onAppear (view became visible), .onDisappear (view left), .onChange(of:) (react to value changes), and .task (async work tied to lifecycle with auto-cancellation).",
                    whyItMatters: "You need lifecycle hooks to load data, start/stop timers, track analytics, and respond to state changes. .task is especially important for async operations — it auto-cancels when the view disappears.",
                    whenToUse: ".onAppear for one-time setup. .task for async work (network calls). .onChange(of:) to react to specific value changes. .onDisappear for cleanup.",
                    color: lessonColor
                )
                lifecycleSection
                TipBox(style: .tip, content: "Prefer .task over .onAppear for async work. .task creates an async context and automatically cancels when the view disappears — preventing bugs from stale callbacks.")

                takeaways
                miniQuiz
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 5: State & Data")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Reactive UI Patterns")
                .font(.title2.bold())

            Text("How data flows through your SwiftUI app")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top)
    }

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 5,
            title: "Master SwiftUI's data flow patterns — the heart of reactive UI",
            objectives: [
                "Own view-local state with @State",
                "Share state between parent/child with @Binding",
                "Use @Observable for shared data models",
                "Persist data with @AppStorage and read system values with @Environment",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
    }

    // MARK: - @State

    private var stateSection: some View {
        ComponentShowcase(title: "@State", description: "View-owned mutable state", color: lessonColor) {
            VStack(spacing: 16) {
                Text("\(counter)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(lessonColor)
                    .contentTransition(.numericText())

                HStack(spacing: 16) {
                    Button { withAnimation { counter -= 1 } } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                    }

                    Button { withAnimation { counter = 0 } } label: {
                        Text("Reset")
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color(.systemGray5)))
                    }
                    .buttonStyle(.plain)

                    Button { withAnimation { counter += 1 } } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.green)
                    }
                }

                CodeSnippetView(code: """
                @State private var counter = 0
                
                Text("\\(counter)")
                Button("+") { counter += 1 }
                // SwiftUI re-renders when counter changes
                """, title: "State.swift")
            }
        }
    }

    // MARK: - @Binding

    private var bindingSection: some View {
        ComponentShowcase(title: "@Binding", description: "Two-way reference to parent's state", color: lessonColor) {
            VStack(spacing: 16) {
                BindingChildDemo(value: $sliderBound)

                RoundedRectangle(cornerRadius: 8)
                    .fill(lessonColor.opacity(sliderBound))
                    .frame(height: 40)
                    .overlay(
                        Text("Opacity: \(sliderBound, specifier: "%.2f")")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    )

                CodeSnippetView(code: """
                // Parent
                @State private var value = 0.5
                ChildView(value: $value)  // pass binding
                
                // Child
                struct ChildView: View {
                    @Binding var value: Double
                    // reads & writes parent's state
                }
                """, title: "Binding.swift")
            }
        }
    }

    // MARK: - @Observable

    private var observableSection: some View {
        ComponentShowcase(title: "@Observable", description: "Modern observation for reference types", color: lessonColor) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Replaces ObservableObject + @Published", systemImage: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.orange)

                    Label("Automatic property-level tracking", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)

                    Label("No @Published needed — all stored properties tracked", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)

                    Label("Use with @State for view ownership", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }

                CodeSnippetView(code: """
                @Observable
                class ViewModel {
                    var count = 0       // auto-tracked!
                    var name = ""       // auto-tracked!
                }
                
                struct MyView: View {
                    @State private var vm = ViewModel()
                    var body: some View {
                        Text("\\(vm.count)")
                        // Only re-renders when used props change
                    }
                }
                """, title: "Observable.swift")
            }
        }
    }

    // MARK: - @AppStorage

    private var appStorageSection: some View {
        ComponentShowcase(title: "@AppStorage", description: "Persist values in UserDefaults", color: lessonColor) {
            VStack(spacing: 16) {
                Text("Saved Count: \(savedCount)")
                    .font(.title2.bold())
                    .foregroundStyle(lessonColor)
                    .contentTransition(.numericText())

                HStack(spacing: 12) {
                    Button {
                        withAnimation { savedCount += 1 }
                    } label: {
                        Label("Increment", systemImage: "plus")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(lessonColor))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Button {
                        withAnimation { savedCount = 0 }
                    } label: {
                        Text("Reset")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color(.systemGray5)))
                    }
                    .buttonStyle(.plain)
                }

                Text("Close and reopen the app — this value persists!")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                CodeSnippetView(code: """
                @AppStorage("my_key") private var count = 0
                // Automatically saved to UserDefaults
                // Persists between app launches
                Button("Increment") { count += 1 }
                """, title: "AppStorage.swift")
            }
        }
    }

    // MARK: - @Environment

    private var environmentSection: some View {
        ComponentShowcase(title: "@Environment", description: "Read system and custom environment values", color: lessonColor) {
            VStack(spacing: 16) {
                EnvironmentDemoChild()

                CodeSnippetView(code: """
                @Environment(\\.colorScheme) var scheme
                @Environment(\\.dynamicTypeSize) var typeSize
                @Environment(\\.dismiss) var dismiss
                
                // Injecting custom @Observable objects
                .environment(myViewModel)
                // Reading: @Environment(MyVM.self) var vm
                """, title: "Environment.swift")
            }
        }
    }

    // MARK: - Lifecycle

    private var lifecycleSection: some View {
        ComponentShowcase(title: "Lifecycle Modifiers", description: "onAppear, onChange, task", color: lessonColor) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(".onAppear { } — runs when view appears", systemImage: "eye")
                        .font(.caption)
                    Label(".onDisappear { } — runs when view leaves", systemImage: "eye.slash")
                        .font(.caption)
                    Label(".onChange(of:) { } — react to value changes", systemImage: "arrow.triangle.2.circlepath")
                        .font(.caption)
                    Label(".task { } — async work tied to view lifecycle", systemImage: "clock.arrow.circlepath")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                CodeSnippetView(code: """
                Text("Hello")
                    .onAppear { print("Appeared!") }
                    .onChange(of: value) { old, new in
                        print("Changed: \\(old) → \\(new)")
                    }
                    .task {
                        data = await fetchData()
                    }
                """, title: "Lifecycle.swift")
            }
        }
    }

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "@State is the source of truth — the view owns and manages this data",
                "@Binding borrows state from a parent — it reads and writes without owning",
                "@Observable auto-tracks properties and only re-renders views that read changed values",
                "@AppStorage persists simple values across app launches via UserDefaults",
                "@Environment reads system values (colorScheme) and injected dependencies",
                ".task is preferred over .onAppear for async work — it auto-cancels on disappear",
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
                    question: "A child view needs to toggle a parent's Bool value. What should the child use?",
                    options: ["@State private var", "@Binding var", "@Observable", "@AppStorage"],
                    correctIndex: 1,
                    explanation: "The child needs to write to the parent's state, which requires @Binding. The parent passes its $state, and the child reads/writes through @Binding."
                ),
                MiniQuizQuestion(
                    question: "Your @Observable view model has 5 properties. A view reads only 2 of them. When do re-renders occur?",
                    options: ["When any of the 5 properties changes", "Only when either of the 2 read properties changes", "On every frame", "Never — @Observable doesn't trigger updates"],
                    correctIndex: 1,
                    explanation: "@Observable tracks which properties each view actually accesses. If your view only reads .name and .email, changes to .age, .avatar, or .settings won't cause a re-render."
                ),
                MiniQuizQuestion(
                    question: "When should you use .task { } instead of .onAppear { }?",
                    options: ["When you don't need async", "When you need async/await and want auto-cancellation on disappear", "When loading static data", "They're always interchangeable"],
                    correctIndex: 1,
                    explanation: ".task provides an async context and automatically cancels when the view disappears. This prevents bugs from callbacks arriving after navigation away."
                ),
            ],
            color: lessonColor
        )
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(5)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(5) ? "Completed!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(5) ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(5) ? AnyShapeStyle(Color.green) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helper Child Views

struct BindingChildDemo: View {
    @Binding var value: Double

    var body: some View {
        VStack(spacing: 4) {
            Text("Child View (has @Binding)")
                .font(.caption2.bold())
                .foregroundStyle(.teal)
            Slider(value: $value, in: 0...1)
                .tint(.teal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.teal.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.teal.opacity(0.2), lineWidth: 1))
        )
    }
}

struct EnvironmentDemoChild: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")", systemImage: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                .font(.caption)
            Label("Dynamic Type: \(String(describing: typeSize))", systemImage: "textformat.size")
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
    }
}

#Preview {
    NavigationStack {
        Day5StateDataFlowView()
    }
    .environment(AppViewModel())
}
