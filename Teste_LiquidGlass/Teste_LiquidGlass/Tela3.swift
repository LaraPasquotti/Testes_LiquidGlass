import SwiftUI
import PhotosUI

struct Tela3: View {
    @State private var nome: String = ""
    @State private var texto: String = ""
    @State private var isEditing: Bool = false
    @State private var dadosImagem: Data? = nil
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height

            ZStack(alignment: .top) {
                Color("Background")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Imagem no topo
                    Group {
                        if let dadosImagem,
                           let uiImage = UIImage(data: dadosImagem) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .onTapGesture {
                                    if isEditing {
                                        showingImagePicker = true
                                    }
                                }
                        } else {
                            Image("mulher")
                                .resizable()
                                .scaledToFill()
                                .onTapGesture {
                                    if isEditing {
                                        showingImagePicker = true
                                    }
                                }
                        }
                    }
                    .frame(height: height * 0.55)
                    .clipped()
                    .ignoresSafeArea(edges: .top)

                    Spacer(minLength: 0) // garante que os campos encostem
                }

                // Campos de texto
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Nome", text: $nome)
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .disabled(!isEditing)

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $texto)
                            .scrollContentBackground(.hidden)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .frame(minHeight: 140)
                            .disabled(!isEditing)

                        if texto.isEmpty {
                            Text("Sobre você")
                                .foregroundColor(Color(UIColor.placeholderText)) // placeholder igual ao TextField
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .allowsHitTesting(false)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, height * 0.45 - 20) // colado na imagem
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 2)
                    }
                }
            }
            // Picker de imagem
            .photosPicker(isPresented: $showingImagePicker, selection: $selectedItem)
            .onChange(of: selectedItem) { newItem in
                if let newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            dadosImagem = data
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Tela3()
}
