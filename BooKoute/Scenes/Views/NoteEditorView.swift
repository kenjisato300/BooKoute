import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Note
    let onComplete: (NoteEditorResult) -> Void

    init(note: Note, onComplete: @escaping (NoteEditorResult) -> Void) {
        _draft = State(initialValue: note)
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("タイトル") { TextField("タイトル", text: $draft.title) }
                Section("書名") { TextField("本のタイトル", text: $draft.bookTitle) }
                Section("引用") {
                    TextEditor(text: $draft.quote).frame(minHeight: 160)
                }
                Section("タグ（空白区切り）") {
                    TextField("memo reading …", text: Binding(
                        get: { draft.tags.joined(separator: " ") },
                        set: { draft.tags = $0.split(separator: " ").map(String.init) }
                    ))
                }
            }
            .navigationTitle(draft.title.isEmpty ? "新規メモ" : "メモを編集")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { onComplete(.cancel); dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { onComplete(.save(draft)); dismiss() }
                        .disabled(draft.title.trimmingCharacters(in: .whitespaces).isEmpty ||
                                  draft.quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
