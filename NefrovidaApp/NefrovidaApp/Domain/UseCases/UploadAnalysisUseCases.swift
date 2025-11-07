//
//  UploadAnalysisUseCases.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation

struct GetPendingAppointments {
    let repo: AppointmentsRepository
    func callAsFunction() async throws -> [Appointment] { try await repo.fetchPending() }
}

struct RequestPresign {
    let repo: AppointmentsRepository
    func callAsFunction(_ id: Int, mime: String, size: Int) async throws -> URL {
        try await repo.requestPresignedURL(appointmentId: id, mime: mime, size: size)
    }
}

struct PutFileToStorage {
    let repo: AppointmentsRepository
    func callAsFunction(_ url: URL, data: Data, mime: String) async throws {
        try await repo.uploadFile(to: url, data: data, mime: mime)
    }
}

struct ConfirmUpload {
    let repo: AppointmentsRepository
    func callAsFunction(_ id: Int, hashHex: String, uri: URL, size: Int) async throws {
        try await repo.confirmUpload(appointmentId: id, hashHex: hashHex, remoteURI: uri, size: size)
    }
}
