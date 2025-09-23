//
//  Teste_LiquidGlassApp.swift
//  Teste_LiquidGlass
//
//  Created by Lara Matias Pasquotti on 23/09/25.
//

import SwiftUI
import CoreData

@main
struct Teste_LiquidGlassApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
