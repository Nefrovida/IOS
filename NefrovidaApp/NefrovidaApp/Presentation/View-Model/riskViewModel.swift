import SwiftUI
import Combine

@MainActor
final class RiskFormViewModel: ObservableObject {
    
    let idUser : String
    @Published var questions: [RiskQuestion] = []
    @Published var answers: [Int : String] = [:]

    // Datos generales
    @Published var nombre = ""
    @Published var telefono = ""
    @Published var generoSeleccionado: String? = nil
    @Published var edad = ""
    @Published var estadoNacimientoSeleccionado: String? = nil
    @Published var fechaNacimiento = Date()

    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let submitUseCase: SubmitRiskFormUseCaseProtocol
    private let questionsUseCase: GetRiskQuestionsUseCaseProtocol
    private let optionsUseCase: GetRiskOptionsUseCaseProtocol

    init(
        idUser : String,
        submitUseCase: SubmitRiskFormUseCaseProtocol,
        questionsUseCase: GetRiskQuestionsUseCaseProtocol,
        optionsUseCase: GetRiskOptionsUseCaseProtocol
    ) {
        self.submitUseCase = submitUseCase
        self.questionsUseCase = questionsUseCase
        self.optionsUseCase = optionsUseCase
        self.idUser = idUser
    }

    // VALIDACIÓN
    
    func validate() -> Bool {

        if nombre.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "El nombre es obligatorio."
            return false
        }

        if telefono.count < 8 {
            errorMessage = "El teléfono debe tener al menos 8 dígitos."
            return false
        }

        if generoSeleccionado == nil {
            errorMessage = "Selecciona un género."
            return false
        }

        guard let edadNum = Int(edad), edadNum > 0 && edadNum < 120 else {
            errorMessage = "Ingresa una edad válida."
            return false
        }

        if estadoNacimientoSeleccionado == nil {
            errorMessage = "Selecciona un estado de nacimiento."
            return false
        }

        for q in questions {
            let respuesta = answers[q.id] ?? ""

            if respuesta.isEmpty {
                errorMessage = "Contesta: \(q.description)"
                return false
            }

            if q.type == "number", Int(respuesta) == nil {
                errorMessage = "La respuesta de \(q.description) debe ser numérica."
                return false
            }
        }

        errorMessage = nil
        return true
    }

    //POST FINAL
    func submitForm() async {

        guard validate() else { return }

        guard let genero = generoSeleccionado,
              let estado = estadoNacimientoSeleccionado,
              let edadInt = Int(edad)
        else {
            errorMessage = "Datos inválidos."
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let forms: [String: Any] = [
            "general_info": [
                "nombre": nombre,
                "telefono": telefono,
                "genero": genero,
                "edad": edadInt,
                "estado_nacimiento": estado,
                "fecha_nacimiento": formatter.string(from: fechaNacimiento)
            ],
            "answers": questions.map { q in
                [
                    "question_id": q.id,
                    "answer": answers[q.id] ?? ""
                ]
            }
        ]

        do {
            try await submitUseCase.execute(idUser: idUser, forms: forms)
            successMessage = "Formulario enviado correctamente"
        } catch {
            errorMessage = "Error enviando formulario"
        }
    }

    // GET ALL DATA
    func loadForm() async {
        do {
            var fetchedQuestions = try await questionsUseCase.execute()
            let fetchedOptions = try await optionsUseCase.execute()

            let grouped = Dictionary(grouping: fetchedOptions, by: { $0.questionId })

            for i in 0..<fetchedQuestions.count {
                fetchedQuestions[i].options = grouped[fetchedQuestions[i].id] ?? []
            }

            // ELIMINA preguntas duplicadas (Nombre, Edad, etc.)
            fetchedQuestions.removeAll { q in
                let camposOcultos = [
                    "Nombre", "Teléfono", "Género",
                    "Edad","Estado de nacimiento","Fecha de nacimiento"
                ]
                return camposOcultos.contains(q.description)
            }

            self.questions = fetchedQuestions

            for q in fetchedQuestions {
                answers[q.id] = ""
            }

        } catch {
            print("Error cargando formulario:", error)
        }
    }
}
