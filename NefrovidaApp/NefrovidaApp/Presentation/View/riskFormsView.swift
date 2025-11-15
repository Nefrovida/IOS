import SwiftUI

struct RiskFormView: View {

    let idUser: String

    @StateObject private var vm = RiskFormViewModel(
        submitUseCase: SubmitRiskFormUseCase(
            repository: RiskFormRepository()
        ),
        questionsUseCase: GetRiskQuestionsUseCase(
            repository: RiskQuestionsRepository()
        ),
        optionsUseCase: GetRiskOptionsUseCases(
            repository: RiskOptionsRepository()
        )
    )

    @State private var showingQuestions = false   // ← NUEVO

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


    // --------------------------------------
    // Funciones para navegar entre secciones
    // --------------------------------------
    func goToQuestions() {
        withAnimation { showingQuestions = true }
    }

    func goToGeneralInfo() {
        withAnimation { showingQuestions = false }
    }

    // --------------------------------------
    var body: some View {
        VStack(spacing: 0) {
            UpBar()

            ScrollView {
                VStack(spacing: 20) {

                    Title(text: "Cuestionario de Factor de Riesgo")

                    // ------------------------------
                    // SECCIÓN 1 — DATOS GENERALES
                    // ------------------------------
                    if !showingQuestions {

                        textField(
                            placeholder: "Nombre",
                            text: $vm.nombre,
                            iconName: "xmark"
                        )

                        textField(
                            placeholder: "Teléfono",
                            text: $vm.telefono,
                            iconName: "xmark"
                        )

                        SelectField(
                            label: "Género",
                            options: generos,
                            selection: $vm.generoSeleccionado
                        )

                        textField(
                            placeholder: "Edad",
                            text: $vm.edad,
                            iconName: "xmark"
                        )
                        .keyboardType(.numberPad)

                        SelectField(
                            label: "Estado de nacimiento",
                            options: estados,
                            selection: $vm.estadoNacimientoSeleccionado
                        )

                        DatePicker(
                            "Fecha de nacimiento",
                            selection: $vm.fechaNacimiento,
                            displayedComponents: .date
                        )
                        .padding(.horizontal)

                        // Botón para avanzar a preguntas dinámicas
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

                    } else {
                        // ------------------------------
                        // SECCIÓN 2 — PREGUNTAS DINÁMICAS
                        // ------------------------------
                        ForEach(vm.questions) { q in

                            switch q.type {

                            case "text":
                                textField(
                                    placeholder: q.description,
                                    text: Binding(
                                        get: { vm.answers[q.id] ?? "" },
                                        set: { vm.answers[q.id] = $0 }
                                    ),
                                    iconName: "square.and.pencil"
                                )

                            case "number":
                                textField(
                                    placeholder: q.description,
                                    text: Binding(
                                        get: { vm.answers[q.id] ?? "" },
                                        set: { vm.answers[q.id] = $0 }
                                    ),
                                    iconName: "number"
                                )
                                .keyboardType(.numberPad)

                            case "date":
                                DatePicker(
                                    q.description,
                                    selection: Binding(
                                        get: {
                                            let f = DateFormatter()
                                            f.dateFormat = "yyyy-MM-dd"
                                            return f.date(from: vm.answers[q.id] ?? "") ?? Date()
                                        },
                                        set: { newDate in
                                            let f = DateFormatter()
                                            f.dateFormat = "yyyy-MM-dd"
                                            vm.answers[q.id] = f.string(from: newDate)
                                        }
                                    ),
                                    displayedComponents: .date
                                )
                                .padding(.horizontal)

                            case "choice":
                                let ops = q.options?.map { $0.description } ?? []
                                questionField(
                                    question: q.description,
                                    type: .choice(options: ops),
                                    answer: Binding(
                                        get: { vm.answers[q.id] ?? "" },
                                        set: { vm.answers[q.id] = $0 }
                                    )
                                )

                            default:
                                EmptyView()
                            }
                        }
                        
                        if let error = vm.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }

                        // Regresar
                        Button {
                            goToGeneralInfo()
                        } label: {
                            Text("Regresar")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        // Enviar formulario
                        Button {
                            Task { await vm.submitForm() }
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

                    if let ok = vm.successMessage {
                        Text(ok)
                            .foregroundColor(.green)
                            .padding(.bottom)
                    }
                }
                .padding(.top, 20)
            }
            .onAppear {
                Task { await vm.loadForm() }
            }
        }
        BottomBar(idUser: "1212")
    }
}

#Preview {
    RiskFormView(idUser: "1212")
}
