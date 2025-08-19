import Foundation

struct Note: Identifiable, Hashable, Codable {
    var id: UUID = .init()
    var title: String
    var quote: String
    var bookTitle: String
    var tags: [String] = []
    var createdAt: Date = .init()
    var updatedAt: Date = .init()

    mutating func touch() { updatedAt = .init() }

    // ダミーデータ
    static let samples: [Note] = [
        .init(title: "アウトプット前提で読む", quote: "読書は“使う前提”で読むと定着率が上がる。", bookTitle: "学びを結果に変えるアウトプット大全", tags: ["学習"]),
        .init(title: "二度読む価値", quote: "良書は二度目に真価がわかる。", bookTitle: "本を読む本", tags: ["読書術"])
    ]
}
