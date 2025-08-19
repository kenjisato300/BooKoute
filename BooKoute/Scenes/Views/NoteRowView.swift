import SwiftUI

struct NoteRowView: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title.isEmpty ? "（無題）" : note.title)
                .font(.headline)
            if !note.quote.isEmpty {
                Text(note.quote)
                    .lineLimit(2)
                    .font(.subheadline)
            }
            if let a = note.author, !a.isEmpty {
                Text(a)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
