import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // 入出力
    @Published var searchText: String = ""
    @Published private(set) var notes: [Note] = Note.samples
    @Published var routeSelection: Note?        // 詳細へ
    @Published var isPresentingEditor: Bool = false
    @Published var editingNote: Note? = nil     // nil なら新規

    // 検索結果
    var filteredNotes: [Note] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return notesSorted }
        let key = searchText.lowercased()
        return notesSorted.filter {
            $0.title.lowercased().contains(key) ||
            $0.quote.lowercased().contains(key) ||
            $0.bookTitle.lowercased().contains(key) ||
            $0.tags.joined(separator: " ").lowercased().contains(key)
        }
    }

    private var notesSorted: [Note] {
        notes.sorted { $0.updatedAt > $1.updatedAt }
    }

    // CRUD
    func add(_ note: Note) {
        var n = note; n.touch()
        notes.insert(n, at: 0)
    }

    func update(_ note: Note) {
        guard let idx = notes.firstIndex(where: {$0.id == note.id}) else { return }
        var n = note; n.touch()
        notes[idx] = n
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }

    // 画面遷移ユーティリティ
    func startCreate() {
        editingNote = Note(title: "", quote: "", bookTitle: "", tags: [])
        isPresentingEditor = true
    }

    func startEdit(_ note: Note) {
        editingNote = note
        isPresentingEditor = true
    }

    func finishEditing(_ result: NoteEditorResult) {
        switch result {
        case .cancel: break
        case .save(let note):
            if notes.contains(where: {$0.id == note.id}) { update(note) } else { add(note) }
        }
        isPresentingEditor = false
        editingNote = nil
    }
}

// Editor の戻り値
enum NoteEditorResult {
    case cancel
    case save(Note)
}
