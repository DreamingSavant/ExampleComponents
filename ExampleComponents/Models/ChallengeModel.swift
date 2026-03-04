import Foundation

struct Challenge: Identifiable {
    let id: Int
    let lessonDay: Int
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
}

extension Challenge {
    static let allChallenges: [Challenge] = [
        // Day 1
        Challenge(id: 1, lessonDay: 1,
                  question: "Which modifier changes the color of text in SwiftUI?",
                  options: [".textColor(.red)", ".foregroundStyle(.red)", ".color(.red)", ".tint(.red)"],
                  correctAnswerIndex: 1,
                  explanation: ".foregroundStyle() is the modern way to set text color. It also supports gradients and other ShapeStyles."),
        Challenge(id: 2, lessonDay: 1,
                  question: "How do you display an SF Symbol in SwiftUI?",
                  options: ["Icon(\"star\")", "Image(systemName: \"star\")", "SFSymbol(\"star\")", "Symbol(\"star\")"],
                  correctAnswerIndex: 1,
                  explanation: "Image(systemName:) loads SF Symbols by their identifier string."),
        Challenge(id: 3, lessonDay: 1,
                  question: "Which creates a linear gradient from top to bottom?",
                  options: [
                    "Gradient(colors: [.red, .blue])",
                    "LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)",
                    "Color.gradient(.red, .blue)",
                    "GradientView(from: .red, to: .blue)"
                  ],
                  correctAnswerIndex: 1,
                  explanation: "LinearGradient takes colors and start/end points to define the gradient direction."),
        // Day 2
        Challenge(id: 4, lessonDay: 2,
                  question: "Which stack layers views on top of each other?",
                  options: ["VStack", "HStack", "ZStack", "LayerStack"],
                  correctAnswerIndex: 2,
                  explanation: "ZStack overlays views along the z-axis, stacking them from back to front."),
        Challenge(id: 5, lessonDay: 2,
                  question: "What does GeometryReader provide?",
                  options: [
                    "GPS coordinates",
                    "The size and position of its parent container",
                    "Device orientation only",
                    "Screen resolution"
                  ],
                  correctAnswerIndex: 1,
                  explanation: "GeometryReader gives you a GeometryProxy with the size and coordinate space of the container."),
        Challenge(id: 6, lessonDay: 2,
                  question: "How do you create a flexible grid layout?",
                  options: ["GridView", "LazyVGrid with GridItem", "UICollectionView", "FlexLayout"],
                  correctAnswerIndex: 1,
                  explanation: "LazyVGrid combined with GridItem columns creates responsive grid layouts natively."),
        // Day 3
        Challenge(id: 7, lessonDay: 3,
                  question: "Which modifier makes a Button have a rounded, filled style?",
                  options: [".buttonStyle(.filled)", ".buttonStyle(.borderedProminent)", ".style(.rounded)", ".prominence(.high)"],
                  correctAnswerIndex: 1,
                  explanation: ".borderedProminent gives buttons a filled, prominent appearance using the accent color."),
        Challenge(id: 8, lessonDay: 3,
                  question: "What property wrapper does Toggle require?",
                  options: ["@State Bool", "@Published Bool", "@Binding String", "@Toggle Bool"],
                  correctAnswerIndex: 0,
                  explanation: "Toggle needs a Binding<Bool>, which @State provides when passed with $ prefix."),
        Challenge(id: 9, lessonDay: 3,
                  question: "Which control lets users pick from a date range?",
                  options: ["TimePicker", "DateSelector", "DatePicker", "CalendarView"],
                  correctAnswerIndex: 2,
                  explanation: "DatePicker is SwiftUI's built-in control for selecting dates and times."),
        // Day 4
        Challenge(id: 10, lessonDay: 4,
                  question: "What replaced NavigationView in modern SwiftUI?",
                  options: ["NavigationController", "NavigationStack", "Router", "NavigationManager"],
                  correctAnswerIndex: 1,
                  explanation: "NavigationStack (iOS 16+) replaces NavigationView with value-based, type-safe navigation."),
        Challenge(id: 11, lessonDay: 4,
                  question: "How do you add swipe-to-delete on a List row?",
                  options: [".onDelete()", ".swipeActions()", ".deletable()", "Both A and B"],
                  correctAnswerIndex: 3,
                  explanation: "Both .onDelete (ForEach) and .swipeActions (per row) enable delete gestures."),
        Challenge(id: 12, lessonDay: 4,
                  question: "Which modifier adds a search bar to a NavigationStack?",
                  options: [".searchBar()", ".searchable()", ".filter()", ".search()"],
                  correctAnswerIndex: 1,
                  explanation: ".searchable() adds a native search bar that integrates with the navigation chrome."),
        // Day 5
        Challenge(id: 13, lessonDay: 5,
                  question: "What's the difference between @State and @Binding?",
                  options: [
                    "@State owns data, @Binding borrows it",
                    "They are identical",
                    "@Binding is for classes only",
                    "@State is deprecated"
                  ],
                  correctAnswerIndex: 0,
                  explanation: "@State is the source of truth owned by the view; @Binding is a reference that reads/writes to someone else's @State."),
        Challenge(id: 14, lessonDay: 5,
                  question: "Which macro replaces ObservableObject in modern SwiftUI?",
                  options: ["@Model", "@Observable", "@Observed", "@Reactive"],
                  correctAnswerIndex: 1,
                  explanation: "@Observable (Observation framework) replaces ObservableObject with simpler, more performant tracking."),
        Challenge(id: 15, lessonDay: 5,
                  question: "How do you persist a value across app launches?",
                  options: ["@State", "@Binding", "@AppStorage", "@Persistent"],
                  correctAnswerIndex: 2,
                  explanation: "@AppStorage wraps UserDefaults and automatically persists values between sessions."),
        // Day 6
        Challenge(id: 16, lessonDay: 6,
                  question: "Which function triggers an explicit animation?",
                  options: ["animate()", "withAnimation()", "UIView.animate()", "startAnimation()"],
                  correctAnswerIndex: 1,
                  explanation: "withAnimation {} wraps state changes so SwiftUI animates any resulting view transitions."),
        Challenge(id: 17, lessonDay: 6,
                  question: "What protocol do you conform to for custom shapes?",
                  options: ["Drawable", "Shape", "PathProvider", "ShapeView"],
                  correctAnswerIndex: 1,
                  explanation: "The Shape protocol requires a path(in:) function that returns the geometry of your shape."),
        Challenge(id: 18, lessonDay: 6,
                  question: "What does matchedGeometryEffect enable?",
                  options: [
                    "Matching colors between views",
                    "Smooth hero transitions between views sharing an ID",
                    "Synchronized scrolling",
                    "Geometry calculations"
                  ],
                  correctAnswerIndex: 1,
                  explanation: "matchedGeometryEffect creates seamless 'hero' transitions by animating geometry between views with shared IDs."),
        // Day 7
        Challenge(id: 19, lessonDay: 7,
                  question: "How do you present a modal sheet?",
                  options: [".present()", ".sheet(isPresented:)", ".modal()", ".overlay()"],
                  correctAnswerIndex: 1,
                  explanation: ".sheet(isPresented:) presents a modal sheet driven by a boolean binding."),
        Challenge(id: 20, lessonDay: 7,
                  question: "Which protocol lets you create reusable view modifications?",
                  options: ["ViewStyle", "ViewModifier", "ModifierProtocol", "ViewDecorator"],
                  correctAnswerIndex: 1,
                  explanation: "ViewModifier protocol lets you bundle multiple modifiers into a reusable, composable unit."),
        Challenge(id: 21, lessonDay: 7,
                  question: "How do you detect a long-press gesture?",
                  options: [".onLongPress()", ".onLongPressGesture()", ".gesture(.hold)", ".longTap()"],
                  correctAnswerIndex: 1,
                  explanation: ".onLongPressGesture() detects when the user presses and holds on a view."),
    ]
}
