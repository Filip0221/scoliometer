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
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    init() {
        do {
            container = try ModelContainer(for: Patient.self)
                        let context = container.mainContext

                        // Sprawdź, czy pacjenci już istnieją
                        let existing = try context.fetch(FetchDescriptor<Patient>())
            if existing.isEmpty {
                let samplePatients = [
                    Patient(name: "Jan", lastName: "Kowalski", dateBirth: Date(timeIntervalSince1970: 0)),
                    Patient(name: "Anna", lastName: "Nowak", dateBirth: Date(timeIntervalSince1970: 123456789)),
                    Patient(name: "Piotr", lastName: "Zieliński", dateBirth: Date(timeIntervalSince1970: 987654321))
                ]
                samplePatients.forEach { context.insert($0) }
                try context.save()
            }
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
