//
//  HelloWorld.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI

struct HelloWorld: View {
    // Controle global do tema
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fundo que reage ao tema e às cores do Assets
                Color("Background").ignoresSafeArea()

                VStack(spacing: 34) {
                    NavigationLink(destination: Tela1()) {
                        Text("Lista")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200, minHeight: 56)
                            .glassEffect(.regular.tint(.blue).interactive())
                    }

                    NavigationLink(destination: Tela2()) {
                        Text("Tema")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200, minHeight: 56)
                            .glassEffect(.regular.tint(.blue).interactive())
                    }

                    NavigationLink(destination: Tela3()) {
                        Text("Click here!")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200, minHeight: 56)
                            .glassEffect(.regular.tint(.blue).interactive())
                    }
                }
                .padding()
            }
        }
        // Aplica o tema no app inteiro (nesta hierarquia)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    HelloWorld()
}
