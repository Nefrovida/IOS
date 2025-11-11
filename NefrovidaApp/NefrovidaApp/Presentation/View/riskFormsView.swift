import SwiftUI

struct RiskFormView: View {
    @StateObject private var vm = RiskFormViewModel(
        useCase: SubmitRiskFormUseCase(repository: RiskFormRepository())
    )
    
    let generos = ["Masculino", "Femenino", "Otro"]
    let estados = ["CDMX", "Jalisco", "Nuevo León", "Puebla", "Yucatán"]
    
    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            
            ScrollView {
                VStack(spacing: 20) {
                    Title(text: "Cuestionario de Factor de Riesgo")
                    
                    // 🧩 Datos generales
                    textField(placeholder: "Nombre", text: $vm.nombre)
                    textField(placeholder: "Teléfono", text: $vm.telefono)
                    SelectField(label: "Género", options: generos, selection: $vm.generoSeleccionado)
                    textField(placeholder: "Edad", text: $vm.edad)
                    textField(placeholder: "Estado de Nacimiento",text: $vm.estadoNacimiento)
                    
                    DatePicker("Fecha de nacimiento", selection: $vm.fechaNacimiento, displayedComponents: .date)
                        .padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    // 🩺 Preguntas
                    Group {
                        questionField(
                            question: "¿Sus padres o hermanos padecen enfermedades crónicas?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.antecedentesFamiliares
                        )
                        
                        questionField(
                            question: "¿Padece diabetes mellitus?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.diabetes
                        )
                        
                        questionField(
                            question: "¿Ha tenido cifras de glucosa > 140 en ayunas?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.glucosaAlta
                        )
                        
                        questionField(
                            question: "¿Está en tratamiento por presión alta?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.presionAltaTratamiento
                        )
                        
                        questionField(
                            question: "¿Cifras de presión arterial > 130/80?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.presionAltaCifras
                        )
                        
                        questionField(
                            question: "¿Familiar con enfermedad renal crónica (ERC)?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.familiarERC
                        )
                        
                        questionField(
                            question: "¿Usa analgésicos con frecuencia?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.analgesicosFrecuentes
                        )
                        
                        questionField(
                            question: "¿Ha tenido piedras en los riñones?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.litiasisRenal
                        )
                        
                        questionField(
                            question: "¿Tiene sobrepeso u obesidad?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.sobrepeso
                        )
                        
                        questionField(
                            question: "¿Consume refrescos?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.refrescos
                        )
                        
                        questionField(
                            question: "¿Agrega sal a sus alimentos?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.sal
                        )
                        
                        questionField(
                            question: "¿Fuma o ha fumado más de 10 años?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.fumador
                        )
                        
                        questionField(
                            question: "¿Ingiere bebidas alcohólicas con frecuencia?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.alcohol
                        )
                        
                        questionField(
                            question: "¿Ha tenido episodios de depresión?",
                            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
                            answer: $vm.depresion
                        )
                    }
                    
                    Button {
                        Task { await vm.submit() }
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
                .padding(.top, 20)
            }
            
            BottomBar()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    RiskFormView()
}
