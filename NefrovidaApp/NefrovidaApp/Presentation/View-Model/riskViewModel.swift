import SwiftUI
import Combine

@MainActor
final class RiskFormViewModel: ObservableObject {
    
    // Current authenticated user ID.
    let idUser: String
    
    // Contains ALL questions returned by backend, including general info.
    @Published var allQuestions: [RiskQuestion] = []
    
    // Contains ONLY dynamic questions (the ones displayed in Section 2).
    @Published var questions: [RiskQuestion] = []
    
    // Dictionary that stores the response for each question (key = question_id).
    @Published var answers: [Int: String] = [:]
    
    // General Information Fields (Section 1)
    @Published var nombre = ""
    @Published var telefono = ""
    @Published var generoSeleccionado: String = ""
    @Published var edad = ""
    @Published var estadoNacimientoSeleccionado: String = ""
    @Published var fechaNacimiento = Date()
    
    // Error and success messages for UI feedback.
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    //Dependencies (Use Cases)
    private let submitUseCase: SubmitRiskFormUseCaseProtocol
    private let questionsUseCase: GetRiskQuestionsUseCaseProtocol
    private let optionsUseCase: GetRiskOptionsUseCaseProtocol
    
    // Dependency injection initializer.
    init(
        idUser: String,
        submitUseCase: SubmitRiskFormUseCaseProtocol,
        questionsUseCase: GetRiskQuestionsUseCaseProtocol,
        optionsUseCase: GetRiskOptionsUseCaseProtocol
    ) {
        self.idUser = idUser
        self.submitUseCase = submitUseCase
        self.questionsUseCase = questionsUseCase
        self.optionsUseCase = optionsUseCase
    }
    
    func getAge() -> Int {
        let birthYear = Calendar.current.component(.year, from: fechaNacimiento)
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - birthYear
    }

    //FORM VALIDATION

    func validate() -> Bool {
        
        // Validate general fields
        if nombre.trimmingCharacters(in: .whitespaces).isEmpty || nombre.contains(where: { $0.isNumber }) {
            errorMessage = "El nombre es obligatorio y no debe contener digítos"
            return false
        }
        if telefono.count < 8 || telefono.contains(where: { $0.isLetter }) {
            errorMessage = "El teléfono debe tener al menos 8 dígitos y no contener letras."
            return false
        }
        if generoSeleccionado.isEmpty {
            errorMessage = "Selecciona un género."
            return false
        }
        if Int(edad) == nil || Int(edad) != getAge() {
            errorMessage = "La edad tiene que coincidir con el año de nacimiento."
            return false
        }
        if estadoNacimientoSeleccionado.isEmpty {
            errorMessage = "Selecciona un estado de nacimiento."
            return false
        }
        
        // Validate dynamic questions
        for q in questions {
            let r = answers[q.id] ?? ""
            
            if r.isEmpty {
                errorMessage = "Contesta: \(q.description)"
                return false
            }
            if q.type == "number", Int(r) == nil {
                errorMessage = "La respuesta de \(q.description) debe ser numérica."
                return false
            }
        }
        
        errorMessage = nil
        return true
    }
    
    // GENERAL INFO MAPPER (Using allQuestions)
    private func mapGeneralInfo() -> [[String: Any]] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Maps question descriptions to the actual values entered by the user.
        let fieldMap: [String: Any] = [
            "Nombre": nombre,
            "Teléfono": telefono,
            "Género": generoSeleccionado,
            "Edad": edad,
            "Estado de nacimiento": estadoNacimientoSeleccionado,
            "Fecha de nacimiento": formatter.string(from: fechaNacimiento)
        ]
        
        // Creates the final JSON array for general info fields.
        return allQuestions.compactMap { q in
            guard let value = fieldMap[q.description] else { return nil }
            return [
                "question_id": q.id,
                "answer": value
            ]
        }
    }

    // SUBMIT FORM
    func submitForm() async {
        
        guard validate() else { return }
        
        // Build JSON for general information.
        let generalInfo = mapGeneralInfo()
        
        // Build JSON for dynamic questions.
        let dynamicAnswers: [[String: Any]] = questions.map { q in
            [
                "question_id": q.id,
                "answer": answers[q.id] ?? ""
            ]
        }
        
        // Final JSON payload combining both arrays.
        let forms: [String: Any] = [
            "answers": generalInfo + dynamicAnswers
        ]
        
        do {
            try await submitUseCase.execute(idUser: idUser, forms: forms)
            successMessage = "Formulario enviado correctamente"
        } catch {
            print("Error:", error)
            errorMessage = "Error enviando formulario"
        }
    }
    
    // LOAD QUESTIONS + OPTIONS FROM BACKEND
    func loadForm() async {
        do {
            // Fetch all questions.
            var fetched = try await questionsUseCase.execute()
            
            // Fetch options for each question.
            let options = try await optionsUseCase.execute()
            
            
            // Group options by question_id.
            let grouped = Dictionary(grouping: options, by: { $0.questionId })
            
            // Assign options to each question.
            for i in 0..<fetched.count {
                fetched[i].options = grouped[fetched[i].id] ?? []
            }
            
            // Keep ALL questions for mapping general info later.
            self.allQuestions = fetched
            
            // Hide general questions from UI but keep them for back-end mapping.
            let hiddenGeneralFields = [
                "Nombre", "Teléfono", "Género", "Fecha del cuestionario",
                "Edad", "Estado de nacimiento", "Fecha de nacimiento"
            ]
            
            self.questions = fetched.filter { !hiddenGeneralFields.contains($0.description) }
            
            // Initialize answer dictionary for all questions.
            for q in fetched {
                answers[q.id] = ""
            }
            
        } catch {
            print("Error cargando formulario:", error)
        }
    }
}
