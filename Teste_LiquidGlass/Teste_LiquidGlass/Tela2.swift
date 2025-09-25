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

            VStack {
                Toggle("", isOn: $isDarkMode)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .tint(.blue)
                    .scaleEffect(1.5)
                    .padding(.horizontal, 24)
                    .accessibilityLabel("Dark Mode")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        // Variante local: aplica o tema só nesta tela
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    Tela2()
}
