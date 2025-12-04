import SwiftUI

struct RiskFormView: View {
    let idUser: String
    
    @StateObject private var vm: RiskFormViewModel
    
    @State private var showSuccessAlert = false
    @State private var showingQuestions = false
    
    @Environment(\.dismiss) var dismiss   // 👈 Para cerrar vistas hacia atrás
    
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
    
    let generos = ["Masculino", "Femenino", "Otro"]
    let estados = [
        "Aguascalientes","Baja California","Baja California Sur","Campeche","Chiapas","Chihuahua","Ciudad de México","Coahuila","Colima","Durango","Estado de México","Guanajuato","Guerrero","Hidalgo","Jalisco","Michoacán","Morelos","Nayarit","Nuevo León","Oaxaca","Puebla","Querétaro","Quintana Roo","San Luis Potosí","Sinaloa","Sonora","Tabasco","Tamaulipas","Tlaxcala","Veracruz","Yucatán","Zacatecas"
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Title(text: "Cuestionario de Factor de Riesgo")
                    
                    // =======================
                    // DATOS GENERALES
                    // =======================
                    if !showingQuestions {
                        
                        textField(placeholder: "Nombre", text: $vm.nombre, iconName: "person")
                        textField(placeholder: "Teléfono", text: $vm.telefono, iconName: "phone")
                            .keyboardType(.phonePad)
                        nefroSelect(placeholder: "Género", selection: $vm.generoSeleccionado, options: generos)
                        textField(placeholder: "Edad", text: $vm.edad, iconName: "figure")
                            .keyboardType(.numberPad)
                        nefroSelect(placeholder: "Estado de nacimiento", selection: $vm.estadoNacimientoSeleccionado, options: estados)
                        
                        DatePicker("Fecha de nacimiento", selection: $vm.fechaNacimiento, displayedComponents: .date)
                            .padding(.horizontal)
                        
                        Button {
                            withAnimation { showingQuestions = true }
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
                        
                    // =======================
                    // PREGUNTAS DINÁMICAS
                    // =======================
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
                            Text(error).foregroundColor(.red)
                        }
                        
                        Button {
                            withAnimation { showingQuestions = false }
                        } label: {
                            Text("Regresar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // 👉 ENVIAR FORMULARIO
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
                .padding(.vertical, 20)
            }
        }
        .onAppear { Task { await vm.loadForm() } }
        .onTapGesture { UIApplication.shared.hideKeyboard() }
        
        // 🟢 ALERT CON 3 DISMISS HACIA LA PRIMERA VISTA
        .alert("Formulario enviado", isPresented: $showSuccessAlert) {
            Button("Aceptar") {
                for _ in  0..<3{
                    dismiss()
                }
            }
        } message: {
            Text(vm.successMessage ?? "Tu cuestionario se ha enviado correctamente.")
        }
    }
}
