//
//  UploadAnalysisUseCases.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation

struct GetPendingLabAppointments {
    let repo: LabAppointmentsRepository
    func callAsFunction() async throws -> [LabAppointment] { try await repo.fetchPending() }
}

struct RequestPresign {
    let repo: LabAppointmentsRepository
    func callAsFunction(_ id: Int, mime: String, size: Int) async throws -> URL {
        try await repo.requestPresignedURL(labappointmentId: id, mime: mime, size: size)
    }
}

struct PutFileToStorage {
    let repo: LabAppointmentsRepository
    func callAsFunction(_ url: URL, data: Data, mime: String) async throws {
        try await repo.uploadFile(to: url, data: data, mime: mime)
    }
}

struct ConfirmUpload {
    let repo: LabAppointmentsRepository
    func callAsFunction(_ id: Int, hashHex: String, uri: URL, size: Int) async throws {
        try await repo.confirmUpload(labappointmentId: id, hashHex: hashHex, remoteURI: uri, size: size)
    }
}
