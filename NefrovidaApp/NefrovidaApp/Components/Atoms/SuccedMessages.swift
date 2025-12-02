//
//  SuccedMessages.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 02/12/25.
//

import SwiftUI

struct SuccessMessage: View {
    let message: String
    let autoDismiss: Bool
    let dismissAfter: Double
    let onDismiss: () -> Void
    
    init(
        message: String,
        autoDismiss: Bool = true,
        dismissAfter: Double = 5.0,
        onDismiss: @escaping () -> Void
    ) {
        self.message = message
        self.autoDismiss = autoDismiss
        self.dismissAfter = dismissAfter
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 14))
            
            Text(message)
                .foregroundColor(.white)
                .fontWeight(.medium)
                .font(.system(size: 14))
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green)
        )
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .transition(.move(edge: .top).combined(with: .opacity))
        .onAppear {
            if autoDismiss {
                DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                    withAnimation {
                        onDismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SuccessMessage(
        message: "Usuario registrado correctamente",
        onDismiss: { print("Dismissed success") }
    )
}
