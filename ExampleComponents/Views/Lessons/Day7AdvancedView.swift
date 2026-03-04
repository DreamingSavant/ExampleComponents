import SwiftUI

struct Day7AdvancedView: View {
    @Environment(AppViewModel.self) private var appVM

    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var showAlert = false
    @State private var showConfirmation = false
    @State private var progressValue: Double = 0
    @State private var isLoading = false
    @State private var dragOffset = CGSize.zero
    @State private var gestureScale: CGFloat = 1
    @State private var gestureRotation: Angle = .zero
    @State private var longPressActive = false
    @State private var overlayVisible = false

    private let lessonColor = DojoTheme.color(for: "lessonRed")

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header
                sheetSection
                alertSection
                confirmationDialogSection
                progressViewSection
                gestureSection
                viewModifierSection
                overlayBackgroundSection
                clipShapeSection
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
                        .presentationDragIndicator(.visible)
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
                    Button("Cancel", role: .cancel) { }
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
                    .tint(.blue)
                
                ProgressView("Loading...", value: 0.5)
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
                        .onEnded { _ in
                            offset = .zero
                        }
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
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { _ in
                withAnimation(.spring) {
                    dragOffset = .zero
                }
            }
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                gestureScale = value.magnification
            }
            .onEnded { _ in
                withAnimation(.spring) {
                    gestureScale = 1
                }
            }
    }

    private var rotationGesture: some Gesture {
        RotateGesture()
            .onChanged { value in
                gestureRotation = value.rotation
            }
            .onEnded { _ in
                withAnimation(.spring) {
                    gestureRotation = .zero
                }
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

                VStack(alignment: .leading, spacing: 4) {
                    Label("Encapsulate repeated styling patterns", systemImage: "checkmark.circle.fill")
                        .font(.caption).foregroundStyle(.green)
                    Label("Compose modifiers with .modifier() or extensions", systemImage: "checkmark.circle.fill")
                        .font(.caption).foregroundStyle(.green)
                    Label("Can hold their own @State", systemImage: "checkmark.circle.fill")
                        .font(.caption).foregroundStyle(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

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
                            .fill(Color(.systemGray6))
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
                
                Color.green
                    .clipShape(StarShape(points: 5))
                """, title: "ClipShape.swift")
            }
        }
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

                Text("Sheets slide up from the bottom. Use .presentationDetents to control height stops.")
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

                Text("Takes over the entire screen. Must be dismissed programmatically.")
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
