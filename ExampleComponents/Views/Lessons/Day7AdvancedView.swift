import SwiftUI

struct Day7AdvancedView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var showAlert = false
    @State private var showConfirmation = false
    @State private var progressValue: Double = 0
    @State private var dragOffset = CGSize.zero
    @State private var gestureScale: CGFloat = 1
    @State private var gestureRotation: Angle = .zero
    @State private var longPressActive = false
    @State private var overlayVisible = false

    private let lessonColor = DojoTheme.color(for: "lessonRed")

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                objectiveSection

                ConceptExplainer(
                    title: "Modal Presentation: Sheet & FullScreenCover",
                    explanation: "Sheets and full-screen covers present content modally — on top of the current view. Sheet slides up as a card (drag to dismiss on iOS). FullScreenCover takes the entire screen and must be dismissed programmatically. Both are driven by a Bool binding or an optional item.",
                    whyItMatters: "Modal presentation is the standard pattern for detail views, editing screens, settings, and onboarding. Choosing between sheet and fullScreenCover depends on whether the content should feel temporary (sheet) or immersive (full screen).",
                    whenToUse: "Sheet for quick views the user might dismiss (settings, detail). FullScreenCover for immersive content (video, onboarding). Use .presentationDetents to control sheet heights.",
                    color: lessonColor
                )
                sheetSection
                TipBox(style: .tip, content: "Use .sheet(item:) instead of .sheet(isPresented:) when you need to pass data to the sheet. This also handles the dismiss-and-reopen edge case correctly.")

                ConceptExplainer(
                    title: "Alert & ConfirmationDialog",
                    explanation: "Alert shows a system dialog with title, message, and buttons. ConfirmationDialog shows an action sheet with multiple options. Both are driven by a Bool binding and appear over the current content.",
                    whyItMatters: "These are the standard iOS patterns for confirmations and choices. Using system alerts and action sheets ensures your app follows platform conventions and accessibility standards.",
                    whenToUse: "Alert for important messages requiring acknowledgment. ConfirmationDialog for choosing between multiple actions (especially destructive ones like delete).",
                    color: lessonColor
                )
                alertSection
                confirmationDialogSection

                ConceptExplainer(
                    title: "ProgressView: Loading & Progress",
                    explanation: "ProgressView has two modes: indeterminate (spinning) for unknown duration, and determinate (progress bar) with a value from 0 to 1. Both automatically match the platform style.",
                    whyItMatters: "Loading states are critical for UX. Without progress feedback, users think the app is frozen. Always show loading indicators during async operations.",
                    whenToUse: "Indeterminate spinner for unknown-length tasks (network requests). Determinate bar for trackable progress (file downloads, multi-step processes).",
                    color: lessonColor
                )
                progressViewSection

                ConceptExplainer(
                    title: "Gestures: Touch Handling",
                    explanation: "SwiftUI supports tap, long-press, drag, magnify (pinch), and rotate gestures. Attach them with .gesture() or convenience modifiers (.onTapGesture, .onLongPressGesture). Gestures provide real-time values for creating interactive experiences.",
                    whyItMatters: "Direct manipulation through gestures makes your app feel responsive and engaging. Drag for repositioning, pinch for zoom, rotate for orientation — these are fundamental touch interactions.",
                    whenToUse: "DragGesture for moving/swiping. MagnifyGesture for zoom. RotateGesture for rotation. Combine gestures with .simultaneously or .sequenced for complex interactions.",
                    color: lessonColor
                )
                gestureSection
                TipBox(style: .warning, content: "Gesture conflicts: If a child and parent both have gestures, the child wins by default. Use .highPriorityGesture() on the parent to override, or .simultaneousGesture() to allow both.")

                ConceptExplainer(
                    title: "Custom ViewModifier: Reusable Styling",
                    explanation: "ViewModifier packages multiple modifiers into a reusable unit. Instead of copying the same chain of .padding().background().cornerRadius().shadow() everywhere, extract it into a ViewModifier and apply it with .modifier() or a View extension.",
                    whyItMatters: "DRY (Don't Repeat Yourself) is critical in UI code. ViewModifiers reduce duplication, ensure consistency, and make styling changes a one-line fix instead of a find-and-replace across dozens of files.",
                    whenToUse: "Extract a ViewModifier whenever you use the same 3+ modifier chain in multiple places. Create a View extension for clean call-site syntax: Text(\"Hello\").myStyle().",
                    color: lessonColor
                )
                viewModifierSection

                ConceptExplainer(
                    title: "Overlay, Background & ClipShape",
                    explanation: ".overlay places content in front of a view, positioned relative to it. .background places content behind. .clipShape masks the view to any Shape. Together, they enable layered compositions: badges on images, colored backgrounds behind text, circular avatars.",
                    whyItMatters: "These three modifiers handle 90% of visual layering needs. Understanding the difference between overlay/background (relative to one view) and ZStack (independent coordinate space) is key to clean layouts.",
                    whenToUse: "overlay for badges, labels, and decorations on a specific view. background for colored/material backdrops. clipShape for masking to Circle, RoundedRectangle, or custom shapes.",
                    color: lessonColor
                )
                overlayBackgroundSection
                clipShapeSection
                TipBox(style: .info, content: "overlay and background inherit the modified view's size. ZStack uses the largest child's size. Use overlay when you want to position relative to a specific view's bounds.")

                takeaways
                miniQuiz
                completeButton
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Day 7: Advanced")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSheet) {
            SheetContentView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenContentView(isPresented: $showFullScreen)
        }
        .alert("Congratulations!", isPresented: $showAlert) {
            Button("Awesome!") {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You've reached Day 7 — the final lesson!")
        }
        .confirmationDialog("Choose an Action", isPresented: $showConfirmation) {
            Button("Save") {}
            Button("Share") {}
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "star.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(lessonColor)
                .pulsingSymbol()

            Text("Sheets, Gestures & Modifiers")
                .font(.title2.bold())

            Text("Advanced patterns to complete your mastery")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    private var objectiveSection: some View {
        LessonObjectiveView(
            day: 7,
            title: "Master advanced presentation, gestures, and composition patterns",
            objectives: [
                "Present modals with sheet and fullScreenCover",
                "Use alerts and confirmation dialogs for user decisions",
                "Handle touch gestures (drag, pinch, rotate, long-press)",
                "Create reusable ViewModifiers and layer views with overlay/background/clipShape",
            ],
            estimatedMinutes: 10,
            color: lessonColor
        )
    }

    // MARK: - Sheet

    private var sheetSection: some View {
        ComponentShowcase(title: "Sheet & FullScreenCover", description: "Modal presentation styles", color: lessonColor) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button {
                        showSheet = true
                    } label: {
                        Label("Sheet", systemImage: "rectangle.bottomhalf.inset.filled")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(lessonColor.opacity(0.1)))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showFullScreen = true
                    } label: {
                        Label("Full Screen", systemImage: "rectangle.inset.filled")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(lessonColor.opacity(0.1)))
                    }
                    .buttonStyle(.plain)
                }

                CodeSnippetView(code: """
                .sheet(isPresented: $showSheet) {
                    MyView()
                        .presentationDetents([.medium, .large])
                }
                .fullScreenCover(isPresented: $showFull) {
                    FullView(isPresented: $showFull)
                }
                """, title: "Sheet.swift")
            }
        }
    }

    // MARK: - Alert

    private var alertSection: some View {
        ComponentShowcase(title: "Alert", description: "System alert dialogs", color: lessonColor) {
            VStack(spacing: 12) {
                Button("Show Alert") { showAlert = true }
                    .buttonStyle(.borderedProminent)
                    .tint(lessonColor)

                CodeSnippetView(code: """
                .alert("Title", isPresented: $show) {
                    Button("OK") { }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Alert message body")
                }
                """, title: "Alert.swift")
            }
        }
    }

    // MARK: - ConfirmationDialog

    private var confirmationDialogSection: some View {
        ComponentShowcase(title: "ConfirmationDialog", description: "Action sheet with options", color: lessonColor) {
            VStack(spacing: 12) {
                Button("Show Action Sheet") { showConfirmation = true }
                    .buttonStyle(.borderedProminent)
                    .tint(lessonColor)

                CodeSnippetView(code: """
                .confirmationDialog("Title",
                    isPresented: $show) {
                    Button("Save") { }
                    Button("Delete", role: .destructive) { }
                }
                """, title: "ConfirmationDialog.swift")
            }
        }
    }

    // MARK: - ProgressView

    private var progressViewSection: some View {
        ComponentShowcase(title: "ProgressView", description: "Loading indicators and progress bars", color: lessonColor) {
            VStack(spacing: 16) {
                HStack(spacing: 30) {
                    VStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Spinner")
                            .font(.caption2)
                    }

                    VStack(spacing: 8) {
                        ProgressView(value: progressValue)
                            .frame(width: 120)
                            .tint(lessonColor)
                        Text("Determinate")
                            .font(.caption2)
                    }
                }

                HStack {
                    Text("Progress: \(Int(progressValue * 100))%")
                        .font(.caption)
                    Slider(value: $progressValue, in: 0...1)
                        .tint(lessonColor)
                }

                CodeSnippetView(code: """
                ProgressView() // Indeterminate spinner
                ProgressView(value: 0.7) // 70% bar
                """, title: "ProgressView.swift")
            }
        }
    }

    // MARK: - Gestures

    private var gestureSection: some View {
        ComponentShowcase(title: "Gestures", description: "Drag, pinch, rotate, long-press, tap", color: lessonColor) {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 200)

                    RoundedRectangle(cornerRadius: 16)
                        .fill(longPressActive ? lessonColor : lessonColor.opacity(0.5))
                        .frame(width: 80, height: 80)
                        .scaleEffect(gestureScale)
                        .rotationEffect(gestureRotation)
                        .offset(dragOffset)
                        .gesture(dragGesture)
                        .gesture(magnificationGesture)
                        .gesture(rotationGesture)
                        .onLongPressGesture(minimumDuration: 0.5) {
                            withAnimation { longPressActive.toggle() }
                        }
                        .animation(.spring(response: 0.3), value: longPressActive)
                }

                Text("Try: drag, pinch, rotate, and long-press the square")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Reset") {
                    withAnimation(.spring) {
                        dragOffset = .zero
                        gestureScale = 1
                        gestureRotation = .zero
                        longPressActive = false
                    }
                }
                .buttonStyle(.bordered)

                CodeSnippetView(code: """
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in offset = .zero }
                )
                .onLongPressGesture(minimumDuration: 0.5) {
                    // long press recognized
                }
                """, title: "Gestures.swift")
            }
        }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in dragOffset = value.translation }
            .onEnded { _ in
                withAnimation(.spring) { dragOffset = .zero }
            }
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in gestureScale = value.magnification }
            .onEnded { _ in
                withAnimation(.spring) { gestureScale = 1 }
            }
    }

    private var rotationGesture: some Gesture {
        RotateGesture()
            .onChanged { value in gestureRotation = value.rotation }
            .onEnded { _ in
                withAnimation(.spring) { gestureRotation = .zero }
            }
    }

    // MARK: - ViewModifier

    private var viewModifierSection: some View {
        ComponentShowcase(title: "Custom ViewModifier", description: "Bundle reusable modifier logic", color: lessonColor) {
            VStack(spacing: 16) {
                Text("Card with custom modifier")
                    .padding()
                    .glassCard()

                Text("Showcase card")
                    .showcaseCard(color: lessonColor)

                CodeSnippetView(code: """
                struct GlassCard: ViewModifier {
                    func body(content: Content) -> some View {
                        content
                            .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 8)
                    }
                }
                
                extension View {
                    func glassCard() -> some View {
                        modifier(GlassCard())
                    }
                }
                
                Text("Hello").glassCard()
                """, title: "ViewModifier.swift")
            }
        }
    }

    // MARK: - Overlay & Background

    private var overlayBackgroundSection: some View {
        ComponentShowcase(title: "Overlay & Background", description: "Layer views in front or behind", color: lessonColor) {
            VStack(spacing: 16) {
                Toggle("Show Overlay", isOn: $overlayVisible.animation(.snappy))
                    .font(.caption)

                Image(systemName: "photo.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(alignment: .bottomTrailing) {
                        if overlayVisible {
                            Text("NEW")
                                .font(.caption2.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(.red))
                                .foregroundStyle(.white)
                                .padding(8)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .overlay(alignment: .topLeading) {
                        if overlayVisible {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                                .padding(8)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }

                CodeSnippetView(code: """
                Image(systemName: "photo")
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.opacity(0.1))
                    )
                    .overlay(alignment: .bottomTrailing) {
                        Text("Badge").padding(8)
                    }
                """, title: "OverlayBackground.swift")
            }
        }
    }

    // MARK: - ClipShape

    private var clipShapeSection: some View {
        ComponentShowcase(title: "ClipShape", description: "Mask views to any shape", color: lessonColor) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Text("Circle").font(.caption2.bold()).foregroundStyle(.white))

                    LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                        .frame(width: 70, height: 70)
                        .clipShape(Capsule())
                        .overlay(Text("Capsule").font(.caption2.bold()).foregroundStyle(.white))

                    LinearGradient(colors: [.green, .teal], startPoint: .top, endPoint: .bottom)
                        .frame(width: 70, height: 70)
                        .clipShape(StarShape(points: 5))
                        .overlay(Text("Star").font(.caption2.bold()).foregroundStyle(.white))
                }

                CodeSnippetView(code: """
                Image("photo")
                    .clipShape(Circle())
                
                Color.blue
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                """, title: "ClipShape.swift")
            }
        }
    }

    // MARK: - Takeaways

    private var takeaways: some View {
        KeyTakeawaysView(
            takeaways: [
                "Sheet for temporary overlays; fullScreenCover for immersive content",
                "Alert for important messages; ConfirmationDialog for action choices",
                "Gestures provide real-time values — combine with animation for responsive interactions",
                "ViewModifier eliminates code duplication and ensures consistent styling",
                "overlay positions relative to a view; ZStack has its own coordinate space",
                "clipShape masks any view to any Shape — essential for avatars and custom UI",
            ],
            color: lessonColor
        )
    }

    // MARK: - Mini Quiz

    private var miniQuiz: some View {
        MiniQuizView(
            title: "Final Check — You Made It!",
            questions: [
                MiniQuizQuestion(
                    question: "You need a photo editor that takes the full screen. Which presentation should you use?",
                    options: [".sheet", ".fullScreenCover", ".alert", ".overlay"],
                    correctIndex: 1,
                    explanation: "fullScreenCover takes the entire screen, which is ideal for immersive experiences like photo editors, video players, and onboarding flows."
                ),
                MiniQuizQuestion(
                    question: "You use the same .padding().background().cornerRadius().shadow() on 10 views. What's the best fix?",
                    options: ["Copy-paste is fine", "Extract a custom ViewModifier", "Use a ZStack", "Use a container view"],
                    correctIndex: 1,
                    explanation: "A ViewModifier packages reusable modifier chains. Create one, apply with .modifier() or a View extension, and change styling in one place."
                ),
                MiniQuizQuestion(
                    question: "You want a 'NEW' badge on the top-right corner of an image. Which approach is correct?",
                    options: ["ZStack with the badge", ".overlay(alignment: .topTrailing) on the image", "Put both in an HStack", "Use .background()"],
                    correctIndex: 1,
                    explanation: ".overlay(alignment:) positions the badge relative to the image's frame. ZStack works but creates an independent coordinate space. Overlay is more semantically correct here."
                ),
            ],
            color: lessonColor
        )
    }

    // MARK: - Complete

    private var completeButton: some View {
        Button {
            withAnimation(.snappy) {
                appVM.userProgress.markLessonComplete(7)
            }
        } label: {
            Label(
                appVM.userProgress.isLessonComplete(7) ? "All Lessons Complete!" : "Mark as Complete",
                systemImage: appVM.userProgress.isLessonComplete(7) ? "crown.fill" : "circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(appVM.userProgress.isLessonComplete(7) ? AnyShapeStyle(Color.yellow) : AnyShapeStyle(DojoTheme.heroGradient))
            )
            .foregroundStyle(appVM.userProgress.isLessonComplete(7) ? .black : .white)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sheet Content

struct SheetContentView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)

                Text("This is a Sheet!")
                    .font(.title.bold())

                Text("Sheets slide up from the bottom. Use .presentationDetents to control height stops. Users can drag to dismiss.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Dismiss") { dismiss() }
                    .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Sheet Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FullScreenContentView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "rectangle.inset.filled")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)

                Text("Full Screen Cover")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text("Takes over the entire screen. Must be dismissed programmatically — no drag-to-dismiss.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Close") {
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.purple)
            }
        }
    }
}

#Preview {
    NavigationStack {
        Day7AdvancedView()
    }
    .environment(AppViewModel())
}
