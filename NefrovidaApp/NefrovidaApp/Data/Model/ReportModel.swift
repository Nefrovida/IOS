import Foundation

// Report model
// arreglar calendario y reportes
struct Report: Codable, Identifiable {
    var id: Int { resultId }                      // Identifiable: use resultId to identify to use for loops.

    let resultId: Int                            // ID of the result of the analysis.
    let patientAnalysisId: Int                   // Id of the relation of the analysis and patient.
    let date: String                             // Date with the ISO format.
    let path: String                             // Path of the PDF.
    let interpretation: String?                  // Interpretation of the doctor.
    let patientAnalysis: PatientAnalysis         // Object with the analysis info.

    // Map the json with the model.
    enum CodingKeys: String, CodingKey {
        case resultId
        case patientAnalysisId
        case date
        case path
        case interpretation
        case patientAnalysis
    }
}

// Patient Analysis model
struct PatientAnalysis: Codable {
    let patientAnalysisId: Int                   // ID of the patient's analysis record.
    let place: String?                           // Location where the analysis was performed.
    let analysisStatus: String?                  // Current status of the analysis (REQUESTED, COMPLETED, etc.)
    let analysisDate: String?                    // Date when the analysis was requested or performed.
    let resultsDate: String?                     // Date when laboratory results became available.
    let analysis: AnalysisDetail                 // Detailed information about the specific type of analysis.
}

// Analysis Detail model
struct AnalysisDetail: Codable {
    let name: String                             // Name of the analysis (e.g., "Biometría Hemática")
    let description: String?                     // Description of what the analysis consists of
    let previous_requirements: String?           // Requirements the patient must follow before the analysis
    let general_cost: Double?                    // General public cost of the analysis
    let community_cost: Double?                  // Discounted cost for community/registered members
    let image_url: String?                       // Optional illustrative image for the analysis
}

// Flexible Response
struct ReportResponse: Decodable {
    let success: Bool                            // Indicates whether the request was successful
    let message: String                          // Message returned by the backend
    let data: ReportData                         // Can hold either one report or an array of reports

    // Custom decoding to support object OR array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)   // Root-level JSON container
        success = try container.decode(Bool.self, forKey: .success)       // Decode "success" flag
        message = try container.decode(String.self, forKey: .message)     // Decode backend message

        // FIRST attempt to decode the data as an array of reports
        if let array = try? container.decode([Report].self, forKey: .data) {
            data = .list(array)                                           // Store as list
            return
        }

        // IF NOT an array, attempt decoding as a single report object
        if let single = try? container.decode(Report.self, forKey: .data) {
            data = .single(single)                                        // Store as single object
            return
        }

        // IF neither array nor object → throw decoding error
        throw DecodingError.dataCorruptedError(
            forKey: .data,
            in: container,
            debugDescription: "Data was neither a Report nor [Report]"     // Debugging description
        )
    }

    // JSON key mapping
    enum CodingKeys: String, CodingKey {
        case success, message, data
    }

    // Enum representing both response possibilities: one report OR many
    enum ReportData {
        case single(Report)         // One report object
        case list([Report])         // Multiple reports
    }
}
