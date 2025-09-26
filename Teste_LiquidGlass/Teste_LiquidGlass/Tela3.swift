
//
//  TelaPerfil.swift
//  Teste_LiquidGlass
//
//  Created by Luma Pasquotti on 26/09/25.
//

import SwiftUI

struct Tela3: View {
    @State private var nome: String = ""
    @State private var texto: String = ""
    @State private var isEditing: Bool = true
    @State private var dadosImagem: Data? = nil

    var body: some View {
        ZStack(alignment: .top) {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Imagem no topo
                Group {
                    if let dadosImagem, let uiImage = UIImage(data: dadosImagem) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image("mulher")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.45)
                .clipped()
                .ignoresSafeArea(edges: .top)

                Spacer()
            }

            // Campos colados na imagem
            VStack(alignment: .leading, spacing: 12) {
                TextField("Nome", text: $nome)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .disabled(!isEditing)

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $texto)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .frame(minHeight: 140)
                        .cornerRadius(12)
                        .padding(2)
                        .disabled(!isEditing)

                    if texto.isEmpty {
                        Text("Sobre você")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, UIScreen.main.bounds.height * 0.40) // ajusta altura: campos sobem perto da imagem
        }
    }
}


#Preview {
    Tela3()
}
