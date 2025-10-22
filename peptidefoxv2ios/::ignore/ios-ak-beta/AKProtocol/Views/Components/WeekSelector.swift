import SwiftUI

struct WeekSelector: View {
    @Binding var selectedWeek: Int

    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...4, id: \.self) { week in
                Button(action: {
                    withAnimation {
                        selectedWeek = week
                    }
                }) {
                    Text("Week \(week)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedWeek == week ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedWeek == week ? Color.blue : Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

#Preview {
    WeekSelector(selectedWeek: .constant(1))
}
