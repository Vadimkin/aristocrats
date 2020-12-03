//
//  aristocratsfmApp.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 25.09.2020.
//

import SwiftUI
import Firebase

@main
struct MainApp {
    static func main() {
        if #available(iOS 14.0, *) {
            AristocratsfmNewUIApp.main()
        } else {
            UIApplicationMain(
                CommandLine.argc,
                CommandLine.unsafeArgv,
                nil,
                NSStringFromClass(AppDelegate.self))
        }
    }
}

@available(iOS 14.0, *)
struct AristocratsfmNewUIApp: App {
    let dataController = DataController.shared

    init() {
        UserDefaults.standard.register(defaults: ["ArtworkEnabled": true, "Stream": Streams.Main.name])

        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(IconNamesObservableObject())
        }
    }
}

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UserDefaults.standard.register(defaults: ["ArtworkEnabled": true, "Stream": Streams.Main.name])
        FirebaseApp.configure()

        return true
    }
}



