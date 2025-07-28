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
    var patientID: Int16? = 0
    var timestamp: Date?
    @Relationship(inverse: \PatientTestResult.toPatient) var toPatientTestResult: [PatientTestResult]?
    public init() {
        
    }
    public init(name: String?, lastName: String?, dateBirth: Date?) {
            self.name = name
            self.lastName = lastName
            self.dateBirth = dateBirth
            self.timestamp = Date()
            self.patientID = Int16.random(in: 1000...9999)
        }
    
}
