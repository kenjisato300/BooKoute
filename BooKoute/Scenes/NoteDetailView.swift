import SwiftUI

struct NoteDetailView: View {
    let note: Note
    var onEdit: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(note.title.isEmpty ? "（無題）" : note.title)
                    .font(.title).bold()
                if let a = note.author, !a.isEmpty {
                    Text(a)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Divider()
                Text(note.quote.isEmpty ? "（本文なし）" : note.quote)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("詳細")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("編集", action: onEdit)
            }
        }
    }
}
