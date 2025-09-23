//
//  result.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI

struct result: View {
    @Namespace private var namespace
    private let symbolSet: [String] = ["pencil", "trash.fill"]

    var body: some View {
        VStack {
            Text("Olá")
                .font(Font.largeTitle.bold())
        }
        .navigationTitle("Resultado")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            // Use trailing; mude para `.bottomBar` se quiser na barra inferior
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                GlassEffectContainer(spacing: 15.0) {
                    HStack(spacing: 15.0) {
                        ForEach(symbolSet.indices, id: \.self) { item in
                            Button {
                                // ação do botão (preencha conforme necessário)
                            } label: {
                                Image(systemName: symbolSet[item])
                                    .frame(width: 44.0, height: 44.0)
                                    .font(.system(size: 28))
                                    .glassEffect()
                                    .glassEffectUnion(id: item < 2 ? "1" : "2", namespace: namespace)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        result()
    }
}
