import Foundation
import Combine

/// Home 画面用の状態＋ロジック
final class HomeViewModel: ObservableObject {

    // 入力
    @Published var query: String = ""

    // 画面に表示するメモ（仮の初期データ）
    @Published private(set) var notes: [Note] = [
        Note(title: "『アルケミスト』 p.23 旅は準備から"),
        Note(title: "『7つの習慣』 第1の習慣 主体性")
    ]

    // 派生値：検索フィルタ後
    var filtered: [Note] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty ? notes : notes.filter { $0.matches(q) }
    }

    // アクション：仮の追加（のちに入力画面に置換）
    func addDummy() {
        let item = Note(title: "新規メモ", body: nil)
        notes.insert(item, at: 0)
    }
}
