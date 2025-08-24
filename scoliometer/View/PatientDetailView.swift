//
//  PatientDetailView.swift
//  scoliometer
//
//  Created by Filip Skup on 13/08/2025.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: Patient
    
    var body: some View {
        let nameText = "\(NSLocalizedString("patientName", comment: "")): \(patient.name != "" ? String(patient.name!) : NSLocalizedString("unknown", comment: ""))"
        let lastNameText = "\(NSLocalizedString("patientLastName", comment: "")): \(patient.lastName != "" ? String(patient.lastName!) : NSLocalizedString("unknown", comment: ""))"
        let birthDateText = "\(NSLocalizedString("patientBirthDate", comment: "")): \(formatDate(patient.dateBirth))"
        let idText = "\(NSLocalizedString("patientID", comment: "")): \(patient.patientID != nil ? String(patient.patientID!) : NSLocalizedString("unknown", comment: ""))"


        
        VStack{
            VStack{
                HStack{
                    Text(LocalizedStringKey("patientDetails"))
                        .font(.title)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        .padding(.top, 4)
                        .foregroundStyle(.blue)
                    Spacer()
                }
                VStack {
                    Text(nameText)
                    Text(lastNameText)
                    Text(birthDateText)
                    Text(idText)
                }

                .font(.title2)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(
                Color.gray.opacity(0.1)
                    .cornerRadius(8)
            )
            .padding(.vertical, 6)
            .padding(.horizontal)
            Spacer()
        }
        
    }
    private func formatDate(_ date: Date?) -> String {
            guard let date = date else { return NSLocalizedString("unknown", comment: "") }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
}


#Preview {

    
    PatientDetailView(patient: Patient(name: "Filip", lastName: "Skup", dateBirth: nil))
}
