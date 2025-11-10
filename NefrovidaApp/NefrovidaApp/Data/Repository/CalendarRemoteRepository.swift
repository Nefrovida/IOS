// Data/Repository/RemoteAppointmentRepository.swift

import Foundation
import Alamofire

public final class RemoteAppointmentRepository : AppointmentRepository {

    private let baseURL: String

    public init(baseURL: String) {
        self.baseURL = baseURL
    }

    public func fetchAppointments(forDate date: String) async throws -> [Appointment] {
        let endpoint = "\(baseURL)/appointments"
        
        let params: Parameters = [
            "date": date
        ]
        
        let request = AF.request(endpoint, method: .get, parameters: params).validate()
        let result = await request.serializingData().response

        switch result.result {
        case .success(let data):
            do {
                let dtoList = try JSONDecoder().decode([AppointmentDTO].self, from: data)
                return dtoList.map { $0.toDomain() }
            } catch {
                throw error
            }

        case .failure(let error):
            throw error
        }
    }
}
