//
//  ContentView.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var topExpanded: Bool = true
    @State private var viewModel: PatientViewModel
    @State private var showDeleteAlert: Bool = false
    @State private var indexSetToDelete: IndexSet?
    
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text(LocalizedStringKey("scoliometer"))
                        .foregroundStyle(.blue)
                        .padding()
                        .font(.title)
                        .bold()
                    Spacer()
                    Button{
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label: {
                        HStack {
                            Text(LocalizedStringKey("addPatient"))
                            Image(systemName: "plus.circle")
                        }
                    }
                    
                    .padding(.horizontal, 6)
                }
                
                NavigationLink(destination: ScoliometerView(), label: {Text(LocalizedStringKey("takeMeasurements"))
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                })
                .padding(.vertical, 6)
                .padding(.horizontal)
                
                DisclosureGroup(LocalizedStringKey("patientList"), isExpanded: $topExpanded) {
                    List {
                        ForEach(viewModel.patients, id: \.self) { patient in
                            NavigationLink(destination: PatientDetailView(patient: patient)) {
                                HStack {
                                    Text(patient.name ?? "Unknown")
                                    Text(patient.lastName ?? "Unknown")
                                }.padding(.vertical, 6)
                            }
                        }
                        .onDelete{ indexSet in
                            indexSetToDelete = indexSet
                            showDeleteAlert = true
                        }
                        
                    
                
                    }
                    .padding(.top, 6)
                    .listStyle(PlainListStyle())
                    .frame(height: CGFloat(viewModel.patients.count * 60))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .padding(.vertical, 6)
                .padding(.horizontal)
                Spacer()
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text(LocalizedStringKey("removePatient")),
                    message: Text(LocalizedStringKey("alertDeletePatient")),
                    primaryButton: .destructive(Text(LocalizedStringKey("delete"))) {
                        if let indices = indexSetToDelete {
                            viewModel.deletePatients(at: indices)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    init(modelContext: ModelContext) {
        let viewModel = PatientViewModel(modelContext: modelContext)
        _viewModel = .init(initialValue: viewModel)
    }
    
}
    
struct PatientDetailView: View {
    let patient: Patient
    
    var body: some View {
        Text("Szczegóły pacjenta: \(String(describing: patient.name)) \(String(describing: patient.lastName))")
            .font(.title2)
            .padding()
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
    return ContentView(modelContext: container.mainContext)
        .modelContainer(container) // Dodanie kontenera do środowiska
}

