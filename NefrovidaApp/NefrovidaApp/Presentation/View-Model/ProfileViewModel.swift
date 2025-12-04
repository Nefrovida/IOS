//
//  ProfileViewModel.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileEntity?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let getMyProfileUC: GetMyProfileUseCase
    private let updateMyProfileUC: UpdateMyProfileUseCase
    private let changePasswordUC: ChangePasswordUseCase
    
    init(getMyProfileUC: GetMyProfileUseCase = GetMyProfileUseCase(repository: ProfileRemoteRepository()),
         updateMyProfileUC: UpdateMyProfileUseCase = UpdateMyProfileUseCase(repository: ProfileRemoteRepository()),
         changePasswordUC: ChangePasswordUseCase = ChangePasswordUseCase(repository: ProfileRemoteRepository())) {
        self.getMyProfileUC = getMyProfileUC
        self.updateMyProfileUC = updateMyProfileUC
        self.changePasswordUC = changePasswordUC
    }
    
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            self.profile = try await getMyProfileUC.execute()
        } catch {
            self.errorMessage = "Error loading profile: \(error.localizedDescription)"
        }
    }
    
    func updateProfile(name: String, parentLastName: String, maternalLastName: String?, phoneNumber: String, gender: String?, birthday: String?) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }
        
        let dto = UpdateProfileDTO(
            name: name.isEmpty ? nil : name,
            parentLastName: parentLastName.isEmpty ? nil : parentLastName,
            maternalLastName: maternalLastName?.isEmpty == true ? nil : maternalLastName,
            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
            gender: gender?.isEmpty == true ? nil : gender,
            birthday: birthday?.isEmpty == true ? nil : birthday
        )
        
        do {
            self.profile = try await updateMyProfileUC.execute(data: dto)
            self.successMessage = "Profile updated successfully"
        } catch {
            self.errorMessage = "Error updating profile: \(error.localizedDescription)"
        }
    }
    
    func changePassword(new: String, confirm: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }
        
        // Basic validation
        guard new == confirm else {
            self.errorMessage = "New passwords do not match"
            return false
        }
        
        let dto = ChangePasswordDTO(
            newPassword: new,
            confirmNewPassword: confirm
        )
        
        do {
            let success = try await changePasswordUC.execute(data: dto)
            if success {
                self.successMessage = "Password changed successfully"
                return true
            } else {
                self.errorMessage = "Failed to change password"
                return false
            }
        } catch {
            self.errorMessage = "Error changing password: \(error.localizedDescription)"
            return false
        }
    }
}
