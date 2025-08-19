import SwiftUI

/// ノートを新規作成／編集するビュー
/// - ポイント
///   - 入力中のテキストは `@State` で独立保持（キャンセルしても元データに影響しない）
///   - 保存時のみコールバックで反映
struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss

    // 編集対象の元データ（保存時にこれをベースに上書きする）
    private let original: Note

    // 画面上の編集中テキスト（キャンセルしても original は変更されない）
    @State private var titleText: String
    @State private var authorText: String
    @State private var bodyText: String

    let onSave: (Note) -> Void
    let onCancel: () -> Void

    init(note: Note, onSave: @escaping (Note) -> Void, onCancel: @escaping () -> Void) {
        self.original = note
        self._titleText = State(initialValue: note.title)
        self._authorText = State(initialValue: note.author ?? "")
        self._bodyText = State(initialValue: note.body)
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("書名") {
                    TextField("書名", text: $titleText)
                        .textInputAutocapitalization(.sentences)
                }
                Section("作者（任意）") {
                    TextField("作者", text: $authorText)
                        .submitLabel(.done)
                }
                Section("本文") {
                    TextEditor(text: $bodyText)
                        .frame(minHeight: 160)
                }
            }
            .navigationTitle("編集")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        onCancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        var edited = original
                        edited.title = titleText
                        edited.body = bodyText
                        let trimmedAuthor = authorText.trimmingCharacters(in: .whitespacesAndNewlines)
                        edited.author = trimmedAuthor.isEmpty ? nil : trimmedAuthor
                        onSave(edited)
                        dismiss()
                    }
                    .disabled(
                        titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                        bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }
}
