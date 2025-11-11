import SwiftUI

struct infoCard: View {
    @State var asistio = false
    var image = ProfileView()
    var name: String
    var typeOfExam: String
    // The button atom is used
    var button : nefroButton?
    var cel : String
    var date : String
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            image
                .font(.system(size: 50))
                .padding(10)
                // Defines the main fields displayed in the card
                VStack(alignment: .leading, spacing: 8) {
                    // Name of the person
                    Text(name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.nvBrand)
                    // Type of exam to be perfomed
                    Text(typeOfExam)
                        .font(.nvBody)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    // Patient's phone number or today's date
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

                // If there is no button, an “toggle” button is placed.
                if button != nil{
                button
                        .frame(width: 95)
                    
                } else {
                    // The toggle button indicates its status depending on whether it is active or not.
                    VStack(spacing: 6) {
                        Toggle("", isOn: $asistio)
                            .labelsHidden()
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 6)
                        if asistio {
                            Text("Asistio")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.green)
                                .transition(.opacity)
                        }
                        else {
                            Text("No asistio")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color.nvBrand)
                                .transition(.opacity)
                        }
                    }
                    // Adds the padding to the right
                    .padding(.trailing, 15)
                    .animation(.easeInOut(duration: 0.2), value: asistio)
                }
            // The card size is define
            }.frame(height: 100)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
            )

        }
    }


// A preview to visualize the aplication of the infoCard
#Preview {
    infoCard(name: "Manuel", typeOfExam: "Examen de riñones", button: nefroButton(text: "Agendar",color:Color(red: 0.82, green: 0.94, blue: 0.97), vertical: 8, horizontal: 8,textSize: 15 ,action: {}), cel: "", date: "10-11-2025")
    
    infoCard(name: "Manuel", typeOfExam: "Examen de riñones", cel: "432334", date: "")
}
