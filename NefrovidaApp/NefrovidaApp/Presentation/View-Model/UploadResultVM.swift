//
//  UploadResultVM.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation
import UniformTypeIdentifiers
import Combine

class UploadResultVM: ObservableObject {
    @Published var fileName: String = "Ninguno"
    @Published var pickedData: Data?
    @Published var uploading = false
    @Published var success = false
    @Published var error: String?

    let appointment: Appointment
    private let requestPresign: RequestPresign
    private let putFile: PutFileToStorage
    private let confirm: ConfirmUpload

    init(appointment: Appointment, repo: AppointmentsRepository = MockAppointmentsRepository()) {
        self.appointment = appointment
        self.requestPresign = RequestPresign(repo: repo)
        self.putFile = PutFileToStorage(repo: repo)
        self.confirm = ConfirmUpload(repo: repo)
    }
    
    @MainActor
    func pick(data: Data, name: String) {
        self.pickedData = data
        self.fileName = name
    }

    func upload() async {
        guard let data = pickedData else { return }
        uploading = true; defer { uploading = false }
        do {
            let mime = fileName.lowercased().hasSuffix(".png") ? "image/png" : "application/pdf"
            let presigned = try await requestPresign(appointment.id, mime: mime, size: data.count)
            try await putFile(presigned, data: data, mime: mime)
            let hash = data.sha256Hex()
            try await confirm(appointment.id, hashHex: hash, uri: presigned, size: data.count)
            success = true
        } catch { self.error = error.localizedDescription }
    }
}
