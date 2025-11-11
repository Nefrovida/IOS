//
//  CHForms.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//

import SwiftUI

struct CHForms: View {
    var body: some View {
        @State var email = ""

        VStack(spacing: 0) {
           UpBar()

            Title(text: "Formulario de factor de riesgo")
            
            textField(placeholder: "Nombre", text: $email)
            
            
            
            Spacer()

            BottomBar()
        }
    }
}

#Preview {
    CHForms()
}
