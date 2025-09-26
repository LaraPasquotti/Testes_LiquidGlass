//
//  result.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI

struct Tela1: View {
    @Namespace private var namespace

    // Modelo do item
    struct ListItem: Identifiable, Hashable {
        let id: UUID
        var title: String

        init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
        }
    }

    // Estado da lista e seleção múltipla
    @State private var items: [ListItem] = [] // começa vazia
    @State private var selection: Set<ListItem.ID> = []

    // Modo de edição (para mover itens)
    @State private var editMode: EditMode = .inactive

    // Inserção de novo item
    @State private var isInsertingNewItem: Bool = false
    @State private var newItemText: String = ""
    @FocusState private var isNewItemFieldFocused: Bool

    // Renomear item existente (inline)
    @State private var renamingItemID: ListItem.ID?
    @FocusState private var focusedRenameID: ListItem.ID?

    var body: some View {
        ZStack {
            // Fundo azul do Assets
            Color("Background").ignoresSafeArea()

            VStack(spacing: 0) {
                // Lista com apagar, mover e renomear
                List {
                    // Linha de inserção no topo
                    if isInsertingNewItem {
                        Section {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(.green)
                                TextField("Novo item", text: $newItemText)
                                    .textInputAutocapitalization(.sentences)
                                    .disableAutocorrection(false)
                                    .submitLabel(.done)
                                    .focused($isNewItemFieldFocused)
                                    .onSubmit(commitNewItem)
                                Spacer(minLength: 8)
                                Button {
                                    cancelNewItem()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Cancelar novo item")
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    // Itens existentes
                    if editMode == .active {
                        ForEach(items) { item in
                            rowView(for: item)
                                .contentShape(Rectangle())
                                .contextMenu {
                                    Button("Renomear", systemImage: "pencil") {
                                        startRenaming(item)
                                    }
                                    Button("Apagar", systemImage: "trash", role: .destructive) {
                                        deleteItems(withIDs: [item.id])
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button("Renomear") {
                                        startRenaming(item)
                                    }
                                    .tint(.blue)

                                    Button(role: .destructive) {
                                        deleteItems(withIDs: [item.id])
                                    } label: {
                                        Label("Apagar", systemImage: "trash")
                                    }
                                }
                        }
                        .onDelete(perform: deleteAtOffsets)
                        .onMove(perform: move)
                    } else {
                        ForEach(items) { item in
                            rowView(for: item)
                                .contentShape(Rectangle())
                                .contextMenu {
                                    Button("Renomear", systemImage: "pencil") {
                                        startRenaming(item)
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button("Renomear") {
                                        startRenaming(item)
                                    }
                                    .tint(.blue)
                                }
                        }
                        .onMove(perform: move)
                    }
                }
                .animation(.default, value: items)
                .animation(.default, value: isInsertingNewItem)
                .scrollContentBackground(.hidden) // <- fundo da lista fica azul
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                GlassEffectContainer(spacing: 10.0) {
                    HStack(spacing: 10.0) {
                        // Botão: Adicionar
                        Button {
                            toggleInsert()
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 50.0, height: 50.0)
                                .font(.system(size: 20.0))
                        }
                        .buttonStyle(.plain)
                        .glassEffect()
                        .glassEffectUnion(id: "toolbar", namespace: namespace)
                        .accessibilityLabel("Adicionar novo item")

                        // Botão: Editar
                        Button {
                            toggleEditMode()
                        } label: {
                            Image(systemName: editMode == .active ? "checkmark" : "pencil")
                                .frame(width: 50.0, height: 50.0)
                                .font(.system(size: 20.0))
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .buttonStyle(.plain)
                        .glassEffect()
                        .glassEffectUnion(id: "toolbar", namespace: namespace)
                        .accessibilityLabel(editMode == .active ? "Concluir edição" : "Entrar no modo de edição")
                    }
                }
            }
        }
        .navigationTitle("Lista")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.editMode, $editMode)
        .onChange(of: editMode) { newValue in
            if newValue == .inactive {
                renamingItemID = nil
            }
        }
    }

    // MARK: - Row View
    @ViewBuilder
    private func rowView(for item: ListItem) -> some View {
        HStack(spacing: 12) {
            if renamingItemID == item.id,
               let index = items.firstIndex(where: { $0.id == item.id }) {
                TextField("Título", text: Binding(
                    get: { items[index].title },
                    set: { items[index].title = $0 }
                ))
                .textInputAutocapitalization(.sentences)
                .disableAutocorrection(false)
                .submitLabel(.done)
                .focused($focusedRenameID, equals: item.id)
                .onSubmit {
                    finishRenaming()
                }
                .onAppear {
                    focusedRenameID = item.id
                }
            } else {
                Text(item.title)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            // Check sempre visível
            Button {
                toggleSelection(for: item)
            } label: {
                Image(systemName: selection.contains(item.id) ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(selection.contains(item.id) ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                    .accessibilityLabel(selection.contains(item.id) ? "Selecionado" : "Não selecionado")
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleSelection(for: item)
        }
    }

    // MARK: - Seleção manual
    private func toggleSelection(for item: ListItem) {
        if selection.contains(item.id) {
            selection.remove(item.id)
        } else {
            selection.insert(item.id)
        }
    }

    // MARK: - Inserção
    private func toggleInsert() {
        if isInsertingNewItem {
            commitNewItem()
        } else {
            isInsertingNewItem = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isNewItemFieldFocused = true
            }
        }
    }

    private func commitNewItem() {
        let trimmed = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            cancelNewItem()
            return
        }
        let newItem = ListItem(title: trimmed)
        items.insert(newItem, at: 0)
        newItemText = ""
        isInsertingNewItem = false

        // ❌ removido: não marca automaticamente como selecionado
        // selection.insert(newItem.id)

        renamingItemID = nil
        focusedRenameID = nil
    }

    private func cancelNewItem() {
        newItemText = ""
        isInsertingNewItem = false
        isNewItemFieldFocused = false
    }

    // MARK: - Renomear
    private func toggleEditMode() {
        switch editMode {
        case .inactive:
            editMode = .active
        default:
            editMode = .inactive
            renamingItemID = nil
        }
    }

    private func startRenaming(_ item: ListItem) {
        renamingItemID = item.id
        focusedRenameID = item.id
        if editMode == .inactive {
            editMode = .active
        }
    }

    private func finishRenaming() {
        renamingItemID = nil
        focusedRenameID = nil
    }

    // MARK: - Apagar / Mover
    private func deleteAtOffsets(_ offsets: IndexSet) {
        let idsToDelete = offsets.map { items[$0].id }
        deleteItems(withIDs: idsToDelete)
    }

    private func deleteItems(withIDs ids: [ListItem.ID]) {
        items.removeAll { ids.contains($0.id) }
        selection.subtract(ids)
        if renamingItemID.map(ids.contains) == true {
            renamingItemID = nil
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    NavigationStack {
        Tela1()
    }
}
