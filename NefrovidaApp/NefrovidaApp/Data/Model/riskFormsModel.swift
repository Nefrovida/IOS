import Foundation

struct RiskForm: Identifiable, Codable {
    let id: UUID
    var nombre: String
    var telefono: String
    var genero: String
    var edad: Int
    var estadoNacimiento: String
    var fechaNacimiento: Date
    
    // Preguntas del cuestionario
    var antecedentesFamiliares: Int
    var diabetes: Int
    var glucosaAlta: Int
    var presionAltaTratamiento: Int
    var presionAltaCifras: Int
    var familiarERC: Int
    var analgesicosFrecuentes: Int
    var litiasisRenal: Int
    var sobrepeso: Int
    var refrescos: Int
    var sal: Int
    var fumador: Int
    var alcohol: Int
    var depresion: Int
}
