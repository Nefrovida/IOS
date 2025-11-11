protocol RiskFormRepositoryProtocol {
    func submitForm(_ form: RiskForm) async throws
}

final class RiskFormRepository: RiskFormRepositoryProtocol {
    func submitForm(_ form: RiskForm) async throws {
        print("Formulario enviado: \(form.nombre)")
    }
}
