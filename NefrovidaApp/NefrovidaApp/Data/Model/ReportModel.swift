import Foundation

// ------------------------------------------------------------
// MARK: - Report
// ------------------------------------------------------------

// Main Report model conforming to Codable and Identifiable for use in SwiftUI lists
struct Report: Codable, Identifiable {
    // Computed property to satisfy Identifiable protocol, using `resultId` as the unique ID
    var id: Int { resultId }
    
    // Unique identifier for the report result in the database
    let resultId: Int
    
    // Foreign key referencing a specific patient-analysis relation
    let patientAnalysisId: Int
    
    // Date when the report was generated or completed
    let date: String
    
    // Path or URL where the report file is stored
    let path: String
    
    // Optional interpretation or notes added by a doctor or specialist
    let interpretation: String?
    
    // Nested object containing details about the patient’s analysis
    let patientAnalysis: PatientAnalysis

    enum CodingKeys: String, CodingKey {
        case resultId
        case patientAnalysisId
        case date
        case path
        case interpretation
        case patientAnalysis
    }
}

// ------------------------------------------------------------
// MARK: - PatientAnalysis
// ------------------------------------------------------------

// Model representing the relationship between a patient and an analysis
struct PatientAnalysis: Codable {
    // ID of the analysis that was assigned to this patient
    let patientAnalysisId: Int
    
    // Optional place where the analysis was performed (e.g., lab, clinic)
    let place: String?
    
    // Status of the analysis (e.g., pending, completed, reviewed)
    let analysisStatus: String?
    
    // Date when the analysis was requested
    let analysisDate: String?
    
    // Date when the analysis results were made available
    let resultsDate: String?
    
    // Nested object with detailed information about the specific analysis
    let analysis: AnalysisDetail

    enum CodingKeys: String, CodingKey {
        case patientAnalysisId
        case place
        case analysisStatus
        case analysisDate
        case resultsDate
        case analysis
    }
}

// ------------------------------------------------------------
// MARK: - AnalysisDetail
// ------------------------------------------------------------

// Model containing detailed information about a specific type of analysis
struct AnalysisDetail: Codable {
    // Name of the analysis (e.g., "Biometría Hemática")
    let name: String
    
    // Optional description explaining what the analysis consists of
    let description: String?
    
    // Optional requirements that the patient needs to fulfill before taking the analysis
    let previous_requirements: String?
    
    // Cost of the analysis for external (general) patients
    let general_cost: Double?
    
    // Cost of the analysis for community (registered) patients
    let community_cost: Double?
    
    // Optional URL or path to an image related to the analysis type
    let image_url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case previous_requirements
        case general_cost
        case community_cost
        case image_url
    }
}

// ------------------------------------------------------------
// MARK: - API Response Wrapper
// ------------------------------------------------------------

struct ReportResponse: Codable {
    let success: Bool
    let message: String
    let data: Report
}
