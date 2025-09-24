//
//  Tela3.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 24/09/25.
//

import SwiftUI

struct Tela3: View {
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                Text("Hello, World! 💛").font(Font.largeTitle.bold())
            }
        }
    }
}

#Preview {
    Tela3()
}
