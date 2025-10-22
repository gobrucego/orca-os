import SwiftUI

struct PeptideCardView: View {
    let peptide: Peptide
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            // Category Badge
            HStack {
                PFBadge(text: peptide.category.rawValue, category: peptide.category)
                Spacer()
            }
            
            // Peptide Name
            Text(peptide.name)
                .font(DesignTokens.Typography.headlineSmall)
                .foregroundColor(ColorTokens.foregroundPrimary)
                .lineLimit(2)
            
            // Description
            Text(peptide.description)
                .font(DesignTokens.Typography.bodySmall)
                .foregroundColor(ColorTokens.foregroundSecondary)
                .lineLimit(3)
            
            Spacer()
            
            // Footer Info
            HStack(spacing: DesignTokens.Spacing.sm) {
                HStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(peptide.evidenceLevel.color)
                    
                    Text(peptide.evidenceLevel.rawValue)
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(ColorTokens.foregroundTertiary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(ColorTokens.foregroundTertiary)
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .frame(height: 200)
        .background(ColorTokens.backgroundPrimary)
        .cornerRadius(DesignTokens.CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                .stroke(peptide.category.borderColor, lineWidth: 1.5)
        )
        .shadow(
            color: DesignTokens.Shadow.sm.color,
            radius: DesignTokens.Shadow.sm.radius,
            x: DesignTokens.Shadow.sm.x,
            y: DesignTokens.Shadow.sm.y
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(peptide.name), \(peptide.category.rawValue), \(peptide.description)")
        .accessibilityHint("Tap to view details")
    }
}

// MARK: - Preview
#Preview {
    PeptideCardView(
        peptide: Peptide(
            id: "semaglutide",
            name: "Semaglutide",
            category: .glp1,
            description: "GLP-1 receptor agonist for weight loss and metabolic health",
            mechanism: "Mimics GLP-1 hormone",
            benefits: ["Weight loss", "Improved glycemic control"],
            typicalDose: DoseRange(min: 0.25, max: 2.4, unit: "mg"),
            frequency: "Weekly",
            cycleLength: "Ongoing",
            contraindications: [],
            signals: [],
            synergies: [],
            evidenceLevel: .high
        )
    )
    .padding()
    .frame(width: 180)
}
