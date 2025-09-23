//
//  HelloWorld.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI

struct HelloWorld: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                        colors: [.blue, .white],
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading
                    )
                    .ignoresSafeArea()
                
                NavigationLink(destination: result()) {
                    Text("Click here!")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .glassEffect(.regular.tint(.blue).interactive())
                }
            }
        }
        
    }
}

#Preview {
    HelloWorld()
}
