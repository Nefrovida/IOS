//
//  SectionCard.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 02/12/25.
//

import SwiftUI

struct SectionCard: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            
            // Icono + Título centrados
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(.nvBrand)
                    .font(.title2)
                
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.nvBrand)
            }
            
            // Texto centrado
            Text(description)
                .font(.body)
                .foregroundColor(Color(.label))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 18)
    }
}
