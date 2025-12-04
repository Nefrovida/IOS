//
//  AuthRepositoryImpl.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation
import Alamofire

final class AuthRepositoryD: AuthRepository {
    // The path to log in is defined and the parameters to be sent are defined.
    func login(username: String, password: String) async throws -> LoginEntity {
        let url = "\(AppConfig.apiBaseURL)/auth/login"
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
            // Extract token from cookies and save to UserDefaults for ForumRepository to use
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    // Adjust cookie name matching as needed based on backend
                    if ["token", "access_token", "accessToken", "jwt", "connect.sid"].contains(cookie.name) {
                        // Note: connect.sid is usually a session ID, not a JWT, but if the backend uses sessions, 
                        // we might need to handle that. However, NEFROVIDA_FORUMS.md says "JWT en header".
                        // So we specifically look for a JWT.
                        if cookie.name != "connect.sid" {
                             UserDefaults.standard.set(cookie.value, forKey: "jwt_token")
                        }
                    }
                }
            }
            
            let user = loginResponse.user
            print(user)
            // Return the users data
            return LoginEntity(
                user_id: user.user_id,
                name: user.name,
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
    
    func register(request: RegisterRequest) async throws -> RegisterResponse {
            let url = "\(AppConfig.apiBaseURL)/auth/register"
            
            // Session configuration igual que en login
            let session: Session = {
                let configuration = URLSessionConfiguration.default
                configuration.httpCookieStorage = .shared
                configuration.httpCookieAcceptPolicy = .always
                configuration.httpShouldSetCookies = true
                configuration.timeoutIntervalForRequest = 10
                return Session(configuration: configuration)
            }()
            
            // The POST request is made with all the registration data
            let response = await session.request(
                url,
                method: .post,
                parameters: request,
                encoder: JSONParameterEncoder.default
            )
            .validate(statusCode: 200..<300)
            .serializingDecodable(RegisterResponse.self)
            .response
            
            switch response.result {
            case .success(let registerResponse):
                // Si el backend devuelve cookies de autenticación después del registro
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        if ["token", "access_token", "accessToken", "jwt"].contains(cookie.name) {
                            UserDefaults.standard.set(cookie.value, forKey: "jwt_token")
                        }
                    }
                }
                
                return registerResponse
                
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

final class UserRemoteRepository:UserRepository {
    
    func fetchFirstLogin(for userId: String) async throws -> Bool {
        let endpoint = "\(AppConfig.apiBaseURL)/users/first-login/\(userId)"
        
        do {
            // Devuelve directamente FirstLoginResponse (no DataResponse<>)
            let decoded = try await AF.request(endpoint)
                .validate()
                .serializingDecodable(FirstLoginResponse.self)
                .value
            
            print("estado de first-login:",decoded.isFirstLogin)
            return decoded.isFirstLogin
            
        } catch {
            print("Error fetching first-login:", error)
            throw error
        }
    }
}

final class ForgetPasswordRemoteRepository: ForgetPasswordRepository {
    
    func forgetPassword(userName: String) async throws -> Bool {
        let endpoint = "\(AppConfig.apiBaseURL)/auth/forgot-password"
        let parameters: [String: String] = ["username": userName]
        print(parameters)
        
        print("llego al back")
        do {
            _ = try await AF.request(
                endpoint,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: ["Content-Type": "application/json"]
            )
            .validate()
            .serializingData()
            .value
            
            return true
        } catch {
            print("Error reset password:", error.localizedDescription)
            throw error
        }
    }
}
