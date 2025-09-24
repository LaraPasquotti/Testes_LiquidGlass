//
//  Main.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 24/09/25.
//

import SwiftUI

@main
struct Main: App {
    // Lê o mesmo @AppStorage usado no Toggle da Tela2
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            HelloWorld()
                // Aplica o tema globalmente
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
