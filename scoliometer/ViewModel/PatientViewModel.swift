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
    
    func addPatient(name: String, lastName: String, dateBirth: Date?, patientID: Int16?) {
        let patient = Patient(
                    name: name,
                    lastName: lastName,
                    dateBirth: dateBirth,
                    patientID: patientID
                )
        modelContext.insert(patient)
        do {
            try modelContext.save()
            fetchData() // Odśwież listę po dodaniu
        } catch {
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    func deletePatients(at offsets: IndexSet) {
        for index in offsets {
            let patient = patients[index]
            modelContext.delete(patient)
        }
        do {
            try modelContext.save()
            fetchData() // Odśwież listę po usunięciu
        } catch {
            print("Delete failed: \(error.localizedDescription)")
        }
    }

}
