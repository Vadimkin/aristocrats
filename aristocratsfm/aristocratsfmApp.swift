//
//  aristocratsfmApp.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI

@main
struct aristocratsfmApp: App {
    let dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
