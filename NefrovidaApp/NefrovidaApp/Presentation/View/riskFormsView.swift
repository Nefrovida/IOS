import SwiftUI

struct RiskFormView: View {

    let idUser: String
    @StateObject private var vm: RiskFormViewModel

    // 👇 Alert de éxito
    @State private var showSuccessAlert = false
    // 👇 Disparador para ir al calendario
    @State private var goToCalendar = false
    
    @Environment(\.dismiss) var dismiss

    init(idUser: String) {
        _vm = StateObject(wrappedValue:
            RiskFormViewModel(
                idUser: idUser,
                submitUseCase: SubmitRiskFormUseCase(repository: RiskFormRepository()),
                questionsUseCase: GetRiskQuestionsUseCase(repository: RiskQuestionsRepository()),
                optionsUseCase: GetRiskOptionsUseCases(repository: RiskOptionsRepository())
            )
        )
        self.idUser = idUser
    }

    @State private var showingQuestions = false

    let generos = ["Masculino", "Femenino", "Otro"]

    let estados = [
        "Aguascalientes","Baja California","Baja California Sur","Campeche",
        "Chiapas","Chihuahua","Ciudad de México","Coahuila","Colima",
        "Durango","Estado de México","Guanajuato","Guerrero","Hidalgo",
        "Jalisco","Michoacán","Morelos","Nayarit","Nuevo León","Oaxaca",
        "Puebla","Querétaro","Quintana Roo","San Luis Potosí","Sinaloa",
        "Sonora","Tabasco","Tamaulipas","Tlaxcala","Veracruz",
        "Yucatán","Zacatecas"
    ]

    func goToQuestions() { withAnimation { showingQuestions = true } }
    func goToGeneralInfo() { withAnimation { showingQuestions = false } }

    var body: some View {
        VStack(spacing: 0) {

            ScrollView {
                VStack(spacing: 20) {

                    Title(text: "Cuestionario de Factor de Riesgo")

                    // 📌 DATOS GENERALES
                    if !showingQuestions {
                        textField(placeholder: "Nombre", text: $vm.nombre, iconName: "xmark")

                        textField(placeholder: "Teléfono", text: $vm.telefono, iconName: "xmark")

                        nefroSelect(placeholder: "Género", selection: $vm.generoSeleccionado, options: generos)

                        textField(placeholder: "Edad", text: $vm.edad, iconName: "xmark")
                            .keyboardType(.numberPad)

                        nefroSelect(placeholder: "Estado de nacimiento", selection: $vm.estadoNacimientoSeleccionado, options: estados)

                        DatePicker("Fecha de nacimiento", selection: $vm.fechaNacimiento, displayedComponents: .date)
                            .padding(.horizontal)

                        Button {
                            goToQuestions()
                        } label: {
                            Text("Continuar con preguntas")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)

                    // 📌 PREGUNTAS DINÁMICAS
                    } else {

                        ForEach(vm.questions) { q in
                            switch q.type {
                            case "text":
                                textField(placeholder: q.description,
                                          text: Binding(get: { vm.answers[q.id] ?? "" },
                                                        set: { vm.answers[q.id] = $0 }),
                                          iconName: "square.and.pencil")
                            case "number":
                                textField(placeholder: q.description,
                                          text: Binding(get: { vm.answers[q.id] ?? "" },
                                                        set: { vm.answers[q.id] = $0 }),
                                          iconName: "number")
                                .keyboardType(.numberPad)
                            case "choice", "select":
                                questionField(question: q.description,
                                              type: .choice(options: q.options?.map { $0.description } ?? []),
                                              answer: Binding(get: { vm.answers[q.id] ?? "" },
                                                              set: { vm.answers[q.id] = $0 }))
                            default:
                                EmptyView()
                            }
                        }

                        if let error = vm.errorMessage {
                            Text(error).foregroundColor(.red).padding(.horizontal)
                        }

                        Button {
                            goToGeneralInfo()
                        } label: {
                            Text("Regresar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        Button {
                            Task {
                                await vm.submitForm()
                                if vm.successMessage != nil {
                                    showSuccessAlert = true
                                }
                            }
                        } label: {
                            Text("Enviar formulario")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
            }
            .onAppear {
                Task { await vm.loadForm() }
            }
        }
        // ... (todo tu código igual)

        .onTapGesture { UIApplication.shared.hideKeyboard() }

        // 🆕 FULL SCREEN (no se puede volver atrás al formulario)
        .fullScreenCover(isPresented: $goToCalendar) {
            CalendarView(idUser: idUser, fromRiskForm: true)
        }

        // 🟢 Alert de éxito
        .alert("Formulario enviado", isPresented: $showSuccessAlert) {
            Button("Aceptar") { goToCalendar = true }
        } message: {
            Text(vm.successMessage ?? "Tu cuestionario se ha enviado correctamente.")
        }
    }
}
