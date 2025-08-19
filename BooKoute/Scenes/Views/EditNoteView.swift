import SwiftUI
enum NoteEditorResult {
    case saved(Note)
    case cancelled
}
struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Note
    let onSave: (Note) -> Void

    init(note: Note, onSave: @escaping (Note) -> Void) {
        _draft = State(initialValue: note)
        self.onSave = onSave
    }

    var body: some View {
        Form {
            TextField("タイトル", text: $draft.title)
            TextEditor(text: $draft.body)
                .frame(minHeight: 240)
        }
        .navigationTitle("編集")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") {
                    onSave(draft)
                    dismiss()
                }
            }
        }
    }
}
