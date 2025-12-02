import SwiftUI

struct HomeView: View {
    let user: LoginEntity?
    @State private var selectedTab = 0
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {

            ScrollView {
                VStack(spacing: -12) {
                    UpBar()
                    VStack(spacing: 0) {
                        Image("header")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 140)
                            .frame(maxWidth: .infinity)
                            .clipped()

                        Text("En NefroVida A.C. estamos comprometidos con la salud de nuestros pacientes. Ofrecemos servicios especializados en la detección, prevención y tratamiento de la Enfermedad Renal Crónica, diseñados para proteger tu salud renal y mejorar tu calidad de vida.")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(Color.nvBrand)
                        
                        
                        // // Botón Ver catálogo que activa el tab de servicios
                        // Button(action: {
                        //     selectedTab = 0
                        // }) {
                        //     Text("Ver catálogo")
                        //         .font(.headline)
                        //         .foregroundColor(.white)
                        //         .padding(.vertical, 10)
                        //         .padding(.horizontal, 32)
                        //         .background(Color.nvBrand)
                        //         .cornerRadius(8)
                        //         .shadow(color: Color(.systemGray4), radius: 2, x: 0, y: 1)
                        // }
                        // .padding(.bottom, 8)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Misión y Visión")
                            .font(.title2).bold()
                            .foregroundColor(Color(Color.nvBrand))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                        SectionCard(
                            icon: "heart.circle.fill",
                            title: "Misión",
                            description: "Brindar atención y apoyo multidisciplinario en la prevención, detección, control y tratamiento de personas con Enfermedad Renal Crónica, con o sin tratamiento sustitutivo de función renal (hemodiálisis, diálisis) y acompañamiento de protocolo de trasplante por medio de programas y acciones que contribuyan a mejorar su calidad de vida."
                        )
                        
                        SectionCard(
                            icon: "eye.circle.fill",
                            title: "Visión",
                            description: "Ser una organización autosustentable que promueve la prevención y detección oportuna en personas con factores de riesgo de la Enfermedad Renal Crónica (ERC), que se encuentran en situación vulnerable; con el fin de modificar positivamente la evolución natural y así disminuir la letalidad de la ERC."
                        )
                    }
                    .padding(.top, 16)
                    // Servicios
                    VStack(spacing: 24) {
                        Text("Nuestros Servicios")
                            .font(.title2).bold()
                            .foregroundColor(Color(Color.nvBrand))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                        ServiceCardRedesigned(icon: "heart", title: "Tamizaje y Prevención", description: "Detección temprana de Enfermedad Renal Crónica", details: ["Niños (donativo $180.00)", "Adultos (donativo $200.00)", "Embarazadas (donativo $395.00)"])
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ServiceCardRedesigned(icon: "stethoscope", title: "Consultas", description: "Atención médica especializada", details: ["Nefrología", "Nefro pediatra", "Urología", "Diabetólogo", "Médico General", "Nutrición", "Psicología"])
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ServiceCardRedesigned(icon: "viewfinder", title: "Ultrasonidos", description: "Realizados por médico certificado", details: ["Renal", "Abdomen", "Próstata", "Tiroides", "Obstétrico", "Tejidos blandos", "Entre otros más"])
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .padding(.bottom, 30)
                    
                    // Sección Encuéntranos
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Encuéntranos")
                            .font(.title2).bold()
                            .foregroundColor(Color.nvBrand)
                            .padding(.bottom, 4)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(Color.nvBrand)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dirección")
                                    .font(.headline)
                                    .foregroundColor(Color.nvBrand)
                                Text("Calle Principal #123, Colonia Centro, Ciudad, CP 12345")
                                    .font(.body)
                                    .foregroundColor(Color(.label))
                            }
                        }
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "clock")
                                .foregroundColor(Color.nvBrand)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Horario")
                                    .font(.headline)
                                    .foregroundColor(Color.nvBrand)
                                Text("Lunes a Viernes: 8:00 AM - 6:00 PM\nSábados: 9:00 AM - 2:00 PM")
                                    .font(.body)
                                    .foregroundColor(Color(.label))
                            }
                        }
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "phone")
                                .foregroundColor(Color.nvBrand)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Teléfono")
                                    .font(.headline)
                                    .foregroundColor(Color.nvBrand)
                                Text("+52 (123) 456-7890")
                                    .font(.body)
                                    .foregroundColor(Color(.label))
                            }
                        }
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "envelope")
                                .foregroundColor(Color.nvBrand)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Correo")
                                    .font(.headline)
                                    .foregroundColor(Color.nvBrand)
                                Text("contacto@nefrovidaac.com")
                                    .font(.body)
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 30)
                    
                }
            }
        }
    }
    
    
    struct InfoCard: View {
        var title: String
        var subtitle: String
        var hours: String
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(.label))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                Text(hours)
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color(.label))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
        }
    }
    
    struct ServiceCardRedesigned: View {
        var icon: String
        var title: String
        var description: String
        var details: [String]
        var body: some View {
            VStack(spacing: 8) {
                ZStack {
                    Circle().fill(Color(.systemGray6)).frame(width: 60, height: 60)
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(Color.blue)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(.label))
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(details, id: \ .self) { item in
                        Text("• " + item)
                            .font(.body)
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
        }
    }
    
    struct SocialCircleIcon: View {
        var name: String
        var color: Color
        var body: some View {
            ZStack {
                Circle().fill(color).frame(width: 56, height: 56)
                Image(name)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
    }
    
    struct DoctorCard: View {
        var name: String
        var specialty: String
        var body: some View {
            VStack {
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 80, height: 80) // Aquí va la imagen
                Text(name).font(.subheadline)
                Text(specialty).font(.caption)
            }
            .frame(width: 140)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    struct LabInfoCard: View {
        var body: some View {
            VStack {
                Image(systemName: "heart.text.square")
                    .font(.largeTitle)
                Text("Estudios de Laboratorio")
                    .font(.headline)
                Text("Diagnóstico y seguimiento de patologías. Conoce nuestros servicios aquí.")
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    struct SocialIcon: View {
        var name: String
        var body: some View {
            Image(name) // Debes agregar los assets de los iconos
                .resizable()
                .frame(width: 40, height: 40)
        }
    }

