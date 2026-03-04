import SwiftUI

struct ContentView: View {
    @State private var appVM = AppViewModel()

    var body: some View {
        TabView(selection: Binding(
            get: { appVM.selectedTab },
            set: { appVM.selectedTab = $0 }
        )) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
            }

            Tab("Lessons", systemImage: "book.fill", value: .lessons) {
                LessonListView()
            }

            Tab("Challenges", systemImage: "trophy.fill", value: .challenges) {
                ChallengesView()
            }

            Tab("Profile", systemImage: "person.fill", value: .profile) {
                ProfileView()
            }
        }
        .tint(.purple)
        .environment(appVM)
    }
}

#Preview {
    ContentView()
}
