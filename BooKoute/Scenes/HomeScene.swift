import SwiftUI

struct HomeScene: View {
    @State private var query: String = ""
    @State private var notes: [String] = [
        "メモの例：『アルケミスト』 p.23 旅は準備から",
        "メモの例：『7つの習慣』 第1の習慣 主体性"
    ]

    private var filtered: [String] {
        query.isEmpty ? notes : notes.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // 検索欄
                TextField("本・メモを検索", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // リスト
                if filtered.isEmpty {
                    ContentUnavailableView("メモはまだありません",
                                           systemImage: "book.closed",
                                           description: Text("右上の＋で追加できます"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filtered, id: \.self) { note in
                        Text(note)
                            .lineLimit(2)
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("BooKoute")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // ダミー追加（PR用の最小実装）
                        notes.insert("新規メモ \(Date().formatted(date: .omitted, time: .shortened))", at: 0)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("新規メモを追加")
                }
            }
        }
    }
}

#Preview {
    HomeScene()
}
