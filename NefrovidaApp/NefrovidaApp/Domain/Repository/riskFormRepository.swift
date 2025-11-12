//
//  riskFormRepository.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 11/11/25.
//
import Foundation

protocol RiskFormRepositoryProtocol {
    func submitForm(_ form: RiskForm) async throws
}
