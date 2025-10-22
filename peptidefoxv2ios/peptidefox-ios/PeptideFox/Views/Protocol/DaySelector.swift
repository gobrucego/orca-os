//
//  DaySelector.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

struct DaySelector: View {
    @Binding var selectedDay: Int
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedDay = index
                        }
                    }) {
                        Text(days[index])
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(selectedDay == index ? Color(hex: "#0f172a") : Color(hex: "#94a3b8"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(selectedDay == index ? Color(hex: "#60a5fa") : Color(hex: "#1e293b"))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    DaySelector(selectedDay: .constant(0))
        .background(Color.protocolBackground)
}
