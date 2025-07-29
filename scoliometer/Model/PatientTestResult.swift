//
//  PatientTestResult.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//
//

import Foundation
import SwiftData


@Model public class PatientTestResult {
    var date: Date?
    var result: String?
    //var toMeasurement: [Measurement]?
    var measurment: [Double]?
    var toPatient: Patient?
    public init() {

    }
    
}
