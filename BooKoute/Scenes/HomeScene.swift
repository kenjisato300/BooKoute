import SwiftUI

struct HomeScene: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack(path: Binding(
            get: { vm.routeSelection.map { [$0] } ?? [] },
            set: { vm.routeSelection = $0.first }
        )) {
            List {
                ForEach(vm.filteredNotes) { note in
                    Button { vm.routeSelection = note } label: {
                        NoteRowView(note: note)
                    }
                    .swipeActions {
                        Button(role: .destructive) { vm.delete(note) } label: {
                            Label("削除", systemImage: "trash")
                        }
                        Button { vm.startEdit(note) } label: {
                            Label("編集", systemImage: "pencil")
                        }
                    }
                }
                .onDelete { idx in
                    for i in idx { vm.delete(vm.filteredNotes[i]) }
                }
            }
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer, prompt: "検索（タイトル/書名/引用/タグ）")
            .navigationTitle("BooKoute")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { vm.startCreate() } label: {
                        Label("追加", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $vm.isPresentingEditor) {
                if let editing = vm.editingNote {
                    NoteEditorView(note: editing) { vm.finishEditing($0) }
                }
            }
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(
                    note: note,
                    onEdit: { vm.startEdit($0) },
                    onDelete: {
                        vm.delete($0)
                        vm.routeSelection = nil
                    }
                )
            }
        }
    }
}

#Preview { HomeScene() }
