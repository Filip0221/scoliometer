//
//  scoliometerApp.swift
//  scoliometer
//
//  Created by Filip Skup on 07/07/2025.
//

import SwiftUI
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock: UIInterfaceOrientationMask = .portrait {
        didSet {
            // Wymuszenie aktualizacji dla starszych wersji iOS
            if #unavailable(iOS 16.0) {
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

@main
struct scoliometerApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            PatientsListView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    init() {
        do {
            container = try ModelContainer(for: Patient.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
