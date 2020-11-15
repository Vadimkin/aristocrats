//
//  aristocratsfmApp.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI

@main
struct AristocratsfmApp: App {
    let dataController = DataController.shared

    init() {
        UserDefaults.standard.register(defaults: ["ArtworkEnabled": true, "Stream": Streams.Main.name])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(IconNamesObservableObject())
        }
    }
}
