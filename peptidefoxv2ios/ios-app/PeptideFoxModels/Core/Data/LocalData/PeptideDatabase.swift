//
//  PeptideDatabase.swift
//  PeptideFox
//
//  Central peptide database - Single source of truth
//  Ported from lib/peptide-data.ts PEPTIDE_DATA array
//  Medical data integrity maintained - NEVER fabricate data
//

import Foundation

/// Central peptide database providing access to all peptide information
/// This is the single source of truth for peptide data in the iOS app
public struct PeptideDatabase {
    public static let shared = PeptideDatabase()
    
    public let allPeptides: [Peptide]
    
    private init() {
        allPeptides = Self.buildDatabase()
    }
    
    // MARK: - Database Construction
    
    private static func buildDatabase() -> [Peptide] {
        [
            // MARK: - GLP-1 Agonists
            
            Peptide(
                id: "retatrutide",
                name: "Retatrutide",
                category: .glp,
                description: "Triple agonist for aggressive fat loss",
                mechanism: "GLP-1 (satiety), GIP (insulinotropic), glucagon (lipolysis) agonist",
                typicalDose: "1-2mg weekly",
                cycleLength: "12-24 weeks",
                frequency: "q2d - Weekly",
                benefits: [
                    "Aggressive fat loss",
                    "Energy expenditure",
                    "Satiety control"
                ],
                protocol: "Start low weekly dose (1-2mg) to test GI tolerance → slow 4-8 week titration to symptom-guided target → maintain lowest effective dose",
                rationale: "Glucagon activity can push EE but risks lean losses; resistance training 3×/week is non-negotiable with triple agonists",
                contraindications: [
                    "Personal/family history of MTC or MEN2",
                    "Pregnancy",
                    "Gastroparesis",
                    "Severe GI disease"
                ],
                signals: [
                    "Sustained satiety without excessive nausea",
                    "Strength preservation is critical outcome marker"
                ],
                cost: .veryHigh,
                evidence: .strong,
                notes: nil,
                synergies: ["tesamorelin", "motsc", "lcarnitine", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f8fafc",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#e2e8f0",
                    badgeText: "#1e293b",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            Peptide(
                id: "tirzepatide",
                name: "Tirzepatide",
                category: .glp,
                description: "Dual agonist for weight & T2D control",
                mechanism: "GLP-1 satiety/gastric delay + GIP insulinotropic effects",
                typicalDose: "2.5-15mg weekly",
                cycleLength: "16-24 weeks",
                frequency: "q2d - Weekly",
                benefits: [
                    "Weight loss",
                    "Glycemic control",
                    "OSA improvement"
                ],
                protocol: "Start 2.5-5mg weekly × 4 weeks → increase every 4 weeks as tolerated (goal often 10-15mg) → maintain minimal effective dose",
                rationale: "Slow titration prevents GI dropout; training/protein protect lean mass",
                contraindications: [
                    "Personal/family history MTC or MEN2",
                    "Pregnancy",
                    "Pancreatitis history",
                    "Severe GI disease"
                ],
                signals: [
                    "Waist ↓",
                    "Resting HR neutral",
                    "Strength maintained"
                ],
                cost: .veryHigh,
                evidence: .strong,
                notes: nil,
                synergies: ["tesamorelin", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f8fafc",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#e2e8f0",
                    badgeText: "#1e293b",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            Peptide(
                id: "semaglutide",
                name: "Semaglutide",
                category: .glp,
                description: "GLP-1 for weight loss & CV protection",
                mechanism: "GLP-1R agonism with long half-life",
                typicalDose: "0.25-2.4mg",
                cycleLength: "16-24 weeks",
                frequency: "q2d - Weekly",
                benefits: [
                    "Weight loss",
                    "Glycemic control",
                    "CV risk reduction"
                ],
                protocol: "Start 0.25mg weekly (SC) or oral 3-7mg daily → up every 4 weeks as tolerated (0.5→1.0→1.7/2.4mg SC; oral to 14mg) → maintain lowest effective dose",
                rationale: "Nausea threshold guides titration; incorporate protein 1.6-2.2g/kg + 3×/wk resistance training",
                contraindications: [
                    "Personal/family history MTC or MEN2",
                    "Pregnancy",
                    "Pancreatitis history",
                    "Diabetic retinopathy (monitor)"
                ],
                signals: [
                    "Appetite down without aversion to protein",
                    "Gym numbers stable"
                ],
                cost: .veryHigh,
                evidence: .strong,
                notes: nil,
                synergies: ["nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f8fafc",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#e2e8f0",
                    badgeText: "#1e293b",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            // MARK: - Mitochondrial / Metabolic
            
            Peptide(
                id: "ss31",
                name: "SS-31",
                category: .metabolic,
                description: "Mitochondrial function optimizer",
                mechanism: "Binds cardiolipin, stabilizes cristae, improves electron transport",
                typicalDose: "5-20mg",
                cycleLength: "4-8 weeks",
                frequency: "3-5x / Week",
                benefits: [
                    "Reduces fatigue",
                    "Improves HRV",
                    "Lowers post-exertional malaise"
                ],
                protocol: "Start 5-10mg SC daily for 2-4 weeks (or 10-20mg 3-5×/wk) → if tolerated but flat response, 10-20mg/d for weeks 3-6 → maintain 5-10mg SC 3×/wk for 4-8 weeks",
                rationale: "Cardiolipin stabilization is dose-dependent early; tapering reduces cost while keeping membrane effects \"topped up\"",
                contraindications: [
                    "Active malignancy under treatment (theoretical)",
                    "Pregnancy",
                    "Uncontrolled hypertension initially"
                ],
                signals: [
                    "Lower post-exertional malaise",
                    "Improved HRV/orthostatic tolerance",
                    "Steadier work output"
                ],
                cost: .high,
                evidence: .strong,
                notes: "Multiple human trials showing measurable improvements in energy, inflammation, and cellular function",
                synergies: ["nad", "motsc"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#faf5ff",
                    borderColor: "#c084fc",
                    accentColor: "#9333ea",
                    bulletColor: "#d8b4fe",
                    badgeBg: "#e9d5ff",
                    badgeText: "#6b21a8",
                    badgeBorder: "#d8b4fe"
                )
            ),
            
            Peptide(
                id: "motsc",
                name: "MOTS-c",
                category: .metabolic,
                description: "Mitochondrial peptide for metabolic flexibility",
                mechanism: "AMPK activation, metabolic flexibility enhancement",
                typicalDose: "5-15 mg",
                cycleLength: "4-8 weeks",
                frequency: "2-3x / Week",
                benefits: [
                    "Fat oxidation",
                    "Training tolerance",
                    "Metabolic flexibility"
                ],
                protocol: "Start 5mg SC 2×/wk for 2 weeks → build 5-10mg SC 3×/wk for weeks 3-6 → cycle 4-6 weeks on → 2-4 weeks off to avoid receptor/desensitization concerns",
                rationale: "Pulsed exposure lines up with exercise-like gene programs; off-weeks maintain responsiveness",
                contraindications: [
                    "Hypoglycemia risk if combined with aggressive caloric deficit",
                    "Titrate with protein intake"
                ],
                signals: [
                    "Easier zone-2",
                    "Lower RPE at given watt/pace",
                    "Smaller post-meal glucose swings"
                ],
                cost: .high,
                evidence: .moderate,
                notes: "Mixed-sport trainees report \"gear-change\" in week 2—more steady state, less bonk",
                synergies: ["nad", "aod9604", "lcarnitine", "ss31"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e2e8f0",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#f1f5f9",
                    badgeText: "#334155",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            Peptide(
                id: "nad",
                name: "NAD+",
                category: .metabolic,
                description: "Foundational energy substrate",
                mechanism: "Universal cofactor for ATP and sirtuin activity",
                typicalDose: "100-250 mg",
                cycleLength: "Ongoing",
                frequency: "3-5x / Week",
                benefits: [
                    "Restores cellular energy",
                    "Supports DNA repair",
                    "Enhances mitochondrial function"
                ],
                protocol: "Start 100-150mg IM 3×/wk × 2 weeks OR IV 250-500mg sessions 1-2×/wk (slow infusion) → build 200-300mg IM 3×/wk × weeks 3-6 OR IV 750-1000mg weekly → maintain 100-150mg IM 1-2×/wk, optionally with NR 300-600mg PO daily",
                rationale: "Front-load to replenish pool; IM/IV gives immediate rise; oral NR maintains",
                contraindications: [
                    "Use only sterile/GMP sources",
                    "Slow IV to avoid nausea",
                    "Migraine-prone may prefer IM"
                ],
                signals: [
                    "Less afternoon crash",
                    "Improved sleep latency by week 2-3",
                    "Better power consistency"
                ],
                cost: .high,
                evidence: .strong,
                notes: "Multiple human trials showing measurable improvements in energy, inflammation, and cellular function",
                synergies: ["ss31", "motsc", "5amino1mq", "bpc157", "tb500", "ghkcu"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e9d5ff",
                    borderColor: "#c084fc",
                    accentColor: "#9333ea",
                    bulletColor: "#d8b4fe",
                    badgeBg: "#fed7aa",
                    badgeText: "#9a3412",
                    badgeBorder: "#fb923c"
                )
            ),
            
            Peptide(
                id: "aod9604",
                name: "AOD-9604",
                category: .metabolic,
                description: "Fat mobilization support",
                mechanism: "Lipolysis signaling via GH fragment",
                typicalDose: "250-500 mcg",
                cycleLength: "6-12 weeks",
                frequency: "Daily (AM fasted)",
                benefits: [
                    "Fat mobilization",
                    "Gentle cut support",
                    "No hyperglycemia"
                ],
                protocol: "250-500µg SC daily AM fasted × 6-12 weeks",
                rationale: "Morning aligns with fasted fat-oxidation window; not a primary driver—consider adjunct to caloric deficit and training",
                contraindications: [
                    "Limited robust clinical data",
                    "Generally well-tolerated"
                ],
                signals: [
                    "Subtle effects",
                    "Improved fat mobilization markers",
                    "Not dramatic standalone—works best in comprehensive program"
                ],
                cost: .medium,
                evidence: .limited,
                notes: "Effects are modest; don't expect dramatic transformation from AOD alone. Best used as part of structured fat-loss protocol",
                synergies: ["motsc", "lcarnitine", "retatrutide", "tesamorelin"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e2e8f0",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#f1f5f9",
                    badgeText: "#334155",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            Peptide(
                id: "lcarnitine",
                name: "L-Carnitine",
                category: .metabolic,
                description: "Fat oxidation & endurance",
                mechanism: "Carnitine shuttle for fatty acid transport to mitochondria",
                typicalDose: "200-400mg IM",
                cycleLength: "4-8 weeks",
                frequency: "3-5x / week (IM - pre-training)",
                benefits: [
                    "Fat oxidation",
                    "Endurance enhancement",
                    "Muscle recovery"
                ],
                protocol: "Oral 1-2g/day divided with meals (carbs enhance uptake) OR IM 200-400mg 3-5×/wk for 4-8 weeks when GI tolerance poor or rapid effect desired",
                rationale: "Oral for baseline maintenance; IM provides immediate elevation and bypasses GI issues (nausea, diarrhea common with oral)",
                contraindications: [
                    "Fishy odor (TMA production in some individuals)",
                    "GI upset with oral—split doses or switch to IM",
                    "Seizure disorders (rare reports of lowered threshold)"
                ],
                signals: [
                    "Endurance \"floor\" rises (less fatigue at submaximal efforts)",
                    "Improved recovery between training sessions",
                    "Better fat utilization during fasted cardio"
                ],
                cost: .low,
                evidence: .strong,
                notes: "Athletes report sustained energy during long training sessions; fertility patients show improved sperm motility markers after 3-6 months",
                synergies: ["motsc", "retatrutide"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdfa",
                    borderColor: "#2dd4bf",
                    accentColor: "#0d9488",
                    bulletColor: "#99f6e4",
                    badgeBg: "#ccfbf1",
                    badgeText: "#134e4a",
                    badgeBorder: "#5eead4"
                )
            ),
            
            Peptide(
                id: "5amino1mq",
                name: "5-Amino-1MQ",
                category: .metabolic,
                description: "Body recomp via NNMT inhibition",
                mechanism: "Inhibits NNMT, shifts methyl/NAD metabolism",
                typicalDose: "25-50mg",
                cycleLength: "4-6 weeks",
                frequency: "Daily",
                benefits: [
                    "Fat loss",
                    "Metabolic flexibility",
                    "Insulin sensitivity"
                ],
                protocol: "25-50mg oral or SC daily × 4-6 weeks; hold if headaches/irritability develop",
                rationale: "Keep runs short pending more human safety data; mechanism distinct from traditional fat-loss compounds",
                contraindications: [
                    "Unknown long-term safety profile",
                    "Stop if BP elevations or mood disturbances",
                    "Very limited human data"
                ],
                signals: [
                    "Waist circumference ↓ without stimulant effects",
                    "Improved metabolic flexibility markers",
                    "Subtle appetite regulation"
                ],
                cost: .medium,
                evidence: .experimental,
                notes: "Promising preclinical data; human data very limited. Consider highly experimental. Effects are subtle and require comprehensive lifestyle program",
                synergies: ["nad", "motsc", "lcarnitine", "retatrutide"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e2e8f0",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#f1f5f9",
                    badgeText: "#334155",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            // MARK: - Healing & Tissue Repair
            
            Peptide(
                id: "bpc157",
                name: "BPC-157",
                category: .healing,
                description: "Body protection compound",
                mechanism: "Angiogenesis, NO signaling, fibroblast migration",
                typicalDose: "250-500 mcg",
                cycleLength: "4-6 weeks",
                frequency: "Daily",
                benefits: [
                    "Systemic healing",
                    "Gut barrier support",
                    "Tissue regeneration"
                ],
                protocol: "MSK focus 250-500µg SC daily near injury (rotate sites) × 4-6 weeks OR GI focus 250-500µg SC daily (empty stomach timing may enhance mucosal contact) × 4-6 weeks → cycle 4-6 weeks on → 2-4 weeks off; repeat if needed",
                rationale: "Daily local exposure supports early remodeling; off-cycle lets tissue consolidate in acute cases",
                contraindications: [
                    "Active cancer history (pro-repair/angiogenesis theoretical concern)",
                    "Monitor BP, unusual edema"
                ],
                signals: [
                    "Pain with activity ↓",
                    "Improved tendon glide by week 2-3",
                    "GI: stool normalization, less meal-triggered pain"
                ],
                cost: .medium,
                evidence: .strong,
                notes: "Runners with proximal hamstring tendinopathy report \"grip\" pain easing by week 3 when combined with eccentric loading",
                synergies: ["tb500", "ghkcu", "kpv", "ara290", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdfa",
                    borderColor: "#2dd4bf",
                    accentColor: "#0d9488",
                    bulletColor: "#99f6e4",
                    badgeBg: "#ccfbf1",
                    badgeText: "#134e4a",
                    badgeBorder: "#5eead4"
                )
            ),
            
            Peptide(
                id: "tb500",
                name: "TB-500",
                category: .healing,
                description: "Soft-tissue healing accelerator",
                mechanism: "Actin-sequestering, cell migration, angiogenesis",
                typicalDose: "2-10mg weekly",
                cycleLength: "4-8 weeks",
                frequency: "2-3x / week",
                benefits: [
                    "Soft-tissue healing",
                    "Post-surgical recovery",
                    "Anti-inflammatory"
                ],
                protocol: "MSK acute/moderate: Loading 4-8mg/wk split (e.g., 2mg 2-4×/wk) × 4 weeks → maintenance 2-4mg/wk × 2-4 weeks. MSK severe/chronic: Aggressive loading 8-10mg/wk split × 4-6 weeks → taper to 3-4mg 2×/wk × 4 weeks → maintain 2.5-3mg weekly",
                rationale: "Front-load to kickstart migration/angiogenesis; taper as collagen cross-links. Higher doses supported in literature for severe/chronic cases",
                contraindications: [
                    "Personal/family cancer history → discuss with clinician",
                    "Can cause transient fatigue"
                ],
                signals: [
                    "Range of motion ↑",
                    "Morning stiffness ↓",
                    "Improved tissue quality on palpation"
                ],
                cost: .medium,
                evidence: .strong,
                notes: "Ensure full 43-amino acid chain TB-500, not fragments",
                synergies: ["bpc157", "kpv", "ghkcu", "ara290", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdfa",
                    borderColor: "#2dd4bf",
                    accentColor: "#0d9488",
                    bulletColor: "#99f6e4",
                    badgeBg: "#ccfbf1",
                    badgeText: "#134e4a",
                    badgeBorder: "#5eead4"
                )
            ),
            
            Peptide(
                id: "ghkcu",
                name: "GHK-Cu",
                category: .healing,
                description: "Collagen synthesis & skin remodeling",
                mechanism: "Up-regulates collagen/elastin, down-modulates MMPs",
                typicalDose: "2-3mg",
                cycleLength: "8-12 weeks",
                frequency: "3x / week or Daily",
                benefits: [
                    "Skin remodeling",
                    "Scar quality",
                    "Hair support"
                ],
                protocol: "Topical (preferred for cosmetic): 0.1-0.3% serum/cream nightly × 12 weeks, then 3-5×/wk. Topical scar: 0.5-2.0% gel twice daily × 8-12 weeks. SC (systemic tissue repair): 2-3mg SC 3×/wk × 4-8 weeks for MSK/connective tissue support",
                rationale: "Slow collagen turnover; consistent topical beats injections for cosmetic applications. SC has systemic tissue repair benefits beyond cosmetic—relevant for MSK recovery contexts",
                contraindications: [
                    "Copper staining on fabrics with topical",
                    "Avoid concurrent strong acids that may chelate"
                ],
                signals: [
                    "Texture/elasticity ↑ by week 4-8",
                    "Scar color flattens by week 8-12",
                    "Improved tissue quality with SC protocols"
                ],
                cost: .medium,
                evidence: .strong,
                notes: nil,
                synergies: ["bpc157", "tb500", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdfa",
                    borderColor: "#2dd4bf",
                    accentColor: "#0d9488",
                    bulletColor: "#99f6e4",
                    badgeBg: "#ccfbf1",
                    badgeText: "#134e4a",
                    badgeBorder: "#5eead4"
                )
            ),
            
            Peptide(
                id: "kpv",
                name: "KPV",
                category: .healing,
                description: "Anti-inflammatory peptide",
                mechanism: "α-MSH fragment, NF-κB down-regulation, mast-cell stabilization",
                typicalDose: "250-1000 mcg",
                cycleLength: "4-8 weeks",
                frequency: "Daily",
                benefits: [
                    "Mucosal inflammation",
                    "IBD symptom support",
                    "Post-injury swelling"
                ],
                protocol: "Systemic 250-1000µg SC daily × 4-8 weeks OR Dermal 0.1-0.5% topical cream 1-2×/day to affected areas",
                rationale: "Daily steady signaling; taper to 2-3×/wk when stable for acute interventions",
                contraindications: [
                    "Hypotension-prone → start lower dose"
                ],
                signals: [
                    "Less \"hot\" swelling",
                    "Improved stool calmness/urgency in IBD-adjacent use",
                    "Reduced inflammatory markers"
                ],
                cost: .low,
                evidence: .strong,
                notes: nil,
                synergies: ["bpc157", "tb500"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdfa",
                    borderColor: "#2dd4bf",
                    accentColor: "#0d9488",
                    bulletColor: "#99f6e4",
                    badgeBg: "#ccfbf1",
                    badgeText: "#134e4a",
                    badgeBorder: "#5eead4"
                )
            ),
            
            Peptide(
                id: "ara290",
                name: "ARA-290",
                category: .healing,
                description: "Neuropathic pain & nerve healing",
                mechanism: "Innate repair receptor agonist, tissue-protective signaling",
                typicalDose: "2-4mg",
                cycleLength: "4-12 weeks",
                frequency: "Daily",
                benefits: [
                    "Neuropathic pain reduction",
                    "Nerve injury recovery",
                    "Improved sleep"
                ],
                protocol: "Standard 2-4mg SC daily × 28 days for acute neuropathic pain. Extended: Can extend to 12 weeks for chronic neuropathy under supervision",
                rationale: "Activates tissue-protective pathways distinct from erythropoietin's hematologic effects; 28-day cycles common in clinical trials",
                contraindications: [
                    "Monitor for injection site reactions",
                    "Limited long-term safety data"
                ],
                signals: [
                    "Neuropathic pain ↓ (burning, tingling, shooting pain)",
                    "Improved nerve conduction subjectively",
                    "Better sleep quality"
                ],
                cost: .high,
                evidence: .strong,
                notes: "Diabetic neuropathy patients report significant pain reduction by week 2-3; post-surgical nerve injury shows improved sensation by week 4-6",
                synergies: ["bpc157", "tb500", "p21"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdfa",
                    borderColor: "#2dd4bf",
                    accentColor: "#0d9488",
                    bulletColor: "#99f6e4",
                    badgeBg: "#ccfbf1",
                    badgeText: "#134e4a",
                    badgeBorder: "#5eead4"
                )
            ),
            
            Peptide(
                id: "cartalax",
                name: "Cartalax",
                category: .healing,
                description: "Cartilage & joint support",
                mechanism: "Gene-expression normalization in chondrocytes",
                typicalDose: "2mg",
                cycleLength: "10-20 days",
                frequency: "Daily (pulse)",
                benefits: [
                    "Joint comfort",
                    "Cartilage symptoms",
                    "Reduced stiffness"
                ],
                protocol: "2mg SC daily × 10-20 days → off 2-4 weeks; repeat if helpful",
                rationale: "Short pulses intended to \"nudge\" trophic signaling. Effects reported to persist 3-4 months post-course",
                contraindications: [
                    "Limited modern trial data—use as adjunct to proven therapies"
                ],
                signals: [
                    "Morning creak/stiffness ↓",
                    "Step-down pain ↓",
                    "Improved joint comfort"
                ],
                cost: .medium,
                evidence: .limited,
                notes: "While clinical anecdotes suggest benefit, high-quality controlled trials are limited. Consider as experimental adjunct rather than primary intervention",
                synergies: ["bpc157", "tb500"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e2e8f0",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#f1f5f9",
                    badgeText: "#334155",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            // MARK: - Cognitive / Nootropic
            
            Peptide(
                id: "semax",
                name: "Semax",
                category: .cognitive,
                description: "Cognitive drive & focus",
                mechanism: "ACTH analog, BDNF up-regulation, dopaminergic modulation",
                typicalDose: "300-600 mcg",
                cycleLength: "10-14 days",
                frequency: "As needed",
                benefits: [
                    "Cognitive drive",
                    "Focus enhancement",
                    "Post-TBI support"
                ],
                protocol: "Intranasal 300-600µg/day (split 2-3 doses) × 10-14 days → 2-3 days off; up to 1000µg/day short spurts during acute cognitive load. SC (less common): 0.1-0.3mg daily × 10-14 days. N-Acetyl Semax: Amidated version has extended half-life; often dosed slightly lower (200-600µg/day)",
                rationale: "Pulsed cycles to avoid tolerance; higher dose bursts for exams/presentations; amidate versions reduce dosing frequency needs",
                contraindications: [
                    "Over-activation/insomnia at high doses",
                    "Separate from stimulants by several hours",
                    "Bipolar disorder (may trigger hypomania)"
                ],
                signals: [
                    "Task initiation ↑",
                    "Working-memory \"snap,\" less word-finding lag",
                    "Improved mental endurance"
                ],
                cost: .medium,
                evidence: .strong,
                notes: "Students report sustained focus during exam periods without stimulant jitteriness; post-viral cognitive recovery improved by week 2-3",
                synergies: ["selank", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#fff7ed",
                    borderColor: "#fb923c",
                    accentColor: "#ea580c",
                    bulletColor: "#fdba74",
                    badgeBg: "#fed7aa",
                    badgeText: "#7c2d12",
                    badgeBorder: "#fdba74"
                )
            ),
            
            Peptide(
                id: "selank",
                name: "Selank",
                category: .cognitive,
                description: "Anxiolytic & stress resilience",
                mechanism: "Tuftsin analog, GABAergic modulation, anti-inflammatory",
                typicalDose: "200-600 mcg",
                cycleLength: "14-28 days",
                frequency: "As needed",
                benefits: [
                    "Anxiety reduction",
                    "Stress resilience",
                    "Improved mood"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["semax", "dsip"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#fff7ed",
                    borderColor: "#fb923c",
                    accentColor: "#ea580c",
                    bulletColor: "#fdba74",
                    badgeBg: "#fed7aa",
                    badgeText: "#7c2d12",
                    badgeBorder: "#fdba74"
                )
            ),
            
            Peptide(
                id: "p21",
                name: "P21",
                category: .cognitive,
                description: "Neuroplasticity enhancer",
                mechanism: "BDNF upregulation, synaptic plasticity enhancement",
                typicalDose: "500mcg - 1mg",
                cycleLength: "4-8 weeks",
                frequency: "Daily (pre-training)",
                benefits: [
                    "Motor learning",
                    "Neuroplasticity",
                    "Post-TBI recovery"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["semax", "ara290"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#fff7ed",
                    borderColor: "#fb923c",
                    accentColor: "#ea580c",
                    bulletColor: "#fdba74",
                    badgeBg: "#fed7aa",
                    badgeText: "#7c2d12",
                    badgeBorder: "#fdba74"
                )
            ),
            
            Peptide(
                id: "dsip",
                name: "DSIP",
                category: .cognitive,
                description: "Sleep onset & circadian support",
                mechanism: "Modulates sleep-arousal networks via hypothalamic signaling",
                typicalDose: "100-300 mcg",
                cycleLength: "2-3 weeks",
                frequency: "Nightly (pre-bed)",
                benefits: [
                    "Faster sleep onset",
                    "Fewer awakenings",
                    "Improved sleep continuity"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["sermorelin", "pinealon", "selank"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#fff7ed",
                    borderColor: "#fb923c",
                    accentColor: "#ea580c",
                    bulletColor: "#fdba74",
                    badgeBg: "#fed7aa",
                    badgeText: "#7c2d12",
                    badgeBorder: "#fdba74"
                )
            ),
            
            Peptide(
                id: "epitalon",
                name: "Epitalon",
                category: .cognitive,
                description: "Circadian & longevity support",
                mechanism: "Telomere/clock-gene regulation, melatonin modulation",
                typicalDose: "5-10mg",
                cycleLength: "10-20 days",
                frequency: "Daily (pulse)",
                benefits: [
                    "Sleep quality",
                    "Circadian regularity",
                    "Stress resilience"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["pinealon", "vip"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e2e8f0",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#f1f5f9",
                    badgeText: "#334155",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            Peptide(
                id: "pinealon",
                name: "Pinealon",
                category: .cognitive,
                description: "CNS trophic support",
                mechanism: "Oligopeptide regulatory effects on brain tissue",
                typicalDose: "10mg",
                cycleLength: "10 days",
                frequency: "Daily (pulse)",
                benefits: [
                    "Cognitive support",
                    "Neuroprotection",
                    "Stress resilience"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["dsip", "epitalon"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#e2e8f0",
                    borderColor: "#94a3b8",
                    accentColor: "#475569",
                    bulletColor: "#cbd5e1",
                    badgeBg: "#f1f5f9",
                    badgeText: "#334155",
                    badgeBorder: "#cbd5e1"
                )
            ),
            
            // MARK: - Growth Hormone Axis
            
            Peptide(
                id: "tesamorelin",
                name: "Tesamorelin",
                category: .growthHormone,
                description: "Visceral fat reduction via GH",
                mechanism: "Stimulates pituitary GH release, IGF-1 elevation, lipolysis",
                typicalDose: "1-2mg",
                cycleLength: "12-16 weeks",
                frequency: "3-5x / week (pre-bed)",
                benefits: [
                    "Visceral fat reduction",
                    "Improved body composition",
                    "Enhanced recovery"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["ipamorelin", "aod9604", "retatrutide"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#eff6ff",
                    borderColor: "#60a5fa",
                    accentColor: "#2563eb",
                    bulletColor: "#93c5fd",
                    badgeBg: "#dbeafe",
                    badgeText: "#1e3a8a",
                    badgeBorder: "#93c5fd"
                )
            ),
            
            Peptide(
                id: "sermorelin",
                name: "Sermorelin",
                category: .growthHormone,
                description: "Pulsatile GH release",
                mechanism: "Pulsatile GH release from pituitary, modest IGF-1 rise",
                typicalDose: "100-300 mcg",
                cycleLength: "8-12 weeks",
                frequency: "3-5x / week (pre-bed)",
                benefits: [
                    "Sleep quality",
                    "Enhanced recovery",
                    "Modest body composition"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["ipamorelin", "dsip"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#eff6ff",
                    borderColor: "#60a5fa",
                    accentColor: "#2563eb",
                    bulletColor: "#93c5fd",
                    badgeBg: "#dbeafe",
                    badgeText: "#1e3a8a",
                    badgeBorder: "#93c5fd"
                )
            ),
            
            Peptide(
                id: "ipamorelin",
                name: "Ipamorelin",
                category: .growthHormone,
                description: "Clean GH secretagogue",
                mechanism: "Selective GHS-R agonist, GH release without prolactin/cortisol",
                typicalDose: "200-300 mcg",
                cycleLength: "8-12 weeks",
                frequency: "3-5x / week (pre-bed)",
                benefits: [
                    "Deeper sleep",
                    "Enhanced recovery",
                    "Improved training capacity"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["sermorelin", "tesamorelin"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#eff6ff",
                    borderColor: "#60a5fa",
                    accentColor: "#2563eb",
                    bulletColor: "#93c5fd",
                    badgeBg: "#dbeafe",
                    badgeText: "#1e3a8a",
                    badgeBorder: "#93c5fd"
                )
            ),
            
            // MARK: - Immune / Inflammation
            
            Peptide(
                id: "thymosinalpha1",
                name: "Thymosin-α1",
                category: .immune,
                description: "Immune modulation & post-viral support",
                mechanism: "Enhances T-cell function, upregulates MHC, re-balances Th1/Th2",
                typicalDose: "1.6-3.2mg",
                cycleLength: "6-12 weeks",
                frequency: "2-3x / Week",
                benefits: [
                    "Infection frequency reduction",
                    "Faster viral recovery",
                    "Improved energy"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["nad", "vip"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdf4",
                    borderColor: "#4ade80",
                    accentColor: "#16a34a",
                    bulletColor: "#86efac",
                    badgeBg: "#dcfce7",
                    badgeText: "#14532d",
                    badgeBorder: "#86efac"
                )
            ),
            
            Peptide(
                id: "vip",
                name: "VIP",
                category: .immune,
                description: "MCAS & dysautonomia support",
                mechanism: "VPAC receptor activation, anti-inflammatory, mast cell modulation",
                typicalDose: "50-200 mcg",
                cycleLength: "4-8 weeks",
                frequency: "1-2x / day",
                benefits: [
                    "Heat intolerance reduction",
                    "Brain fog reduction",
                    "HRV improvement"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["kpv", "thymosinalpha1", "nad"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#f0fdf4",
                    borderColor: "#4ade80",
                    accentColor: "#16a34a",
                    bulletColor: "#86efac",
                    badgeBg: "#dcfce7",
                    badgeText: "#14532d",
                    badgeBorder: "#86efac"
                )
            ),
            
            // MARK: - Reproductive / Endocrine
            
            Peptide(
                id: "kisspeptin",
                name: "Kisspeptin-10",
                category: .hpta,
                description: "HPG-axis support",
                mechanism: "Stimulates GnRH neurons, pulsatile LH/FSH release",
                typicalDose: "50-750 mcg",
                cycleLength: "4-12 weeks",
                frequency: "2-3x / Week",
                benefits: [
                    "Libido improvement",
                    "LH/FSH elevation",
                    "Testicular function"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["hcg"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#fce7f3",
                    borderColor: "#f9a8d4",
                    accentColor: "#db2777",
                    bulletColor: "#fbcfe8",
                    badgeBg: "#fce7f3",
                    badgeText: "#9f1239",
                    badgeBorder: "#f9a8d4"
                )
            ),
            
            Peptide(
                id: "hcg",
                name: "hCG",
                category: .hpta,
                description: "Testicular maintenance & fertility",
                mechanism: "Mimics LH, stimulates Leydig/theca cells",
                typicalDose: "500-2000 IU",
                cycleLength: "4-24 weeks",
                frequency: "2-3x / Week",
                benefits: [
                    "Testicular volume maintenance",
                    "Libido",
                    "Semen quality"
                ],
                protocol: nil,
                rationale: nil,
                contraindications: nil,
                signals: nil,
                cost: nil,
                evidence: nil,
                notes: nil,
                synergies: ["kisspeptin"],
                colorScheme: PeptideColorScheme(
                    bgColor: "#fce7f3",
                    borderColor: "#f9a8d4",
                    accentColor: "#db2777",
                    bulletColor: "#fbcfe8",
                    badgeBg: "#fce7f3",
                    badgeText: "#9f1239",
                    badgeBorder: "#f9a8d4"
                )
            )
        ]
    }
    
    // MARK: - Convenience Methods
    
    /// Retrieve a peptide by its unique identifier
    public func peptide(byID id: String) -> Peptide? {
        return allPeptides.first { $0.id == id }
    }
    
    /// Retrieve all peptides in a specific category
    public func peptides(byCategory category: PeptideCategory) -> [Peptide] {
        return allPeptides.filter { $0.category == category }
    }
    
    /// Search peptides by query (name, description, mechanism, benefits)
    public func search(query: String) -> [Peptide] {
        let lowercasedQuery = query.lowercased()
        return allPeptides.filter { peptide in
            peptide.name.lowercased().contains(lowercasedQuery) ||
            peptide.description.lowercased().contains(lowercasedQuery) ||
            peptide.mechanism.lowercased().contains(lowercasedQuery) ||
            peptide.benefits.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    /// Find synergistic peptides for a given peptide ID
    public func synergisticPairs(for peptideID: String) -> [Peptide] {
        guard let peptide = peptide(byID: peptideID) else {
            return []
        }
        
        return peptide.synergies.compactMap { synergyID in
            // Handle special cases like "hCG (alternating)", "GLP-1s"
            let cleanID = synergyID
                .replacingOccurrences(of: " (alternating)", with: "")
                .replacingOccurrences(of: " (alternate)", with: "")
                .lowercased()
            
            // Handle "GLP-1s" special case - return all GLP category peptides
            if cleanID == "glp-1s" {
                return nil // Could return all GLP category peptides if needed
            }
            
            return self.peptide(byID: cleanID)
        }
    }
    
    /// Get count of peptides by category
    public var categoryDistribution: [PeptideCategory: Int] {
        var distribution: [PeptideCategory: Int] = [:]
        for peptide in allPeptides {
            distribution[peptide.category, default: 0] += 1
        }
        return distribution
    }
    
    /// Total number of peptides in database
    public var totalCount: Int {
        allPeptides.count
    }
    
    /// Get peptides with strong or moderate evidence
    public var evidenceBasedPeptides: [Peptide] {
        allPeptides.filter { peptide in
            peptide.evidence == .strong || peptide.evidence == .moderate
        }
    }
    
    /// Get peptides by cost level
    public func peptides(byCost cost: CostLevel) -> [Peptide] {
        allPeptides.filter { $0.cost == cost }
    }
    
    /// Get all unique synergy relationships
    public var allSynergies: [(source: Peptide, target: Peptide)] {
        var synergies: [(Peptide, Peptide)] = []
        for peptide in allPeptides {
            let targets = synergisticPairs(for: peptide.id)
            for target in targets {
                synergies.append((peptide, target))
            }
        }
        return synergies
    }
}

// MARK: - Database Statistics Extension

extension PeptideDatabase {
    /// Database statistics for validation and debugging
    public struct Statistics {
        public let totalPeptides: Int
        public let byCategory: [PeptideCategory: Int]
        public let withFullProtocol: Int
        public let withContraindications: Int
        public let withStrongEvidence: Int
        public let averageSynergiesPerPeptide: Double
        
        init(database: PeptideDatabase) {
            totalPeptides = database.totalCount
            byCategory = database.categoryDistribution
            withFullProtocol = database.allPeptides.filter { $0.protocol != nil }.count
            withContraindications = database.allPeptides.filter { $0.hasWarnings }.count
            withStrongEvidence = database.allPeptides.filter { $0.evidence == .strong }.count
            
            let totalSynergies = database.allPeptides.reduce(0) { $0 + $1.synergies.count }
            averageSynergiesPerPeptide = Double(totalSynergies) / Double(totalPeptides)
        }
    }
    
    /// Get database statistics
    public var statistics: Statistics {
        Statistics(database: self)
    }
}
