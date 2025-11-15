//
//  AuthRepositoryImpl.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation
import Alamofire

final class AuthRepositoryD: AuthRepository {
    // The base URL of the server is defined
    private let baseURL = "http://localhost:3001"
    
    // The path to log in is defined and the parameters to be sent are defined.
    func login(username: String, password: String) async throws -> LoginEntity {
        let url = "\(baseURL)/api/auth/login"
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        // Session configuration to allow httpOnly cookies (JWT)
        let session: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.httpCookieStorage = .shared
            configuration.httpCookieAcceptPolicy = .always
            configuration.httpShouldSetCookies = true
            configuration.timeoutIntervalForRequest = 10
            return Session(configuration: configuration)
        }()
        
        // The POST request is made with the username and password to check if the user exists.
        let response = await session.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(LoginResponse.self)
        .response
        
        switch response.result {
        case .success(let loginResponse):
            let user = loginResponse.user
            // Return the users data
            return LoginEntity(
                user_id: user.user_id,
                username: user.username,
                role_id: user.role_id,
                privileges: []
            )
        // If it fails, it displays an error message.
        case .failure(let error):
            if let data = response.data,
               let message = String(data: data, encoding: .utf8) {
                throw NSError(domain: "", code: response.response?.statusCode ?? 500,
                              userInfo: [NSLocalizedDescriptionKey: message])
            }
            throw error
        }
    }
}
