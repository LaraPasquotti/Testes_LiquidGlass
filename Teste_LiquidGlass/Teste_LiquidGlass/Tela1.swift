//
//  result.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI

struct Tela1: View {
    @Namespace private var namespace

    var body: some View {
        let symbolSet: [String] = ["pencil", "trash.fill"]

        ZStack {
            Color("Background").ignoresSafeArea()

            VStack {
                Text("Hello, World! 💚")
                    .font(.largeTitle.bold())
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                GlassEffectContainer(spacing: 10.0) {
                    HStack(spacing: 10.0) {
                        ForEach(symbolSet.indices, id: \.self) { item in
                            Button {
                                // Ação do botão correspondente
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
    }
}

#Preview {
    Tela1()
}
