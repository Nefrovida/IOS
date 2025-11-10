//
//  CHForms.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//

import SwiftUI

struct CHForms: View {
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Profile()
                Spacer()
                NefroVidaLogo()
                Spacer()
                Notification()
            }
            .padding()
            .background(.ultraThinMaterial)
            Title(text: "Formulario de factor de riesgo")
            
            Spacer()

            BottomBar()
        }
    }
}

#Preview {
    CHForms()
}
