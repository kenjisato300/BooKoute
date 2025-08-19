import SwiftUI

struct DetailNoteView: View {
    @ObservedObject var vm: HomeViewModel
    let noteID: UUID
    @State private var showEdit = false

    var body: some View {
        Group {
            if let note = vm.note(id: noteID) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(note.title).font(.title.bold())
                        Text(note.body).font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                .navigationTitle("詳細")
                .toolbar {
                    Button("編集") { showEdit = true }
                }
                .sheet(isPresented: $showEdit) {
                    NavigationStack {
                        EditNoteView(note: note) { updated in
                            vm.update(updated)
                        }
                    }
                }
            } else {
                Text("見つかりませんでした")
            }
        }
    }
}
