// Model for a clinical-history question.
// A question can be one of several types (text, number, date, choice, etc.)
struct RiskQuestion: Codable, Identifiable {

    let id: Int

    // Human-readable text describing the question
    // Example: "When was the last time you smoked?"
    let description: String

    // Type of the question (text, number, date, choice)
    let type: String

    // List of associated options.
    // Only applies when `type == "choice"`.
    // Populated dynamically from the API.
    var options: [RiskOption]?

    // Maps JSON keys from the backend to Swift property names.
    enum CodingKeys: String, CodingKey {
        case id = "question_id"   // JSON: question_id → Swift: id
        case description
        case type
        case options
    }
}

// Model for the options associated with a "choice"-type question.
// Example options: "Yes", "No", "I don't know"
struct RiskOption: Codable, Identifiable {

    let id: Int

    // ID of the question this option belongs to
    let questionId: Int

    // Text shown to the user for this option
    // Example: "Yes", "No", "1–2 times per week"
    let description: String

    // Maps JSON keys from the backend to Swift property names.
    enum CodingKeys: String, CodingKey {
        case id = "option_id"          // JSON: option_id → Swift: id
        case questionId = "question_id"
        case description
    }
}
