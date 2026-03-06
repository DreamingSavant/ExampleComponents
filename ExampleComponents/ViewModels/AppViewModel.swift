import SwiftUI

@Observable
final class AppViewModel {
    var selectedTab: AppTab = .home
    var userProgress = UserProgress()

    enum AppTab: Int, CaseIterable {
        case home, lessons, challenges, reference, profile

        var title: String {
            switch self {
            case .home: return "Home"
            case .lessons: return "Lessons"
            case .challenges: return "Challenges"
            case .reference: return "Reference"
            case .profile: return "Profile"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .lessons: return "book.fill"
            case .challenges: return "trophy.fill"
            case .reference: return "text.book.closed.fill"
            case .profile: return "person.fill"
            }
        }
    }
}
