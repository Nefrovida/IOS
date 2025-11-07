//
//  PendingAppointmentsVM.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation
import Combine

class PendingAppointmentsVM: ObservableObject {
    @Published var items: [Appointment] = []
    @Published var loading = false
    @Published var error: String?

    private let getPending: GetPendingAppointments

    init(repo: AppointmentsRepository = MockAppointmentsRepository()) {
        self.getPending = GetPendingAppointments(repo: repo)
    }

    @MainActor
    func load() async {
        loading = true; defer { loading = false }
        do { items = try await getPending() }
        catch { self.error = error.localizedDescription }
    }
}
