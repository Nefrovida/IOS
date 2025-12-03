//
//  ProfileRemoteRepository.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation
import Alamofire

final class ProfileRemoteRepository: ProfileRepository {
    
    private func getHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = UserDefaults.standard.string(forKey: "jwt_token") {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        return headers
    }
    
    func getMyProfile() async throws -> ProfileEntity {
        let url = "\(await AppConfig.apiBaseURL)/profile/me"
        
        let response = await AF.request(
            url,
            method: .get,
            headers: getHeaders()
        )
        .validate()
        .serializingDecodable(ProfileDTO.self)
        .response
        
        switch response.result {
        case .success(let dto):
            return ProfileEntity(
                id: dto.id,
                name: dto.name,
                username: dto.username,
                email: dto.email,
                phoneNumber: dto.phoneNumber,
                roleName: dto.roleName
            )
        case .failure(let error):
            if let data = response.data, let message = String(data: data, encoding: .utf8) {
                print("Error getting profile: \(message)")
            }
            throw error
        }
    }
    
    func updateMyProfile(data: UpdateProfileDTO) async throws -> ProfileEntity {
        let url = "\(await AppConfig.apiBaseURL)/profile/me"
        
        let response = await AF.request(
            url,
            method: .put,
            parameters: data,
            encoder: JSONParameterEncoder.default,
            headers: getHeaders()
        )
        .validate()
        .serializingDecodable(ProfileUpdateResponse.self)
        .response
        
        switch response.result {
        case .success(let responseData):
            let dto = responseData.data
            return ProfileEntity(
                id: dto.id,
                name: dto.name,
                username: dto.username,
                email: dto.email,
                phoneNumber: dto.phoneNumber,
                roleName: dto.roleName
            )
        case .failure(let error):
            if let data = response.data, let message = String(data: data, encoding: .utf8) {
                print("Error updating profile: \(message)")
            }
            throw error
        }
    }
    
    func changePassword(data: ChangePasswordDTO) async throws -> Bool {
        let url = "\(await AppConfig.apiBaseURL)/profile/change-password"
        
        let response = await AF.request(
            url,
            method: .put,
            parameters: data,
            encoder: JSONParameterEncoder.default,
            headers: getHeaders()
        )
        .validate()
        .serializingData()
        .response
        
        switch response.result {
        case .success:
            return true
        case .failure(let error):
            if let data = response.data, let message = String(data: data, encoding: .utf8) {
                print("Error changing password: \(message)")
            }
            throw error
        }
    }
}
