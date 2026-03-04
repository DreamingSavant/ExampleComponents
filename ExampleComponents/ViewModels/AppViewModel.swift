import SwiftUI

@Observable
final class AppViewModel {
    var selectedTab: AppTab = .home
    var userProgress = UserProgress()
    var showOnboarding: Bool = true

    enum AppTab: Int, CaseIterable {
        case home, lessons, challenges, profile

        var title: String {
            switch self {
            case .home: return "Home"
            case .lessons: return "Lessons"
            case .challenges: return "Challenges"
            case .profile: return "Profile"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .lessons: return "book.fill"
            case .challenges: return "trophy.fill"
            case .profile: return "person.fill"
            }
        }
    }
}
