import SwiftUI

struct NoteRowView: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title).font(.body)
            if let body = note.body, !body.isEmpty {
                Text(body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Text(note.createdAt, style: .date)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    NoteRowView(note: .init(title: "サンプル", body: "本文", createdAt: Date()))
}
