//
//  NoteCard.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 29/11/25.
//

import SwiftUI

struct NoteCard: View {
    let note: AppointmentNote
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            //──────────── HEADER ─────────────
            Text(note.title.trimmingCharacters(in: .whitespaces))
                .font(.nvSemibold)

            Text(DateFormats.isoTo(note.createdAt, format: "dd/MM/yyyy"))
                .font(.nvBody)
                .foregroundStyle(.secondary)

            //──────────── EXPANDED CONTENT ─────────────
            if expanded {
                VStack(alignment: .leading, spacing: 10) {

                    section(title: "Notas", value: note.content)
                    section(title: "Diagnóstico", value: note.ailments)
                    section(title: "Observaciones", value: note.generalNotes)
                    section(title: "Tratamiento", value: note.prescription)
                }
                .padding(.top, 12)
            }

            //──────────── ACTION BUTTON ─────────────
            Button(action: {
                withAnimation(.spring()) { expanded.toggle() }
            }) {
                Text(expanded ? "Ocultar" : "Ver detalles")
                    .font(.nvBody)
                    .foregroundColor(.nvBrand)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)   // 👉 KEY
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal)
    }

    /// Pretty Section builder
    private func section(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.nvSemibold)
            Text(value)
                .font(.nvBody)
                .foregroundColor(.black.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
