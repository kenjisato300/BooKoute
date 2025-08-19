import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var body: String
    var createdAt: Date = .init()
    var updatedAt: Date = .init()

    mutating func touch() { updatedAt = .init() }
}
