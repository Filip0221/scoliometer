//
//  PatientViewModel.swift
//  scoliometer
//
//  Created by Filip Skup on 07/07/2025.
//

import SwiftData
import Foundation

@Observable
class PatientViewModel: ObservableObject {
    var modelContext: ModelContext
    var patients = [Patient]()
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<Patient>(sortBy: [SortDescriptor(\.name)])
            patients = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func addPatient() {
        let patient = Patient(name: "Jan", lastName: "Kowalski", dateBirth: Date())
        modelContext.insert(patient)
        do {
            try modelContext.save()
            fetchData() // Odśwież listę po dodaniu
        } catch {
            print("Save failed: \(error.localizedDescription)")
        }
    }
}
