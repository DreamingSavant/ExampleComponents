import SwiftUI

struct ComponentShowcase<Content: View>: View {
    let title: String
    let description: String
    let color: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(color)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Divider()

            content()
                .frame(maxWidth: .infinity)
        }
        .showcaseCard(color: color)
    }
}

#Preview {
    ComponentShowcase(
        title: "Text",
        description: "Display and style text content",
        color: .purple
    ) {
        Text("Hello, World!")
            .font(.title)
            .foregroundStyle(.purple)
    }
    .padding()
}
