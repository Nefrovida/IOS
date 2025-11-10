//
//  AppointmentRepository.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

// ¡¡¡MOCK!!!

import Foundation
import CryptoKit

protocol AppointmentsRepository {
    func fetchPending() async throws -> [Appointment]
    func requestPresignedURL(appointmentId: Int, mime: String, size: Int) async throws -> URL
    func uploadFile(to presignedURL: URL, data: Data, mime: String) async throws
    func confirmUpload(appointmentId: Int, hashHex: String, remoteURI: URL, size: Int) async throws
}

class MockAppointmentsRepository: AppointmentsRepository {
    private var store: [Appointment] = [
        .init(id: 1, patientName: "Juan Pérez",  analysisName: "Examen de riñón", date: .now, status: .pendiente),
        .init(id: 2, patientName: "Mario Pérez", analysisName: "Examen de riñón", date: .now, status: .pendiente),
        .init(id: 3, patientName: "Eva Perón",  analysisName: "Examen de riñón", date: .now, status: .conResultados)
    ]

    func fetchPending() async throws -> [Appointment] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return store.filter { $0.status == .pendiente }
    }

    func requestPresignedURL(appointmentId: Int, mime: String, size: Int) async throws -> URL {
        try await Task.sleep(nanoseconds: 200_000_000)
        // URL fake de storage
        return URL(string: "https://storage.nefrovida.mock/upload/\(appointmentId)")!
    }

    func uploadFile(to presignedURL: URL, data: Data, mime: String) async throws {
        // placeholer del PUT
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    func confirmUpload(appointmentId: Int, hashHex: String, remoteURI: URL, size: Int) async throws {
        try await Task.sleep(nanoseconds: 150_000_000)
        if let idx = store.firstIndex(where: {$0.id == appointmentId}) {
            store[idx].status = .conResultados
            store[idx].resultURI = remoteURI
        }
    }
}

extension Data {
    func sha256Hex() -> String {
        let digest = SHA256.hash(data: self)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}
