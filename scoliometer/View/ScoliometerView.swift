//
//  ScoliometerView.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//

import SwiftUI
import UIKit


struct ScoliometerView: View {

    //@State private var showingDeleteConfirmation = false
    @State private var showingDeleteSuccess = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var motion = MotionManager()
    @State private var rolls: [Int] = []
    @State private var showingAlertToManyRolls = false
    @State private var showingRollsSheet = false
    @State private var selectedRollsToDelete: Set<Int> = []


    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    Button(LocalizedStringKey("measure")) {
                        saveMeasure()
                        print(rolls)
                    }
                    .buttonStyle(GrowingButton())
                    .frame(maxWidth: .infinity)
                    
                    VStack{
                        Button(LocalizedStringKey("save")) {
                            print(rolls)
                        }
                        .padding()
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .frame(maxWidth: .infinity)
                        
                        Button(LocalizedStringKey("delete")) {
                            showingRollsSheet = true
                        }
                        .padding()
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .frame(maxWidth: .infinity)
                    }
                    Button(LocalizedStringKey("measure")) {
                        saveMeasure()
                        print(rolls)
                    }
                    .buttonStyle(GrowingButton())
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    Text("Y: \(motion.rollDegrees, specifier: "%.0f")°")
                        .foregroundColor(abs(motion.rollDegrees) > 10 ? .red : .primary)
                    
                    Text("\(motion.pitchDegrees, specifier: "%.0f")°")
                        .font(.title)
                        .padding(.bottom)
                    
                    ZStack {
                        ForEach(Array(stride(from: -30.1, to: 30.1, by: 0.1)), id: \.self) { index in
                            let xOffset = CGFloat(index) * 8
                            let yOffset = -pow(CGFloat(index), 2) / 30
                            
                            Circle()
                                .fill(Color(white: 0.8))
                                .frame(width: 50, height: 50)
                                .offset(x: xOffset, y: yOffset)
                                .animation(.easeInOut, value: index)
                        }
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40, height: 40)
                            .offset(x: CGFloat(motion.pitchDegrees) * 8, y: -pow(CGFloat(motion.pitchDegrees), 2) / 30)
                            .animation(.easeInOut, value: motion.pitchDegrees)
                    }
                }
                .padding()
                Spacer()
            }
            .ignoresSafeArea()
            .onAppear {
                // Dla iOS 16+
                if #available(iOS 16.0, *) {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                } else {
                    // Dla starszych wersji iOS
                    AppDelegate.orientationLock = .landscape
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
            }
            .onDisappear {
                // Dla iOS 16+
                if #available(iOS 16.0, *) {
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                } else {
                    // Dla starszych wersji iOS
                    AppDelegate.orientationLock = .portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }
            }
            .alert(LocalizedStringKey("limit_reached_title"), isPresented: $showingAlertToManyRolls) {
                Button(LocalizedStringKey("ok"), role: .cancel) { }
            } message: {
                Text(LocalizedStringKey("limit_reached_message"))
            }
            .alert(LocalizedStringKey("delete_success_title"), isPresented: $showingDeleteSuccess) {
                Button(LocalizedStringKey("ok"), role: .cancel) { }
            } message: {
                Text(LocalizedStringKey("delete_success_message"))
            }
            .sheet(isPresented: $showingRollsSheet) {
                NavigationView {
                    List {
                        ForEach(Array(rolls.enumerated()), id: \.offset) { index, value in
                            HStack {
                                Text("Pomiar \(index + 1): \(value)°")
                                Spacer()
                                if selectedRollsToDelete.contains(index) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedRollsToDelete.contains(index) {
                                    selectedRollsToDelete.remove(index)
                                } else {
                                    selectedRollsToDelete.insert(index)
                                }
                            }
                        }
                    }
                    .navigationTitle("Wybierz pomiary")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Anuluj") {
                                selectedRollsToDelete.removeAll()
                                showingRollsSheet = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Usuń") {
                                for index in selectedRollsToDelete.sorted(by: >) {
                                    rolls.remove(at: index)
                                }
                                selectedRollsToDelete.removeAll()
                                showingRollsSheet = false
                                showingDeleteSuccess = true
                            }
                            .disabled(selectedRollsToDelete.isEmpty)
                        }
                    }
                }
            }
                
            
        }
        .ignoresSafeArea()
    }
    private func saveMeasure() {
        if rolls.count >= 20 {
            showingAlertToManyRolls = true
        } else {
            rolls.append(Int(motion.rollDegrees))
        }
    }
    private func deleteMeasures(){
        rolls.removeAll()
    }
        
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


#Preview {
    ScoliometerView()
}
