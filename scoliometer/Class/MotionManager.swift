//
//  MotionManager.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//

import Foundation
import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var rollDegrees: Double = 0.0
    //@Published var yawDegrees: Double = 0.0
    @Published var pitchDegrees: Double = 0.0
    

    init() {
        startUpdates()
    }

    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion, error == nil else { return }

            // Przeliczanie Roll na stopnie
            let roll = motion.attitude.roll * 180 / .pi
            self?.rollDegrees = roll + 90.0

            // Przeliczanie Yaw na stopnie
            //let yaw = motion.attitude.yaw * 180 / .pi
            //self?.yawDegrees = yaw
            
            // Przeliczanie Pith na stopnie
            let pitch = motion.attitude.pitch * 180 / .pi
            if pitch <= 30 && pitch >= -30{
                self?.pitchDegrees = pitch
            } else if pitch > 30{
                self?.pitchDegrees = 30
            } else {
                self?.pitchDegrees = -30
            }
            
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
extension Color {
    init(hex: String) {
        // Usuwanie symbolu #, jeśli jest obecny
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")

        // Sprawdzanie długości i konwersja HEX na wartość liczbową
        let scanner = Scanner(string: hexSanitized)
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)

        // Wyciąganie poszczególnych wartości RGB
        let red = Double((hexValue & 0xFF0000) >> 16) / 255.0
        let green = Double((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexValue & 0x0000FF) / 255.0

        // Tworzenie koloru
        self.init(red: red, green: green, blue: blue)
    }
}
