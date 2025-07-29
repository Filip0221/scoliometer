//
//  ContentView.swift
//  scoliometer
//
//  Created by Filip Skup on 03/07/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        VStack{
            HStack{
                Text(LocalizedStringKey("scoliometer"))
                    .foregroundStyle(.blue)
                    .padding()
                    .font(.title)
                    .bold()
                Spacer()
            }
            Spacer()
        }
    }
}
#Preview {
    ContentView()
}
