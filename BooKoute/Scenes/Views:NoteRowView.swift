import SwiftUI

struct NoteRowView: View {
    let note: Note
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(note.title).font(.headline)
                Spacer()
                Text(note.bookTitle).font(.caption).foregroundStyle(.secondary)
            }
            Text(note.quote)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            if !note.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(note.tags, id: \.self) { t in
                        Text("#\(t)").font(.caption2).padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.1), in: Capsule())
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List { NoteRowView(note: .samples[0]) }
}
