import SwiftUI

// Main view responsible for rendering the Risk Form flow.
// It contains two sections: general user info and dynamic risk questions.
struct RiskFormView: View {

    // User ID received from the previous screen.
    let idUser: String

    // ViewModel that holds all logic and state for the form.
    @StateObject private var vm: RiskFormViewModel

    // Custom initializer to inject dependencies into the ViewModel.
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

    // Controls whether the user is on the General Info screen or the Questions screen.
    @State private var showingQuestions = false

    // Static list of gender options.
    let generos = ["Masculino", "Femenino", "Otro"]

    // Static list of Mexican states for the birth place dropdown.
    let estados = [
        "Aguascalientes","Baja California","Baja California Sur","Campeche",
        "Chiapas","Chihuahua","Ciudad de México","Coahuila","Colima",
        "Durango","Estado de México","Guanajuato","Guerrero","Hidalgo",
        "Jalisco","Michoacán","Morelos","Nayarit","Nuevo León","Oaxaca",
        "Puebla","Querétaro","Quintana Roo","San Luis Potosí","Sinaloa",
        "Sonora","Tabasco","Tamaulipas","Tlaxcala","Veracruz",
        "Yucatán","Zacatecas"
    ]

    // Switches to the dynamic questions section.
    func goToQuestions() {
        withAnimation { showingQuestions = true }
    }

    // Returns to the general information section.
    func goToGeneralInfo() {
        withAnimation { showingQuestions = false }
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()  // Top navigation bar

            ScrollView {
                VStack(spacing: 20) {

                    Title(text: "Cuestionario de Factor de Riesgo")

                    // General info question
                    if !showingQuestions {

                        // User name field.
                        textField(
                            placeholder: "Nombre",
                            text: $vm.nombre,
                            iconName: "xmark"
                        )

                        // Phone number field.
                        textField(
                            placeholder: "Teléfono",
                            text: $vm.telefono,
                            iconName: "xmark"
                        )

                        // Gender selection dropdown.
                        SelectField(
                            label: "Género",
                            options: generos,
                            selection: $vm.generoSeleccionado
                        )

                        // Age field.
                        textField(
                            placeholder: "Edad",
                            text: $vm.edad,
                            iconName: "xmark"
                        )
                        .keyboardType(.numberPad)

                        // Birth state selection dropdown.
                        SelectField(
                            label: "Estado de nacimiento",
                            options: estados,
                            selection: $vm.estadoNacimientoSeleccionado
                        )

                        // Birth date picker.
                        DatePicker(
                            "Fecha de nacimiento",
                            selection: $vm.fechaNacimiento,
                            displayedComponents: .date
                        )
                        .padding(.horizontal)

                        // Button to navigate to the dynamic questions.
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

                        //Risk Question part.
                    } else {

                        ForEach(vm.questions) { q in

                            switch q.type {

                            // Renders a simple text input question.
                            case "text":
                                textField(
                                    placeholder: q.description,
                                    text: Binding(
                                        get: { vm.answers[q.id] ?? "" },
                                        set: { vm.answers[q.id] = $0 }
                                    ),
                                    iconName: "square.and.pencil"
                                )

                            // Renders a number input question.
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

                            // Renders a date input question.
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

                            // Renders a multiple-choice question.
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

                        // Validation errors shown to the user.
                        if let error = vm.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        // Success message shown after submission.
                        if let ok = vm.successMessage {
                            Text(ok)
                                .foregroundColor(.green)
                                .padding(.bottom)
                        }

                        // Button to go back to general info.
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

                        // Button to send all data to backend.
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

                }
                .padding(.top, 20)
            }
            .onAppear {
                // Load questions and options when the view appears.
                Task { await vm.loadForm() }
            }
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }

        // Custom bottom navigation bar.
        BottomBar(idUser: "1212")
    }
}

// Preview for SwiftUI canvas.
#Preview {
    RiskFormView(idUser: "06276f33-a1ca-4c71-a400-8e4fa0ce9ece")
}
