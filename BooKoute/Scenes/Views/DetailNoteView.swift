import SwiftUI
import UIKit

struct DetailNoteView: View {
    @ObservedObject var vm: HomeViewModel
    let noteID: UUID
    @State private var showEdit = false

    @State private var showCopiedAlert = false

    private func shareText(for note: Note) -> String {
        let title = note.title.isEmpty ? "(無題)" : note.title
        let authorLine = (note.author?.isEmpty == false) ? "\n作者: \(note.author!)" : ""
        // 引用があれば優先、無ければ本文
        let content = !note.quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? note.quote
            : note.body
        let contentLine = content.isEmpty ? "" : "\n\n\(content)"
        // 書名 → 作者 → 本文（引用優先）の順
        return "書名: \(title)\(authorLine)\(contentLine)"
    }

    var body: some View {
        Group {
            if let note = vm.notes.first(where: { $0.id == noteID }) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(note.title)
                            .font(.title.bold())
                        if let author = note.author, !author.isEmpty {
                            Text(author)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if !note.quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(note.quote)
                                .font(.body)
                        } else if !note.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(note.body)
                                .font(.body)
                        } else {
                            Text("（本文なし）")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                .navigationTitle("詳細")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        ShareLink(item: shareText(for: note)) {
                            Label("共有", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            UIPasteboard.general.string = shareText(for: note)
                            showCopiedAlert = true
                        } label: {
                            Label("コピー", systemImage: "doc.on.doc")
                        }
                        Button("編集") { showEdit = true }
                    }
                }
                .alert("コピーしました", isPresented: $showCopiedAlert) {
                    Button("OK", role: .cancel) { }
                }
                .sheet(isPresented: $showEdit) {
                    NoteEditorView(
                        note: note,
                        onSave: { updated in
                            vm.update(updated)
                        },
                        onCancel: {}
                    )
                }
            } else {
                Text("見つかりませんでした")
            }
        }
    }
}
