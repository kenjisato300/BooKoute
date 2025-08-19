import Foundation

/// 1メモのドメインモデル
struct Note: Identifiable, Equatable {
    let id: UUID
    var title: String
    var body: String?
    var createdAt: Date

    init(id: UUID = UUID(), title: String, body: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }

    /// クエリにヒットするか（タイトル／本文に部分一致・大文字小文字区別なし）
    func matches(_ q: String) -> Bool {
        guard !q.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return true }
        let t = title.localizedCaseInsensitiveContains(q)
        let b = body?.localizedCaseInsensitiveContains(q) ?? false
        return t || b
    }
}
