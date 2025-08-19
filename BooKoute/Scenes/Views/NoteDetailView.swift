import SwiftUI

struct NoteDetailView: View {
    let note: Note
    let onEdit: (Note) -> Void
    let onDelete: (Note) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title).font(.title).bold()

                GroupBox {
                    Text(note.quote).font(.body).padding(.vertical, 4)
                } label: {
                    Label("引用", systemImage: "quote.opening")
                }

                LabeledContent("書名", value: note.bookTitle)

                if !note.tags.isEmpty {
                    LabeledContent("タグ") {
                        Wrap(tags: note.tags)
                    }
                }

                Text("更新: \(note.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("詳細")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("編集", systemImage: "pencil") { onEdit(note) }
                Menu {
                    Button(role: .destructive) { onDelete(note) } label: {
                        Label("削除", systemImage: "trash")
                    }
                } label: { Image(systemName: "ellipsis.circle") }
            }
        }
    }
}

private struct Wrap: View {
    let tags: [String]
    var body: some View {
        FlowLayout(alignment: .leading, spacing: 6) {
            ForEach(tags, id: \.self) { t in
                Text("#\(t)").font(.caption)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
    }
}
