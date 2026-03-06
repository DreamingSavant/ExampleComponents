import SwiftUI

struct Day3ControlsView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var toggleValue = true
    @State private var sliderValue: Double = 50
    @State private var stepperValue = 3
    @State private var pickerSelection = 0
    @State private var dateValue = Date()
    @State private var colorValue: Color = .blue
    @State private var textFieldValue = ""
    @State private var textEditorValue = "Type here..."
    @State private var secureFieldValue = ""
    @State private var buttonTapCount = 0
    @State private var selectedFruit = "Apple"

    private let lessonColor = DojoTheme.color(for: "lessonGreen")
    private let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "Buttons: The Primary Action Control",
                    explanation: "Button is how users trigger actions. SwiftUI provides several built-in styles (plain, bordered, borderedProminent) and lets you build fully custom buttons. Buttons can have roles (.destructive, .cancel) that affect their styling.",
                    whyItMatters: "Every app needs buttons. Understanding button styles, custom labels, and roles ensures your actions look and feel right. A prominent button draws the eye; a destructive button warns the user.",
                    whenToUse: "Use .borderedProminent for primary actions, .bordered for secondary, plain for custom-styled buttons, and role: .destructive for dangerous actions.",
                    color: lessonColor
                )
                buttonSection
                TipBox(style: .tip, content: "For a fully custom button, use .buttonStyle(.plain) and build your own label. This removes all default styling, giving you complete control.")

                ConceptExplainer(
                    title: "State-Driven Controls",
                    explanation: "Toggle, Slider, Stepper, and Picker are all state-driven — they require a binding to a piece of state. When the user interacts, the control updates the state, and SwiftUI automatically re-renders any views that depend on it.",
                    whyItMatters: "This is the core SwiftUI pattern: UI reflects state. There's no 'get the value from the control' — the value IS the state. Understanding this pattern is fundamental to thinking in SwiftUI.",
                    whenToUse: "Toggle for boolean on/off. Slider for continuous ranges. Stepper for discrete increments. Picker for selection from a fixed set of options.",
                    color: lessonColor
                )
                toggleSection
                sliderSection
                stepperSection
                TipBox(style: .info, content: "All these controls use the same pattern: @State + $binding. The $ prefix creates a two-way connection between the control and your state variable.")

                ConceptExplainer(
                    title: "Pickers: Selection Controls",
                    explanation: "Picker lets users choose from a set of options. The key is the pickerStyle modifier — .segmented shows all options inline, .menu hides them in a dropdown, .wheel shows a scroll wheel. The right style depends on the number of options and context.",
                    whyItMatters: "Choosing the right picker style improves UX. Segmented works for 2-5 options. Menu works for many options. DatePicker and ColorPicker are specialized pickers for specific data types.",
                    whenToUse: "Use Picker for selection from a list. DatePicker for dates/times. ColorPicker for colors. Choose the style based on the number of options and available space.",
                    color: lessonColor
                )
                pickerSection
                datePickerSection
                colorPickerSection

                ConceptExplainer(
                    title: "Text Input Controls",
                    explanation: "SwiftUI provides three text input controls: TextField for single-line input, SecureField for passwords (text is hidden), and TextEditor for multi-line text. All bind to a String state variable.",
                    whyItMatters: "User input is fundamental. Knowing which control to use and how to style them (textFieldStyle, keyboard type, submit actions) ensures a smooth input experience.",
                    whenToUse: "TextField for names, emails, short input. SecureField for passwords. TextEditor for notes, comments, long-form text.",
                    color: lessonColor
                )
                textInputSection
                TipBox(style: .mistake, content: "Common mistake: Using TextEditor when TextField suffices. TextEditor doesn't support placeholder text natively and takes up more space. Use TextField for single-line input.")

                ConceptExplainer(
                    title: "Menu: Contextual Actions",
                    explanation: "Menu creates a popup menu with action buttons, dividers, and even nested sub-menus. Unlike Picker (which selects a value), Menu triggers actions.",
                    whyItMatters: "Menus are the standard way to offer contextual actions without cluttering the UI. They support destructive roles, sub-menus, and dividers.",
                    whenToUse: "Use Menu when you have multiple actions related to an item (Copy, Share, Delete). Use Picker when the user is choosing a value, not triggering an action.",
                    color: lessonColor
                )
                menuSection

                takeaways
                miniQuiz
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 3: Controls")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "slider.horizontal.3")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Buttons, Toggles & Inputs")
                .font(.title2.bold())

            Text("Interactive controls that drive your app")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top)
    }

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 3,
            title: "Master every interactive control SwiftUI offers",
            objectives: [
                "Build buttons with different styles and custom labels",
                "Use Toggle, Slider, and Stepper for state-driven input",
                "Choose the right Picker style for each situation",
                "Handle text input with TextField, SecureField, and TextEditor",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
    }

    // MARK: - Button

    private var buttonSection: some View {
        ComponentShowcase(title: "Button", description: "Tappable interactive controls", color: lessonColor) {
            VStack(spacing: 12) {
                Text("Tapped: \(buttonTapCount) times")
                    .font(.headline)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: buttonTapCount)

                HStack(spacing: 12) {
                    Button("Default") { buttonTapCount += 1 }
                    Button("Bordered") { buttonTapCount += 1 }
                        .buttonStyle(.bordered)
                    Button("Prominent") { buttonTapCount += 1 }
                        .buttonStyle(.borderedProminent)
                    Button(role: .destructive) { buttonTapCount += 1 } label: {
                        Text("Delete")
                    }
                    .buttonStyle(.bordered)
                }

                Button { buttonTapCount += 1 } label: {
                    Label("Custom Button", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(lessonColor))
                }
                .buttonStyle(.plain)

                CodeSnippetView(code: """
                Button("Prominent") { action() }
                    .buttonStyle(.borderedProminent)
                
                Button { action() } label: {
                    Label("Custom", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(.green))
                }
                """, title: "Button.swift")
            }
        }
    }

    // MARK: - Toggle

    private var toggleSection: some View {
        ComponentShowcase(title: "Toggle", description: "On/off switch for boolean values", color: lessonColor) {
            VStack(spacing: 12) {
                Toggle("Notifications", isOn: $toggleValue)
                Toggle("Dark Mode", isOn: .constant(false))
                    .tint(.purple)
                Toggle("Airplane Mode", isOn: $toggleValue)
                    .toggleStyle(.button)

                CodeSnippetView(code: """
                @State private var isOn = true
                
                Toggle("Notifications", isOn: $isOn)
                Toggle("Styled", isOn: $isOn)
                    .tint(.purple)
                """, title: "Toggle.swift")
            }
        }
    }

    // MARK: - Slider

    private var sliderSection: some View {
        ComponentShowcase(title: "Slider", description: "Continuous value selection", color: lessonColor) {
            VStack(spacing: 12) {
                Text("Value: \(Int(sliderValue))")
                    .font(.title2.bold())
                    .foregroundStyle(lessonColor)
                    .contentTransition(.numericText())

                Slider(value: $sliderValue, in: 0...100, step: 1) {
                    Text("Volume")
                } minimumValueLabel: {
                    Image(systemName: "speaker.fill")
                } maximumValueLabel: {
                    Image(systemName: "speaker.wave.3.fill")
                }
                .tint(lessonColor)

                RoundedRectangle(cornerRadius: 8)
                    .fill(lessonColor.opacity(sliderValue / 100))
                    .frame(height: 30)
                    .animation(.snappy, value: sliderValue)

                CodeSnippetView(code: """
                @State private var value: Double = 50
                
                Slider(value: $value, in: 0...100) {
                    Text("Volume")
                } minimumValueLabel: {
                    Image(systemName: "speaker.fill")
                } maximumValueLabel: {
                    Image(systemName: "speaker.wave.3.fill")
                }
                """, title: "Slider.swift")
            }
        }
    }

    // MARK: - Stepper

    private var stepperSection: some View {
        ComponentShowcase(title: "Stepper", description: "Increment/decrement integer values", color: lessonColor) {
            VStack(spacing: 12) {
                HStack {
                    ForEach(0..<stepperValue, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                .animation(.snappy, value: stepperValue)

                Stepper("Rating: \(stepperValue)", value: $stepperValue, in: 1...5)

                CodeSnippetView(code: """
                @State private var count = 3
                Stepper("Rating: \\(count)",
                        value: $count, in: 1...5)
                """, title: "Stepper.swift")
            }
        }
    }

    // MARK: - Picker

    private var pickerSection: some View {
        ComponentShowcase(title: "Picker", description: "Select from predefined options", color: lessonColor) {
            VStack(spacing: 12) {
                Picker("Fruit", selection: $selectedFruit) {
                    ForEach(fruits, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)

                Picker("Favorite Fruit", selection: $selectedFruit) {
                    ForEach(fruits, id: \.self) { Text($0) }
                }
                .pickerStyle(.menu)

                Text("Selected: \(selectedFruit)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                CodeSnippetView(code: """
                Picker("Fruit", selection: $selected) {
                    ForEach(fruits, id: \\.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                // Also: .menu, .wheel, .inline
                """, title: "Picker.swift")
            }
        }
    }

    // MARK: - DatePicker

    private var datePickerSection: some View {
        ComponentShowcase(title: "DatePicker", description: "Select dates and times", color: lessonColor) {
            VStack(spacing: 12) {
                DatePicker("Event Date", selection: $dateValue, displayedComponents: [.date])
                DatePicker("Time", selection: $dateValue, displayedComponents: [.hourAndMinute])

                CodeSnippetView(code: """
                @State private var date = Date()
                DatePicker("Event", selection: $date,
                           displayedComponents: [.date])
                """, title: "DatePicker.swift")
            }
        }
    }

    // MARK: - ColorPicker

    private var colorPickerSection: some View {
        ComponentShowcase(title: "ColorPicker", description: "Let users choose any color", color: lessonColor) {
            VStack(spacing: 12) {
                ColorPicker("Pick a Color", selection: $colorValue)

                RoundedRectangle(cornerRadius: 12)
                    .fill(colorValue)
                    .frame(height: 50)

                CodeSnippetView(code: """
                @State private var color: Color = .blue
                ColorPicker("Pick", selection: $color)
                """, title: "ColorPicker.swift")
            }
        }
    }

    // MARK: - Text Input

    private var textInputSection: some View {
        ComponentShowcase(title: "Text Input", description: "TextField, TextEditor, SecureField", color: lessonColor) {
            VStack(spacing: 12) {
                TextField("Enter your name", text: $textFieldValue)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $secureFieldValue)
                    .textFieldStyle(.roundedBorder)

                TextEditor(text: $textEditorValue)
                    .frame(height: 80)
                    .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color(.systemGray4), lineWidth: 1))

                CodeSnippetView(code: """
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $pw)
                TextEditor(text: $notes)
                """, title: "TextInput.swift")
            }
        }
    }

    // MARK: - Menu

    private var menuSection: some View {
        ComponentShowcase(title: "Menu", description: "Contextual action menus", color: lessonColor) {
            VStack(spacing: 12) {
                Menu("Options") {
                    Button("Copy", action: {})
                    Button("Paste", action: {})
                    Divider()
                    Button(role: .destructive) {} label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Menu("Share") {
                        Button("Messages", action: {})
                        Button("Email", action: {})
                    }
                }
                .buttonStyle(.borderedProminent)

                CodeSnippetView(code: """
                Menu("Options") {
                    Button("Copy", action: {})
                    Button("Paste", action: {})
                    Divider()
                    Menu("Share") {
                        Button("Messages", action: {})
                    }
                }
                """, title: "Menu.swift")
            }
        }
    }

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "All controls follow the same pattern: @State + $binding for two-way data flow",
                "Button styles (plain, bordered, borderedProminent) communicate action importance",
                "Picker's pickerStyle changes presentation — segmented, menu, wheel, inline",
                "TextField = single-line, SecureField = passwords, TextEditor = multi-line",
                "Menu is for actions; Picker is for value selection — don't confuse them",
                "Toggle, Slider, Stepper each handle a specific type of input (bool, range, increment)",
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
                    question: "A user needs to enter a paragraph of feedback. Which control should you use?",
                    options: ["TextField", "SecureField", "TextEditor", "Label"],
                    correctIndex: 2,
                    explanation: "TextEditor handles multi-line text input. TextField is single-line only. SecureField hides input (for passwords)."
                ),
                MiniQuizQuestion(
                    question: "You have a list of 15 country options. Which Picker style is best?",
                    options: [".segmented", ".menu", ".wheel", ".inline"],
                    correctIndex: 1,
                    explanation: ".menu is best for many options — it opens a dropdown without taking permanent screen space. .segmented works for 2-5 items only."
                ),
                MiniQuizQuestion(
                    question: "What makes a Button with role: .destructive different from a regular Button?",
                    options: ["It can't be tapped", "It's styled in red to warn the user", "It requires confirmation", "It only works in lists"],
                    correctIndex: 1,
                    explanation: "A destructive role tells SwiftUI to style the button in red/warning colors. This is a visual cue — it doesn't add confirmation automatically."
                ),
            ],
            color: lessonColor
        )
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(3)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(3) ? "Completed!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(3) ? "checkmark.circle.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(3) ? AnyShapeStyle(Color.green) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        Day3ControlsView()
    }
    .environment(AppViewModel())
}
