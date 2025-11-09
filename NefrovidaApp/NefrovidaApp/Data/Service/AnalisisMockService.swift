//  AnalisisMockService.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Mock implementation of AnalisisServiceProtocol for local development without backend.

import Foundation

struct AnalisisMockService: AnalisisServiceProtocol {
    private var storage: [Analisis] = [
        Analisis(id: "1", titulo: "Biometría Hemática (BM)", fecha: Date(), tipo: "Laboratorio"),
        Analisis(id: "2", titulo: "Química Sanguínea", fecha: Date().addingTimeInterval(-86_400 * 3), tipo: "Laboratorio"),
        Analisis(id: "3", titulo: "General de Orina", fecha: Date().addingTimeInterval(-86_400 * 10), tipo: "Laboratorio")
    ]

    func fetchAnalisis() async throws -> [Analisis] {
        // Simula pequeña latencia
        try? await Task.sleep(nanoseconds: 150_000_000)
        return storage.sorted { $0.fecha > $1.fecha }
    }

    func deleteAnalisis(id: String) async throws {
        // Simula pequeña latencia
        try? await Task.sleep(nanoseconds: 120_000_000)
        // No devolvemos error para simplificar; en un mock real podrías validar el ID.
    }
}
