//
//  PendingLabAppointmentsVM.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation
import Combine

class PendingLabAppointmentsVM: ObservableObject {
    @Published var items: [LabAppointment] = []
    @Published var loading = false
    @Published var error: String?

    private let getPending: GetPendingLabAppointments

    init(repo: LabAppointmentsRepository = MockLabAppointmentsRepository()) {
        self.getPending = GetPendingLabAppointments(repo: repo)
    }

    @MainActor
    func load() async {
        loading = true; defer { loading = false }
        do { items = try await getPending() }
        catch { self.error = error.localizedDescription }
    }
}
