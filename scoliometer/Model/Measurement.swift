//
//  Measurement.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//
//

import Foundation
import SwiftData


@Model public class Measurement {
    var measurement: Double? = 0
    var toPatientTestResult: PatientTestResult?
    public init() {

    }
    
}
