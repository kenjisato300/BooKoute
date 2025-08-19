import SwiftUI

struct HomeScene: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // リスト or 空表示
                if vm.filtered.isEmpty {
                    ContentUnavailableView(
                        "メモはまだありません",
                        systemImage: "book.closed",
                        description: Text("右上の＋で追加できます")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(vm.filtered) { note in
                        NoteRowView(note: note)
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("BooKoute")
            // 🔍 検索バー（iOS標準UI）
            .searchable(
                text: $vm.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "本・メモを検索"
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { vm.addDummy() }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("メモを追加")
                }
            }
        }
    }
}

#Preview { HomeScene() }
