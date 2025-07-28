//
//  PatientsListView.swift
//  scoliometer
//
//  Created by Filip Skup on 07/07/2025.
//

import SwiftUI
import SwiftData

struct PatientsListView: View {

    @State private var viewModel: PatientViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.patients, id: \.self) { patient in
                HStack{
                    Text(patient.name ?? "Unknown")
                    Text(patient.lastName ?? "Unknown")
                }
            }
            .navigationTitle("Patients")
        }
    }
    init(modelContext: ModelContext) {
        let viewModel = PatientViewModel(modelContext: modelContext)
        _viewModel = .init(initialValue: viewModel)
    }
    
}



    

#Preview {
    // Konfiguracja kontenera w pamięci (tylko do podglądu)
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Patient.self, configurations: config)
    
    // Dodanie przykładowych danych
    let testPatients = [
        Patient(name: "Jan", lastName: "Kowalski", dateBirth: Date()),
        Patient(name: "Anna", lastName: "Nowak", dateBirth: Date().addingTimeInterval(-86400))
    ]
    
    testPatients.forEach { container.mainContext.insert($0) }
    
    // Zwrócenie widoku z przekazanym kontekstem
    return PatientsListView(modelContext: container.mainContext)
        .modelContainer(container) // Dodanie kontenera do środowiska
}
