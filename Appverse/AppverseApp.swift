//
//  AppverseApp.swift
//  Appverse
//
//  Created by tejas bhuwania on 26/3/21.
//

import SwiftUI

@main
struct AppverseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
