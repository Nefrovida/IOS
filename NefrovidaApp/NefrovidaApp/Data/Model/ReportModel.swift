import Foundation

struct Report: Codable, Identifiable {
    var id: Int { result_id }
    
    let result_id: Int
    let patient_analysis_id: Int
    let date: String
    let path: String
    let interpretation: String?
    let patient_analysis: PatientAnalysis
}

struct PatientAnalysis: Codable {
    let analysis_id: Int
    let place: String?
    let analysis_status: String?
    let analysis_date: String?
    let results_date: String?
    let analysis: AnalysisDetail
}

struct AnalysisDetail: Codable {
    let name: String
    let description: String?
    let previous_requirements: String?
    let general_cost: Double?
    let community_cost: Double?
    let image_url: String?
}
