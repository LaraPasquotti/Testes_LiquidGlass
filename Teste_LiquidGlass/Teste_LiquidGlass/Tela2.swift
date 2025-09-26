//
//  Tela2.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 24/09/25.
//

import SwiftUI

struct Tela2: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            Form {
                Section {
                    LabeledContent("Tema escuro") {
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Tema")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    // Envolva no NavigationStack para visualizar o título no Preview
    NavigationStack {
        Tela2()
    }
}
