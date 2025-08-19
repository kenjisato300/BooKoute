import SwiftUI

struct HomeScene: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.filteredNotes.isEmpty {
                    ContentUnavailableView(
                        "メモがありません",
                        systemImage: "note.text",
                        description: Text("右上の＋から作成してください")
                    )
                } else {
                    List {
                        ForEach(vm.filteredNotes) { note in
                            NavigationLink(value: note) {
                                NoteRowView(note: note)
                            }
                            .swipeActions {
                                Button {
                                    vm.presentedEditorNote = note
                                    vm.isPresentingEditor = true
                                } label: { Label("編集", systemImage: "pencil") }

                                Button(role: .destructive) {
                                    if let idx = vm.notes.firstIndex(of: note) {
                                        vm.notes.remove(at: idx)
                                    }
                                } label: { Label("削除", systemImage: "trash") }
                            }
                            .contextMenu {
                                Button("編集") {
                                    vm.presentedEditorNote = note
                                    vm.isPresentingEditor = true
                                }
                                Button(role: .destructive) {
                                    if let idx = vm.notes.firstIndex(of: note) {
                                        vm.notes.remove(at: idx)
                                    }
                                } label: { Text("削除") }
                            }
                        }
                        .onDelete(perform: vm.delete)
                    }
                    .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
            }
            .navigationTitle("BooKoute")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 先に配列へ追加せず、一時的な下書きでエディタだけ開く
                        vm.presentedEditorNote = Note(title: "", quote: "", author: nil)
                        vm.isPresentingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationDestination(for: Note.self) { note in
            NoteDetailView(
                note: note,
                onEdit: {
                    vm.presentedEditorNote = note
                    vm.isPresentingEditor = true
                }
            )
        }
        .sheet(isPresented: $vm.isPresentingEditor) {
            if let target = vm.presentedEditorNote {
                NoteEditorView(
                    note: target,
                    onSave: { updated in
                        vm.update(updated)
                        vm.isPresentingEditor = false
                    },
                    onCancel: {
                        vm.isPresentingEditor = false
                        vm.presentedEditorNote = nil
                    }
                )
            }
        }
    }
}
