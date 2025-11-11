import SwiftUI
import Combine

@MainActor
final class RiskFormViewModel: ObservableObject {
    @Published var nombre = ""
    @Published var telefono = ""
    @Published var generoSeleccionado: String? = nil
    @Published var edad = ""
    @Published var estadoNacimiento = ""
    @Published var fechaNacimiento = Date()
    
    // Preguntas
    @Published var antecedentesFamiliares = ""
    @Published var diabetes = ""
    @Published var glucosaAlta = ""
    @Published var presionAltaTratamiento = ""
    @Published var presionAltaCifras = ""
    @Published var familiarERC = ""
    @Published var analgesicosFrecuentes = ""
    @Published var litiasisRenal = ""
    @Published var sobrepeso = ""
    @Published var refrescos = ""
    @Published var sal = ""
    @Published var fumador = ""
    @Published var alcohol = ""
    @Published var depresion = ""
    
    private let useCase: SubmitRiskFormUseCaseProtocol
    
    init(useCase: SubmitRiskFormUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func submit() async {
        guard let genero = generoSeleccionado,
              let edadInt = Int(edad) else { return }
        
        let form = RiskForm(
            id: UUID(),
            nombre: nombre,
            telefono: telefono,
            genero: genero,
            edad: edadInt,
            estadoNacimiento: estadoNacimiento,
            fechaNacimiento: fechaNacimiento,
            antecedentesFamiliares: Int(antecedentesFamiliares) ?? 0,
            diabetes: Int(diabetes) ?? 0,
            glucosaAlta: Int(glucosaAlta) ?? 0,
            presionAltaTratamiento: Int(presionAltaTratamiento) ?? 0,
            presionAltaCifras: Int(presionAltaCifras) ?? 0,
            familiarERC: Int(familiarERC) ?? 0,
            analgesicosFrecuentes: Int(analgesicosFrecuentes) ?? 0,
            litiasisRenal: Int(litiasisRenal) ?? 0,
            sobrepeso: Int(sobrepeso) ?? 0,
            refrescos: Int(refrescos) ?? 0,
            sal: Int(sal) ?? 0,
            fumador: Int(fumador) ?? 0,
            alcohol: Int(alcohol) ?? 0,
            depresion: Int(depresion) ?? 0
        )
        
        do {
            try await useCase.execute(form: form)
        } catch {
            print("Error al enviar: \(error)")
        }
    }
}
