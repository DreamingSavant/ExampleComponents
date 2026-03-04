import SwiftUI

extension Color {
    static let dojoAccent = Color(red: 0.55, green: 0.24, blue: 0.86)
}

extension View {
    func sectionHeader() -> some View {
        self
            .font(.title3.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Animation {
    static let snappy: Animation = .spring(response: 0.35, dampingFraction: 0.7)
    static let gentle: Animation = .spring(response: 0.6, dampingFraction: 0.8)
}
