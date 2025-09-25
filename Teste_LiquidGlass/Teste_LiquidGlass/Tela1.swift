//
//  result.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI

struct Tela1: View {
    @Namespace private var namespace

    // Modelo simples de item
    struct TodoItem: Identifiable, Equatable {
        let id: UUID = UUID()
        var title: String
    }

    // Estados da lista
    @State private var items: [TodoItem] = []
    @State private var editMode: EditMode = .inactive
    @State private var nextIndex: Int = 1

    var body: some View {
        // Agora temos "+" e "pencil" na toolbar
        let symbolSet: [String] = ["plus", "pencil"]

        ZStack {
            Color("Background").ignoresSafeArea()

            if items.isEmpty {
                // Estado vazio com botão para iniciar a lista
                VStack(spacing: 16) {
                    Button {
                        addItem()
                    } label: {
                        Label("Adicionar item", systemImage: "plus")
                            .padding(.horizontal, 26)
                            .frame(minHeight: 44)
                            .foregroundColor(.white)
                    }
                    .glassEffect(.regular.tint(.blue).interactive())
                }
            } else {
                // Lista com suporte a apagar (swipe) e mover (no modo de edição)
                List {
                    // ForEach com bindings para permitir edição via TextField
                    ForEach($items) { $item in
                        // Mostra TextField no modo edição, e Text quando fora do modo edição
                        Group {
                            if editMode == .active {
                                TextField("Editar item", text: $item.title)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                            } else {
                                Text(item.title)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                // Faz a List respeitar seu fundo customizado
                .scrollContentBackground(.hidden)
                .background(Color("Background"))
                .listRowBackground(Color.clear)
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                GlassEffectContainer(spacing: 10.0) {
                    HStack(spacing: 10.0) {
                        ForEach(symbolSet.indices, id: \.self) { item in
                            Button {
                                // Ações dos botões
                                switch symbolSet[item] {
                                case "plus":
                                    addItem()
                                case "pencil":
                                    toggleEditMode()
                                default:
                                    break
                                }
                            } label: {
                                Image(systemName: symbolSet[item])
                                    .frame(width: 50.0, height: 50.0)
                                    .font(.system(size: 20.0))
                            }
                            .buttonStyle(.plain)
                            .glassEffect()
                            .glassEffectUnion(id: item < 2 ? "1" : "2", namespace: namespace)
                        }
                    }
                }
            }
        }
        // Controla o modo de edição da List (reordenar e mostrar apagar)
        .environment(\.editMode, $editMode)
    }

    // MARK: - Ações da lista

    private func addItem() {
        let new = TodoItem(title: "Item \(nextIndex)")
        nextIndex += 1
        items.append(new)
    }

    private func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }

    private func toggleEditMode() {
        editMode = (editMode == .active) ? .inactive : .active
    }
}

#Preview {
    Tela1()
}
