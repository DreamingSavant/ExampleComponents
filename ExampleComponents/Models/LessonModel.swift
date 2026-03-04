import Foundation

struct Lesson: Identifiable, Hashable {
    let id: Int
    let day: Int
    let title: String
    let subtitle: String
    let icon: String
    let color: String
    let concepts: [String]
    let estimatedMinutes: Int
    let difficulty: Difficulty

    enum Difficulty: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"

        var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "orange"
            case .advanced: return "red"
            }
        }

        var stars: Int {
            switch self {
            case .beginner: return 1
            case .intermediate: return 2
            case .advanced: return 3
            }
        }
    }
}

extension Lesson {
    static let allLessons: [Lesson] = [
        Lesson(
            id: 1, day: 1,
            title: "Foundations",
            subtitle: "Text, Images & Colors",
            icon: "paintbrush.fill",
            color: "lessonPurple",
            concepts: ["Text", "Image", "SF Symbols", "Label", "Color", "Gradient", "Font", "foregroundStyle"],
            estimatedMinutes: 10,
            difficulty: .beginner
        ),
        Lesson(
            id: 2, day: 2,
            title: "Layout Mastery",
            subtitle: "Stacks, Grids & Spacing",
            icon: "square.grid.3x3.fill",
            color: "lessonBlue",
            concepts: ["VStack", "HStack", "ZStack", "Spacer", "Padding", "Frame", "GeometryReader", "LazyVGrid", "LazyHGrid"],
            estimatedMinutes: 10,
            difficulty: .beginner
        ),
        Lesson(
            id: 3, day: 3,
            title: "Controls",
            subtitle: "Buttons, Toggles & Inputs",
            icon: "slider.horizontal.3",
            color: "lessonGreen",
            concepts: ["Button", "Toggle", "Slider", "Stepper", "Picker", "DatePicker", "ColorPicker", "TextField", "TextEditor", "SecureField", "Menu"],
            estimatedMinutes: 10,
            difficulty: .intermediate
        ),
        Lesson(
            id: 4, day: 4,
            title: "Lists & Navigation",
            subtitle: "Scroll, Navigate & Organize",
            icon: "list.bullet.rectangle.fill",
            color: "lessonOrange",
            concepts: ["List", "NavigationStack", "NavigationLink", "TabView", "ScrollView", "ForEach", "Section", "DisclosureGroup", "Searchable", "Swipe Actions"],
            estimatedMinutes: 10,
            difficulty: .intermediate
        ),
        Lesson(
            id: 5, day: 5,
            title: "State & Data Flow",
            subtitle: "Reactive UI Patterns",
            icon: "arrow.triangle.2.circlepath",
            color: "lessonTeal",
            concepts: ["@State", "@Binding", "@Observable", "@Environment", "@AppStorage", "onChange", "onAppear", "task"],
            estimatedMinutes: 10,
            difficulty: .intermediate
        ),
        Lesson(
            id: 6, day: 6,
            title: "Animation & Drawing",
            subtitle: "Motion, Shapes & Canvas",
            icon: "wand.and.stars",
            color: "lessonPink",
            concepts: ["withAnimation", ".animation", "Transition", "matchedGeometryEffect", "Shape", "Path", "Canvas", "TimelineView", "PhaseAnimator", "Spring"],
            estimatedMinutes: 10,
            difficulty: .advanced
        ),
        Lesson(
            id: 7, day: 7,
            title: "Advanced Patterns",
            subtitle: "Sheets, Gestures & Modifiers",
            icon: "star.circle.fill",
            color: "lessonRed",
            concepts: ["Sheet", "Alert", "ConfirmationDialog", "ProgressView", "Gesture", "ViewModifier", "PreferenceKey", "Overlay", "Background", "ClipShape"],
            estimatedMinutes: 10,
            difficulty: .advanced
        ),
    ]
}
