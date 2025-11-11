//
//  LabAppointmentRepository.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

// ¡¡¡MOCK!!!

import Foundation
import CryptoKit

protocol LabAppointmentsRepository {
    func fetchPending() async throws -> [LabAppointment]
    func requestPresignedURL(labappointmentId: Int, mime: String, size: Int) async throws -> URL
    func uploadFile(to presignedURL: URL, data: Data, mime: String) async throws
    func confirmUpload(labappointmentId: Int, hashHex: String, remoteURI: URL, size: Int) async throws
}

class MockLabAppointmentsRepository: LabAppointmentsRepository {
    private var store: [LabAppointment] = [
        .init(id: 1, patientName: "Juan Pérez",  analysisName: "Examen de riñón", date: .now, status: .pendiente),
        .init(id: 2, patientName: "Mario Pérez", analysisName: "Examen de riñón", date: .now, status: .pendiente),
        .init(id: 3, patientName: "Eva Perón",  analysisName: "Examen de riñón", date: .now, status: .conResultados)
    ]

    func fetchPending() async throws -> [LabAppointment] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return store.filter { $0.status == .pendiente }
    }

    func requestPresignedURL(labappointmentId: Int, mime: String, size: Int) async throws -> URL {
        try await Task.sleep(nanoseconds: 200_000_000)
        // URL fake de storage
        return URL(string: "https://storage.nefrovida.mock/upload/\(labappointmentId)")!
    }

    func uploadFile(to presignedURL: URL, data: Data, mime: String) async throws {
        // placeholer del PUT
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    func confirmUpload(labappointmentId: Int, hashHex: String, remoteURI: URL, size: Int) async throws {
        try await Task.sleep(nanoseconds: 150_000_000)
        if let idx = store.firstIndex(where: {$0.id == labappointmentId}) {
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
