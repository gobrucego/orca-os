import SwiftUI

struct DaySelector: View {
    @Binding var selectedDay: Int

    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<7) { day in
                Button(action: {
                    withAnimation {
                        selectedDay = day
                    }
                }) {
                    Text(days[day])
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(selectedDay == day ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedDay == day ? Color.blue : Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

#Preview {
    DaySelector(selectedDay: .constant(0))
}
