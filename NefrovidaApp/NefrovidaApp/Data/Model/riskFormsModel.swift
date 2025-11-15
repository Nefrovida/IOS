struct RiskQuestion: Codable, Identifiable {
    let id: Int
    let description: String
    let type: String
    var options: [RiskOption]? // se llenará dinámicamente

    enum CodingKeys: String, CodingKey {
        case id = "question_id"
        case description
        case type
        case options
    }
}

struct RiskOption: Codable, Identifiable {
    let id: Int
    let questionId: Int
    let description: String

    enum CodingKeys: String, CodingKey {
        case id = "option_id"
        case questionId = "question_id"
        case description
    }
}
