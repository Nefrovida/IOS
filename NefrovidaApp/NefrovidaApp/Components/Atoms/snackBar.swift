//
//  snackBar.swift
//  NefrovidaApp
//
//  Created by Iván FV on 11/11/25.
//
// Components/Atoms/snackBar.swift

import Foundation
import SwiftUI

struct Snackbar: View {
    @Binding var isPresented: Bool
    let message: String
    var duration: TimeInterval = 2.0

    var body: some View {
        Group {
            if isPresented {
                Text(message)
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.nvLightBlue)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal, 16)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation(.easeInOut) { isPresented = false }
                        }
                    }
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

#Preview {
    @Previewable @State var show = true

    ZStack {
        Snackbar(isPresented: $show,
                 message: "Te has suscrito al foro Pacientes de Nefrovida",
                 duration: 3)
    }
}
