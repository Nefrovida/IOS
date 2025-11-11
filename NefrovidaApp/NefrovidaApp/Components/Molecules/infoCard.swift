import SwiftUI

struct infoCard: View {
    @State var asistio = false
    var image = ProfileView()
    var name: String
    var typeOfExam: String
    var button : nefroButton?
    var cel : String
    var date : String
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            image
                .font(.system(size: 50))
                .padding(10)
            
                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.nvBrand)

                    Text(typeOfExam)
                        .font(.nvBody)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    if cel != ""{
                        Text(cel)
                            .font(.nvBody)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }else{
                        Text(date)
                            .font(.nvBody)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                }

                Spacer(minLength: 12)

                
                if button != nil{
                button
                        .frame(width: 95)
                    
            } else {
                Toggle(isOn: $asistio) {
                    Text("Asistió")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.nvBrand)
                }
                .frame(height: 20)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
            )

        }
    }



#Preview {
    infoCard(name: "Manuel", typeOfExam: "Examen de riñones", button: nefroButton(text: "Agendar",color:Color(red: 0.82, green: 0.94, blue: 0.97), vertical: 8, horizontal: 8,textSize: 15 ,action: {}), cel: "", date: "10-11-2025")
    
    infoCard(name: "Manuel", typeOfExam: "Examen de riñones", cel: "432334", date: "")
}
