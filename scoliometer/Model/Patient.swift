//
//  Patient.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//
//

import Foundation
import SwiftData


@Model public class Patient {
    var dateBirth: Date?
    var lastName: String?
    var name: String?
    var patientID: Int16?
    var timestamp: Date?
    @Relationship(inverse: \PatientTestResult.toPatient) var toPatientTestResult: [PatientTestResult]?
    public init() {
        
    }
    public init(name: String?, lastName: String?, dateBirth: Date?, patientID: Int16? = nil) {
            self.name = name
            self.lastName = lastName
            self.dateBirth = dateBirth
            self.timestamp = Date()
            self.patientID = patientID
        }
    
}
