import Foundation

// Main Report model conforming to Codable and Identifiable for use in SwiftUI lists
struct Report: Codable, Identifiable {
    // Computed property to satisfy Identifiable protocol, using `result_id` as the unique ID
    var id: Int { result_id }
    
    // Unique identifier for the report result in the database
    let result_id: Int
    
    // Foreign key referencing a specific patient-analysis relation
    let patient_analysis_id: Int
    
    // Date when the report was generated or completed
    let date: String
    
    // Path or URL where the report file is stored
    let path: String
    
    // Optional interpretation or notes added by a doctor or specialist
    let interpretation: String?
    
    // Nested object containing details about the patient’s analysis
    let patient_analysis: PatientAnalysis
}

// Model representing the relationship between a patient and an analysis
struct PatientAnalysis: Codable {
    // ID of the analysis that was assigned to this patient
    let analysis_id: Int
    
    // Optional place where the analysis was performed (e.g., lab, clinic)
    let place: String?
    
    // Status of the analysis (e.g., pending, completed, reviewed)
    let analysis_status: String?
    
    // Date when the analysis was requested
    let analysis_date: String?
    
    // Date when the analysis results were made available
    let results_date: String?
    
    // Nested object with detailed information about the specific analysis
    let analysis: AnalysisDetail
}

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
}
