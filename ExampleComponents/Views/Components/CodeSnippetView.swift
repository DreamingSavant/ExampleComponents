import SwiftUI

struct CodeSnippetView: View {
    let code: String
    let title: String

    @State private var isCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            codeBody
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }

    private var header: some View {
        HStack {
            HStack(spacing: 6) {
                Circle().fill(.red.opacity(0.8)).frame(width: 10, height: 10)
                Circle().fill(.yellow.opacity(0.8)).frame(width: 10, height: 10)
                Circle().fill(.green.opacity(0.8)).frame(width: 10, height: 10)
            }

            Spacer()

            Text(title)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                #if os(iOS)
                UIPasteboard.general.string = code
                #elseif os(macOS)
                NSPasteboard.general.setString(code, forType: .string)
                #endif
                withAnimation { isCopied = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { isCopied = false }
                }
            } label: {
                Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                    .font(.caption)
                    .foregroundStyle(isCopied ? .green : .secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray5))
    }

    private var codeBody: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.primary)
                .padding(12)
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    CodeSnippetView(
        code: """
        Text("Hello, SwiftUI!")
            .font(.largeTitle)
            .foregroundStyle(.blue)
            .bold()
        """,
        title: "TextExample.swift"
    )
    .padding()
}
