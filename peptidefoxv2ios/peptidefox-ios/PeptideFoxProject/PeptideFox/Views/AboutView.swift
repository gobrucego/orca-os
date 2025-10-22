//
//  AboutView.swift
//  PeptideFox
//
//  Created on 2025-10-20.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App Icon and Version
                    VStack(spacing: 8) {
                        Image(systemName: "pawprint.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.blue.gradient)
                        
                        Text("PeptideFox")
                            .font(.title.bold())
                        
                        Text("Version 1.0.0 (Build 1)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 32)
                    
                    Divider()
                    
                    // Medical Disclaimer
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Medical Disclaimer", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        
                        Text("""
                        PeptideFox is a research calculation tool and does not provide medical advice.
                        
                        All peptide therapy should be conducted under medical supervision. Consult a licensed healthcare provider before starting any peptide protocol.
                        
                        This app is for educational and research purposes only. The developers and publishers of PeptideFox are not responsible for any adverse effects or consequences resulting from the use of this application.
                        """)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemOrange).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Privacy
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Privacy First", systemImage: "lock.shield.fill")
                            .font(.headline)
                            .foregroundStyle(.green)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            PrivacyRow(text: "All data stored locally on your device")
                            PrivacyRow(text: "No account required")
                            PrivacyRow(text: "No tracking or analytics")
                            PrivacyRow(text: "Medical data never leaves your device")
                            PrivacyRow(text: "HIPAA-conscious design")
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color(.systemGreen).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "flask.fill", text: "Reconstitution Calculator")
                            FeatureRow(icon: "calendar.badge.clock", text: "Supply Planning")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "GLP-1 Protocols")
                            FeatureRow(icon: "book.fill", text: "Peptide Library")
                            FeatureRow(icon: "doc.text.fill", text: "Protocol Builder")
                            FeatureRow(icon: "moon.fill", text: "Dark Mode Support")
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Links
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Information")
                            .font(.headline)
                        
                        Link(destination: URL(string: "https://peptidefox.com")!) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Visit PeptideFox.com")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.subheadline)
                        }
                        
                        Link(destination: URL(string: "https://peptidefox.com/support")!) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                Text("Support & FAQ")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.subheadline)
                        }
                        
                        Link(destination: URL(string: "https://peptidefox.com/privacy")!) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Copyright
                    VStack(spacing: 4) {
                        Text("© 2025 PeptideFox")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("All rights reserved")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PrivacyRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .imageScale(.small)
            Text(text)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
            Text(text)
        }
    }
}

#Preview {
    AboutView()
}
