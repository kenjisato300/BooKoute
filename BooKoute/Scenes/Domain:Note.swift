import Foundation

struct Note: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var title: String
    var quote: String
    var author: String?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    // 互換: 旧コードが note.body を使ってもOK
    var body: String {
        get { quote }
        set { quote = newValue }
    }

    init(
        id: UUID = UUID(),
        title: String,
        quote: String,
        author: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.quote = quote
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    static let sample = Note(title: "サンプル", quote: "引用文…", author: "著者名")
}
