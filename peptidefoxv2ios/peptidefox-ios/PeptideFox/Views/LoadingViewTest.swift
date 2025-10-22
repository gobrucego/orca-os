//
//  LoadingViewTest.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//  Test harness for loading screen animation
//

import SwiftUI

struct LoadingViewTest: View {
    @State private var showLoading = true
    
    var body: some View {
        ZStack {
            // Mock main app content
            VStack {
                Text("Main App Content")
                    .font(DesignTokens.Typography.displayLarge)
                    .foregroundColor(ColorTokens.foregroundPrimary)
                
                Button("Replay Loading Animation") {
                    showLoading = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, DesignTokens.Spacing.xxl)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorTokens.backgroundPrimary)
            .opacity(showLoading ? 0 : 1)
            
            // Loading screen
            if showLoading {
                LoadingView(isShowing: $showLoading)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showLoading)
    }
}

#Preview {
    LoadingViewTest()
}
