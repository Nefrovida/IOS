//
//  LabStatus.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//

import SwiftUI

struct LabStatus: View {
    var status : String
    var body: some View {
        VStack{
            if status == "Pendiente" {
                Label("", systemImage: "flask")
                    .foregroundStyle(Color(.red))
                Text("En espera")
            }
            else if status == "En proceso"{
                Label("", systemImage: "clock.badge.checkmark")
                    .foregroundStyle(Color(.yellow))
                Text("En proceso")
            }
            else if status == "Realizada"{
                Label("", systemImage: "checkmark.circle")
                    .foregroundStyle(Color(.green))
                Text("Realizada")
            }
        }
    }
}

#Preview {
    LabStatus(status: "Realizada")
}
