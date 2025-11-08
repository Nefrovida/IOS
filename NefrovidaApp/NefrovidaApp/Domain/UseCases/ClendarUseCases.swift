//
//  ClendarUseCases.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Domain/UseCases/GetAppointmentsForDayUseCase.swift
import Foundation

public final class GetAppointmentsForDayUseCase {
    private let repository: AppointmentRepository
    public init(repository: AppointmentRepository) { self.repository = repository }

    public func execute(date: String) async throws -> [Appointment] {
        try await repository.fetchAppointments(forDate: date)
    }
}
