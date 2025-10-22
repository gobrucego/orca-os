//
//  LoadingView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//  Loading screen with animated logo and brand reveal
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: Double = 1.3
    @State private var showText = false
    @State private var opacity: Double = 1.0
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            // Dark background matching protocol theme
            Color.protocolBackground
                .ignoresSafeArea()
            
            VStack(spacing: DesignTokens.Spacing.xxl) {
                // Logo with rotation and scale animation
                Image("peptidefoxicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .shadow(
                        color: Color.protocolAccent.opacity(0.3),
                        radius: 20,
                        x: 0,
                        y: 0
                    )
                
                // Brand text (fades in during phase 2)
                Text("Peptide Fox")
                    .font(DesignTokens.Typography.displayMedium)
                    .foregroundColor(Color.protocolText)
                    .opacity(showText ? 1 : 0)
            }
            .opacity(opacity)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    // MARK: - Animation Sequence

    private func startAnimation() {
        // Phase 1: Fast→slow spin with big→normal scale (0-1.5s)
        // Starts fast and big, decelerates and shrinks to normal over 1.5 seconds
        withAnimation(.easeOut(duration: 1.5)) {
            rotation = 720  // Two full rotations (fast at start, slowing down)
            scale = 1.0     // Shrink from 1.3 to normal size
        }

        // Phase 2: Show text (1.5-2s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Fade in brand text
            withAnimation(.easeIn(duration: 0.5)) {
                showText = true
            }
        }

        // Phase 3: Fade out and dismiss (2-2.5s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 0
            }

            // Dismiss loading screen after fade completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isShowing = false
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LoadingView(isShowing: .constant(true))
}
