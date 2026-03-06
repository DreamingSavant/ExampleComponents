import Foundation

struct Challenge: Identifiable {
    let id: Int
    let lessonDay: Int
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    var questionType: QuestionType = .concept

    enum QuestionType: String {
        case concept = "Concept"
        case predict = "Predict Output"
        case fixBug = "Fix the Bug"
        case choose = "Best Practice"
        case layout = "Layout"
    }
}

extension Challenge {
    static let allChallenges: [Challenge] = [
        // MARK: - Day 1: Foundations (7 questions)

        Challenge(id: 1, lessonDay: 1,
                  question: "Which modifier changes the color of text in SwiftUI?",
                  options: [".textColor(.red)", ".foregroundStyle(.red)", ".color(.red)", ".tint(.red)"],
                  correctAnswerIndex: 1,
                  explanation: ".foregroundStyle() is the modern way to set text color. It also supports gradients and other ShapeStyles. .foregroundColor() is deprecated."),

        Challenge(id: 2, lessonDay: 1,
                  question: "How do you display an SF Symbol in SwiftUI?",
                  options: ["Icon(\"star\")", "Image(systemName: \"star\")", "SFSymbol(\"star\")", "Symbol(\"star\")"],
                  correctAnswerIndex: 1,
                  explanation: "Image(systemName:) loads SF Symbols by their identifier string. There are 6,000+ symbols available."),

        Challenge(id: 3, lessonDay: 1,
                  question: "Which creates a linear gradient from top to bottom?",
                  options: [
                    "Gradient(colors: [.red, .blue])",
                    "LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)",
                    "Color.gradient(.red, .blue)",
                    "GradientView(from: .red, to: .blue)",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "LinearGradient takes colors and start/end points to define the gradient direction."),

        Challenge(id: 4, lessonDay: 1,
                  question: "Why should you prefer Label over HStack { Image; Text }?",
                  options: [
                    "Label is faster to type",
                    "Label adapts its layout based on context (toolbars, lists, etc.)",
                    "Label supports more colors",
                    "There is no difference",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "Label is a semantic component. In a toolbar it might show only the icon; in a list, both. HStack always renders both regardless of context.",
                  questionType: .choose),

        Challenge(id: 5, lessonDay: 1,
                  question: "Which font style should you use for the main body text of your app?",
                  options: [".font(.system(size: 16))", ".font(.body)", ".font(.callout)", ".font(.subheadline)"],
                  correctAnswerIndex: 1,
                  explanation: ".body is the semantic font for main content. It automatically adapts to the user's Dynamic Type settings, making your app accessible.",
                  questionType: .choose),

        Challenge(id: 6, lessonDay: 1,
                  question: "What does .symbolRenderingMode(.hierarchical) do to an SF Symbol?",
                  options: [
                    "Makes it invisible",
                    "Renders layers with varying opacity for depth",
                    "Changes it to a different symbol",
                    "Adds a drop shadow",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "Hierarchical rendering uses the foreground color at varying opacities to create a layered depth effect in multi-layer SF Symbols."),

        Challenge(id: 7, lessonDay: 1,
                  question: "What will this code display?\nText(\"Hello\").font(.title).bold().italic()",
                  options: [
                    "\"Hello\" in title size, bold only",
                    "\"Hello\" in title size, bold and italic",
                    "An error — you can't chain bold and italic",
                    "\"Hello\" in default size, bold and italic",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "SwiftUI modifiers chain and compose. .font sets the size, .bold() adds weight, .italic() adds slant. All three apply together.",
                  questionType: .predict),

        // MARK: - Day 2: Layout (7 questions)

        Challenge(id: 8, lessonDay: 2,
                  question: "Which stack layers views on top of each other?",
                  options: ["VStack", "HStack", "ZStack", "LayerStack"],
                  correctAnswerIndex: 2,
                  explanation: "ZStack overlays views along the z-axis, stacking them from back to front. V = vertical, H = horizontal, Z = depth."),

        Challenge(id: 9, lessonDay: 2,
                  question: "What does GeometryReader provide?",
                  options: [
                    "GPS coordinates",
                    "The size and position of its parent container",
                    "Device orientation only",
                    "Screen resolution",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "GeometryReader gives you a GeometryProxy with the size and coordinate space of the container. Use it sparingly — it changes layout behavior."),

        Challenge(id: 10, lessonDay: 2,
                  question: "How do you create a flexible grid layout?",
                  options: ["GridView", "LazyVGrid with GridItem", "UICollectionView", "FlexLayout"],
                  correctAnswerIndex: 1,
                  explanation: "LazyVGrid combined with GridItem columns creates responsive grid layouts. Use .flexible(), .fixed(), or .adaptive() GridItems."),

        Challenge(id: 11, lessonDay: 2,
                  question: "What does Spacer() do inside an HStack?",
                  options: [
                    "Nothing visible",
                    "Pushes other views apart by consuming available space",
                    "Adds fixed 8pt padding",
                    "Creates a divider line",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "Spacer is a flexible view that expands to fill available space, pushing sibling views to the edges. It's essential for custom alignment."),

        Challenge(id: 12, lessonDay: 2,
                  question: "What's the difference between .padding() and .frame()?",
                  options: [
                    "They're the same thing",
                    "padding adds space around content; frame sets the view's size constraints",
                    "frame adds space; padding sets size",
                    "padding only works on Text",
                  ],
                  correctAnswerIndex: 1,
                  explanation: ".padding() adds inset space around the view's content. .frame() constrains or expands the view's size. They serve different purposes and are often combined.",
                  questionType: .concept),

        Challenge(id: 13, lessonDay: 2,
                  question: "Why should you be careful with GeometryReader?",
                  options: [
                    "It crashes on older devices",
                    "It expands to fill all available space, changing the layout",
                    "It only works on iOS",
                    "It requires @State",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "GeometryReader is greedy — it expands to fill its parent. This can break layouts if not contained with .frame(). Prefer other layout tools when possible.",
                  questionType: .choose),

        Challenge(id: 14, lessonDay: 2,
                  question: "What does .frame(maxWidth: .infinity, alignment: .leading) do?",
                  options: [
                    "Makes the view infinitely wide",
                    "Expands the view to fill available width, aligning content to the left",
                    "Causes a crash — infinity is not valid",
                    "Sets a minimum width",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "maxWidth: .infinity tells the view to fill all available horizontal space. The alignment parameter controls where the content sits within that space.",
                  questionType: .predict),

        // MARK: - Day 3: Controls (7 questions)

        Challenge(id: 15, lessonDay: 3,
                  question: "Which modifier gives a Button a rounded, filled style?",
                  options: [".buttonStyle(.filled)", ".buttonStyle(.borderedProminent)", ".style(.rounded)", ".prominence(.high)"],
                  correctAnswerIndex: 1,
                  explanation: ".borderedProminent gives buttons a filled, prominent appearance using the accent color. It's the standard call-to-action style."),

        Challenge(id: 16, lessonDay: 3,
                  question: "What property wrapper does Toggle need for its state?",
                  options: ["@State Bool", "@Published Bool", "@Binding String", "@Toggle Bool"],
                  correctAnswerIndex: 0,
                  explanation: "Toggle needs a Binding<Bool>, which @State provides when passed with $ prefix: Toggle(isOn: $myBool)."),

        Challenge(id: 17, lessonDay: 3,
                  question: "Which control lets users pick from a date range?",
                  options: ["TimePicker", "DateSelector", "DatePicker", "CalendarView"],
                  correctAnswerIndex: 2,
                  explanation: "DatePicker is SwiftUI's built-in control for selecting dates and times. You configure it with displayedComponents."),

        Challenge(id: 18, lessonDay: 3,
                  question: "What's the difference between TextField and TextEditor?",
                  options: [
                    "They're identical",
                    "TextField is single-line; TextEditor is multi-line",
                    "TextEditor is for passwords",
                    "TextField supports rich text",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "TextField handles single-line input (like a username). TextEditor handles multi-line text (like a notes field). Use SecureField for passwords.",
                  questionType: .concept),

        Challenge(id: 19, lessonDay: 3,
                  question: "When should you use a Menu instead of a Picker?",
                  options: [
                    "Never — always use Picker",
                    "When options are destructive actions or have sub-menus",
                    "When you need more than 3 options",
                    "When on iPad only",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "Menu is for contextual actions (Copy, Delete, Share). Picker is for selecting a value from options. Menu supports sub-menus, dividers, and destructive roles.",
                  questionType: .choose),

        Challenge(id: 20, lessonDay: 3,
                  question: "What will happen if you create a Slider without a step parameter?",
                  options: [
                    "It won't compile",
                    "It returns only integer values",
                    "It returns continuous (smooth) Double values",
                    "It defaults to steps of 0.1",
                  ],
                  correctAnswerIndex: 2,
                  explanation: "Without a step parameter, Slider produces continuous Double values. Add step: 1 for integer-like behavior, or any other interval for snapping.",
                  questionType: .predict),

        Challenge(id: 21, lessonDay: 3,
                  question: "How do you make a SecureField show/hide the password?",
                  options: [
                    "SecureField has a built-in toggle",
                    "You switch between SecureField and TextField using a Bool",
                    ".secureFieldStyle(.revealed)",
                    "You can't — it always hides text",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "SwiftUI doesn't have a built-in reveal toggle. The pattern is: use @State var showPassword, then if/else between TextField and SecureField.",
                  questionType: .choose),

        // MARK: - Day 4: Lists & Navigation (7 questions)

        Challenge(id: 22, lessonDay: 4,
                  question: "What replaced NavigationView in modern SwiftUI?",
                  options: ["NavigationController", "NavigationStack", "Router", "NavigationManager"],
                  correctAnswerIndex: 1,
                  explanation: "NavigationStack (iOS 16+) replaces NavigationView with value-based, type-safe navigation and programmatic path control."),

        Challenge(id: 23, lessonDay: 4,
                  question: "How do you add swipe-to-delete on a List row?",
                  options: [".onDelete()", ".swipeActions()", ".deletable()", "Both A and B"],
                  correctAnswerIndex: 3,
                  explanation: "Both .onDelete (on ForEach) and .swipeActions (on individual rows) can enable delete gestures. .onDelete is the simpler approach for basic delete."),

        Challenge(id: 24, lessonDay: 4,
                  question: "Which modifier adds a search bar to a NavigationStack?",
                  options: [".searchBar()", ".searchable()", ".filter()", ".search()"],
                  correctAnswerIndex: 1,
                  explanation: ".searchable() adds a native search bar. It integrates with the navigation chrome and supports search suggestions."),

        Challenge(id: 25, lessonDay: 4,
                  question: "When should you use List vs ScrollView + LazyVStack?",
                  options: [
                    "Always use List",
                    "List for data rows with built-in features; ScrollView for custom layouts",
                    "ScrollView is always faster",
                    "They're identical in functionality",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "List provides swipe actions, selection, edit mode, and cell reuse for free. Use ScrollView + LazyVStack when you need full control over layout and appearance.",
                  questionType: .choose),

        Challenge(id: 26, lessonDay: 4,
                  question: "What does DisclosureGroup provide?",
                  options: [
                    "A way to hide passwords",
                    "A collapsible section that expands/collapses on tap",
                    "A navigation link",
                    "A disclosure indicator chevron",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "DisclosureGroup wraps content in a collapsible container. Use isExpanded: binding for programmatic control. Great for settings and FAQ screens."),

        Challenge(id: 27, lessonDay: 4,
                  question: "What happens if you put NavigationLink inside a ScrollView (not a List)?",
                  options: [
                    "It won't compile",
                    "It works but has no built-in disclosure indicator",
                    "It crashes at runtime",
                    "It automatically converts to a List",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "NavigationLink works in any context, but only List rows get the automatic chevron disclosure indicator. In ScrollView, you must add your own visual cues.",
                  questionType: .predict),

        Challenge(id: 28, lessonDay: 4,
                  question: "What's the purpose of .navigationDestination(for:)?",
                  options: [
                    "It sets the navigation title",
                    "It defines what view to show when navigating to a specific data type",
                    "It creates a back button",
                    "It replaces NavigationLink",
                  ],
                  correctAnswerIndex: 1,
                  explanation: ".navigationDestination(for: MyType.self) is the modern way to define navigation routes. When a NavigationLink pushes a value of that type, this view is shown."),

        // MARK: - Day 5: State & Data Flow (7 questions)

        Challenge(id: 29, lessonDay: 5,
                  question: "What's the difference between @State and @Binding?",
                  options: [
                    "@State owns data, @Binding borrows it",
                    "They are identical",
                    "@Binding is for classes only",
                    "@State is deprecated",
                  ],
                  correctAnswerIndex: 0,
                  explanation: "@State is the source of truth owned by one view. @Binding is a two-way reference that reads/writes someone else's @State. Pass with $ prefix."),

        Challenge(id: 30, lessonDay: 5,
                  question: "Which macro replaces ObservableObject in modern SwiftUI?",
                  options: ["@Model", "@Observable", "@Observed", "@Reactive"],
                  correctAnswerIndex: 1,
                  explanation: "@Observable (Observation framework, iOS 17+) replaces ObservableObject with simpler syntax and more performant, property-level tracking."),

        Challenge(id: 31, lessonDay: 5,
                  question: "How do you persist a value across app launches?",
                  options: ["@State", "@Binding", "@AppStorage", "@Persistent"],
                  correctAnswerIndex: 2,
                  explanation: "@AppStorage wraps UserDefaults and automatically persists simple values (String, Int, Bool, Double) between sessions."),

        Challenge(id: 32, lessonDay: 5,
                  question: "When does a view re-render with @Observable?",
                  options: [
                    "Whenever any property of the object changes",
                    "Only when properties the view actually reads change",
                    "On every frame",
                    "Only when you call objectWillChange.send()",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "@Observable tracks property access at the view level. If your view only reads .name, changing .age won't cause a re-render. This is more efficient than ObservableObject.",
                  questionType: .concept),

        Challenge(id: 33, lessonDay: 5,
                  question: "What's wrong with this code?\nstruct ChildView: View {\n    @State var text: String\n}",
                  options: [
                    "Nothing — it's correct",
                    "@State should be private; non-private means the parent can't properly initialize it",
                    "You must use var, not let",
                    "It needs @Observable instead",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "@State should almost always be private. If a parent needs to pass data to a child, use @Binding or a regular property. A non-private @State can be initialized by the parent but then disconnects.",
                  questionType: .fixBug),

        Challenge(id: 34, lessonDay: 5,
                  question: "What does .task { } do differently from .onAppear { }?",
                  options: [
                    "Nothing — they're the same",
                    ".task supports async/await and auto-cancels when the view disappears",
                    ".task runs on every re-render",
                    ".task is for UIKit only",
                  ],
                  correctAnswerIndex: 1,
                  explanation: ".task creates an async context tied to the view's lifecycle. When the view disappears, the task is automatically cancelled. Use it for network calls and async work."),

        Challenge(id: 35, lessonDay: 5,
                  question: "How do you pass an @Observable object through the environment?",
                  options: [
                    ".environmentObject(vm)",
                    ".environment(vm)",
                    "@EnvironmentObject var vm",
                    ".environment(\\.vm, vm)",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "With @Observable, use .environment(vm) to inject and @Environment(MyVM.self) to read. The older .environmentObject is for ObservableObject conformance."),

        // MARK: - Day 6: Animation & Drawing (7 questions)

        Challenge(id: 36, lessonDay: 6,
                  question: "Which function triggers an explicit animation?",
                  options: ["animate()", "withAnimation()", "UIView.animate()", "startAnimation()"],
                  correctAnswerIndex: 1,
                  explanation: "withAnimation { } wraps state changes so SwiftUI animates any view properties affected by those changes. You control which animation curve to use."),

        Challenge(id: 37, lessonDay: 6,
                  question: "What protocol do you conform to for custom shapes?",
                  options: ["Drawable", "Shape", "PathProvider", "ShapeView"],
                  correctAnswerIndex: 1,
                  explanation: "The Shape protocol requires a path(in:) function that returns a Path describing the geometry. Shapes are also Views, so you use them directly."),

        Challenge(id: 38, lessonDay: 6,
                  question: "What does matchedGeometryEffect enable?",
                  options: [
                    "Matching colors between views",
                    "Smooth hero transitions between views sharing an ID",
                    "Synchronized scrolling",
                    "Geometry calculations",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "matchedGeometryEffect creates seamless transitions by interpolating size and position between two views that share the same ID and namespace."),

        Challenge(id: 39, lessonDay: 6,
                  question: "What's the difference between withAnimation and .animation()?",
                  options: [
                    "They're identical",
                    "withAnimation is explicit (wraps state change); .animation is implicit (watches a value)",
                    ".animation is deprecated",
                    "withAnimation is slower",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "withAnimation explicitly animates state changes you wrap. .animation(_:value:) implicitly animates whenever the watched value changes. Both have their uses.",
                  questionType: .concept),

        Challenge(id: 40, lessonDay: 6,
                  question: "What does .transition(.asymmetric(insertion:, removal:)) do?",
                  options: [
                    "Different animations for adding vs removing a view",
                    "Animates width and height separately",
                    "Only works on iPad",
                    "Creates a 3D effect",
                  ],
                  correctAnswerIndex: 0,
                  explanation: "Asymmetric transitions let you define separate animations for when a view appears (insertion) vs when it disappears (removal). Great for polish.",
                  questionType: .concept),

        Challenge(id: 41, lessonDay: 6,
                  question: "What happens if you animate a property that isn't Animatable?",
                  options: [
                    "Xcode shows a warning",
                    "The change happens instantly with no animation",
                    "The app crashes",
                    "It animates anyway but slowly",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "SwiftUI can only interpolate Animatable values (CGFloat, Double, Color, etc.). Non-animatable changes snap instantly. Custom shapes need animatableData for smooth animation.",
                  questionType: .predict),

        Challenge(id: 42, lessonDay: 6,
                  question: "How do you make a custom Shape animate smoothly?",
                  options: [
                    "Just use withAnimation",
                    "Implement animatableData to tell SwiftUI which properties to interpolate",
                    "Add .animation() to the shape",
                    "Use CAAnimation",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "Custom shapes must implement the animatableData property (from Animatable protocol). This tells SwiftUI which values to interpolate frame-by-frame.",
                  questionType: .choose),

        // MARK: - Day 7: Advanced (7 questions)

        Challenge(id: 43, lessonDay: 7,
                  question: "How do you present a modal sheet?",
                  options: [".present()", ".sheet(isPresented:)", ".modal()", ".overlay()"],
                  correctAnswerIndex: 1,
                  explanation: ".sheet(isPresented:) presents a modal sheet driven by a boolean binding. Also supports .sheet(item:) for data-driven presentation."),

        Challenge(id: 44, lessonDay: 7,
                  question: "Which protocol lets you create reusable view modifications?",
                  options: ["ViewStyle", "ViewModifier", "ModifierProtocol", "ViewDecorator"],
                  correctAnswerIndex: 1,
                  explanation: "ViewModifier protocol lets you bundle multiple modifiers into a reusable, composable unit. Apply with .modifier() or a View extension."),

        Challenge(id: 45, lessonDay: 7,
                  question: "How do you detect a long-press gesture?",
                  options: [".onLongPress()", ".onLongPressGesture()", ".gesture(.hold)", ".longTap()"],
                  correctAnswerIndex: 1,
                  explanation: ".onLongPressGesture(minimumDuration:) detects when the user presses and holds on a view. You can also use LongPressGesture() for more control."),

        Challenge(id: 46, lessonDay: 7,
                  question: "What's the difference between .sheet and .fullScreenCover?",
                  options: [
                    "They're identical",
                    "Sheet slides up partially with drag-to-dismiss; fullScreenCover takes the entire screen",
                    "fullScreenCover is only on iPad",
                    "Sheet can't be dismissed",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "Sheet shows as a card you can drag to dismiss. fullScreenCover takes the entire screen and must be dismissed programmatically. Use fullScreenCover for immersive experiences.",
                  questionType: .concept),

        Challenge(id: 47, lessonDay: 7,
                  question: "When should you use .overlay vs ZStack?",
                  options: [
                    "They're the same thing",
                    "overlay attaches to a specific view's bounds; ZStack creates an independent layer",
                    "ZStack is deprecated",
                    "overlay only works with Text",
                  ],
                  correctAnswerIndex: 1,
                  explanation: ".overlay positions content relative to the modified view's frame. ZStack creates its own coordinate space. Use overlay for badges/labels on specific views.",
                  questionType: .choose),

        Challenge(id: 48, lessonDay: 7,
                  question: "What problem does ViewModifier solve?",
                  options: [
                    "Makes views faster",
                    "Eliminates code duplication by packaging reusable modifier combinations",
                    "Fixes layout bugs",
                    "Adds accessibility support",
                  ],
                  correctAnswerIndex: 1,
                  explanation: "When you find yourself applying the same chain of modifiers (background, cornerRadius, shadow, padding) repeatedly, extract them into a ViewModifier for DRY code."),

        Challenge(id: 49, lessonDay: 7,
                  question: "What does .clipShape do?",
                  options: [
                    "Adds a border in a shape",
                    "Masks the view to the given shape, cutting off anything outside",
                    "Changes the view's shadow shape",
                    "Rotates the view",
                  ],
                  correctAnswerIndex: 1,
                  explanation: ".clipShape masks the view's visible area to any Shape. Content outside the shape is hidden. Common for circular avatars: Image(\"photo\").clipShape(Circle())."),
    ]
}
