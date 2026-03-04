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
            VStack(spacing: 28) {
                header
                stateSection
                bindingSection
                observableSection
                appStorageSection
                environmentSection
                lifecycleSection
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

                VStack(alignment: .leading, spacing: 4) {
                    Text("Key points:")
                        .font(.caption.bold())
                    Text("  - @State is the source of truth")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("  - Only the owning view can write to it")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("  - Changes trigger automatic re-render")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

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

                VStack(alignment: .leading, spacing: 4) {
                    Text("Key points:")
                        .font(.caption.bold())
                    Text("  - @Binding reads & writes parent's @State")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("  - Passed with $ prefix: $myValue")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("  - Creates two-way data flow")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

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

                Text("This value persists across app launches!")
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
                // Reading system environment values
                @Environment(\\.colorScheme) var scheme
                @Environment(\\.dynamicTypeSize) var typeSize
                @Environment(\\.dismiss) var dismiss
                
                // Injecting custom objects
                .environment(myViewModel)
                // Then: @Environment(MyVM.self) var vm
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
                        // async work, auto-cancelled
                        data = await fetchData()
                    }
                """, title: "Lifecycle.swift")
            }
        }
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
