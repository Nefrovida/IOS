import SwiftUI

struct DayPill: View {
    let date: Date
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(DateFormats.weekDayShort.string(from: date).localizedCapitalized)
                .font(.nvSmall)
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(8)
                .background(Circle().fill(isSelected ? Color.nvBrand : .clear))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .padding(.vertical, 6)
        .frame(minWidth: 44)
        .contentShape(Rectangle())
    }
}

#Preview {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return DayPill(date: formatter.date(from: "2025-11-09")!, isSelected: true)
}

