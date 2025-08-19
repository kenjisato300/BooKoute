import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet { save() }
    }
    @Published var searchText: String = ""

    // エディタ表示制御
    @Published var presentedEditorNote: Note?
    @Published var isPresentingEditor: Bool = false

    private let storeURL: URL

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.storeURL = dir.appendingPathComponent("notes.json")
        load()
    }

    var filteredNotes: [Note] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let base = notes.sorted { $0.updatedAt > $1.updatedAt }
        guard !q.isEmpty else { return base }
        return base.filter {
            $0.title.localizedCaseInsensitiveContains(q) ||
            $0.quote.localizedCaseInsensitiveContains(q) ||
            ($0.author?.localizedCaseInsensitiveContains(q) ?? false)
        }
    }

    // MARK: - Actions
    func addEmptyNote() {
        // 新規はまずドラフトとしてエディタを開く（配列にはまだ入れない）
        presentedEditorNote = Note(title: "", quote: "", author: nil)
        isPresentingEditor = true
    }

    func update(_ note: Note) {
        var n = note
        n.updatedAt = Date()
        if let idx = notes.firstIndex(where: { $0.id == n.id }) {
            notes[idx] = n
        } else {
            // まだ配列に無ければ新規として先頭に追加
            notes.insert(n, at: 0)
        }
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }

    // MARK: - Persistence
    private func load() {
        do {
            let data = try Data(contentsOf: storeURL)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: storeURL, options: .atomic)
        } catch {
            print("Save failed:", error)
        }
    }
}
