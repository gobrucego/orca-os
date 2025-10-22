import Foundation

// MARK: - Peptide Database
public struct PeptideDatabase {
    public static nonisolated(unsafe) let all: [Peptide] = [
        // GLP-1 Family
        Peptide(
            id: "semaglutide",
            name: "Semaglutide",
            category: .glp1,
            description: "GLP-1 receptor agonist for weight loss and metabolic health",
            mechanism: "Mimics GLP-1 hormone to regulate appetite, slow gastric emptying, and improve insulin sensitivity",
            benefits: [
                "Significant weight loss (10-15% body weight)",
                "Improved glycemic control",
                "Reduced cardiovascular risk",
                "Decreased appetite and cravings"
            ],
            typicalDose: DoseRange(min: 0.25, max: 2.4, unit: "mg"),
            frequency: "Weekly",
            cycleLength: "Ongoing (chronic use)",
            contraindications: [
                "Personal or family history of medullary thyroid carcinoma",
                "Multiple endocrine neoplasia syndrome type 2",
                "Severe gastrointestinal disease"
            ],
            signals: [
                "Reduced hunger within 1-2 weeks",
                "Weight loss starts week 4-6",
                "Improved HbA1c in 12 weeks"
            ],
            synergies: ["tirzepatide", "bpc-157"],
            evidenceLevel: .high
        ),
        
        Peptide(
            id: "tirzepatide",
            name: "Tirzepatide",
            category: .glp1,
            description: "Dual GIP/GLP-1 receptor agonist with enhanced weight loss effects",
            mechanism: "Activates both GIP and GLP-1 receptors for superior metabolic effects",
            benefits: [
                "Superior weight loss (15-20% body weight)",
                "Enhanced insulin sensitivity",
                "Improved lipid profiles",
                "Better glycemic control than semaglutide"
            ],
            typicalDose: DoseRange(min: 2.5, max: 15.0, unit: "mg"),
            frequency: "Weekly",
            cycleLength: "Ongoing (chronic use)",
            contraindications: [
                "Personal or family history of medullary thyroid carcinoma",
                "Pancreatitis history",
                "Severe gastrointestinal disease"
            ],
            signals: [
                "Appetite suppression within days",
                "Weight loss starts week 2-4",
                "Peak effects at 20+ weeks"
            ],
            synergies: ["semaglutide", "nad+"],
            evidenceLevel: .high
        ),
        
        // Healing & Recovery
        Peptide(
            id: "bpc-157",
            name: "BPC-157",
            category: .healing,
            description: "Body Protection Compound for tissue repair and gut health",
            mechanism: "Promotes angiogenesis, accelerates wound healing, and protects against gastric damage",
            benefits: [
                "Accelerated tissue repair",
                "Improved gut health",
                "Reduced inflammation",
                "Enhanced tendon and ligament healing"
            ],
            typicalDose: DoseRange(min: 250, max: 1000, unit: "mcg"),
            frequency: "Daily or twice daily",
            cycleLength: "4-8 weeks, can extend to 12 weeks",
            contraindications: [
                "Active cancer (theoretical concern)",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Pain reduction within 1-2 weeks",
                "Improved mobility by week 2-3",
                "Gut symptoms improve within days"
            ],
            synergies: ["tb-500", "ghk-cu"],
            evidenceLevel: .moderate
        ),
        
        Peptide(
            id: "tb-500",
            name: "TB-500",
            category: .healing,
            description: "Thymosin Beta-4 fragment for systemic healing and recovery",
            mechanism: "Regulates actin formation, promotes cell migration, and reduces inflammation",
            benefits: [
                "Systemic tissue repair",
                "Improved flexibility and mobility",
                "Reduced chronic inflammation",
                "Enhanced recovery from injury"
            ],
            typicalDose: DoseRange(min: 2, max: 10, unit: "mg"),
            frequency: "2-3x per week",
            cycleLength: "4-6 weeks loading, then maintenance",
            contraindications: [
                "Active cancer (theoretical)",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Improved range of motion within 2 weeks",
                "Pain reduction by week 3-4",
                "Chronic injuries improve over 6-8 weeks"
            ],
            synergies: ["bpc-157", "ghk-cu"],
            evidenceLevel: .moderate
        ),
        
        Peptide(
            id: "ghk-cu",
            name: "GHK-Cu",
            category: .healing,
            description: "Copper peptide for skin health, wound healing, and anti-aging",
            mechanism: "Stimulates collagen synthesis, promotes angiogenesis, and acts as antioxidant",
            benefits: [
                "Enhanced skin appearance",
                "Improved wound healing",
                "Reduced inflammation",
                "Hair growth stimulation"
            ],
            typicalDose: DoseRange(min: 1, max: 3, unit: "mg"),
            frequency: "Daily",
            cycleLength: "8-12 weeks, can be ongoing",
            contraindications: [
                "Wilson's disease",
                "Copper sensitivity"
            ],
            signals: [
                "Skin texture improves within 2-3 weeks",
                "Visible anti-aging effects by week 6-8",
                "Hair growth visible after 3+ months"
            ],
            synergies: ["bpc-157", "tb-500"],
            evidenceLevel: .moderate
        ),
        
        // Longevity
        Peptide(
            id: "nad+",
            name: "NAD+",
            category: .longevity,
            description: "Nicotinamide adenine dinucleotide for cellular energy and longevity",
            mechanism: "Essential coenzyme for cellular metabolism, DNA repair, and mitochondrial function",
            benefits: [
                "Enhanced cellular energy",
                "Improved cognitive function",
                "Better metabolic health",
                "Anti-aging effects"
            ],
            typicalDose: DoseRange(min: 50, max: 500, unit: "mg"),
            frequency: "2-3x per week or daily",
            cycleLength: "Ongoing (chronic use)",
            contraindications: [
                "Pregnancy and breastfeeding",
                "Active infections (may increase demand)"
            ],
            signals: [
                "Energy increase within days",
                "Mental clarity improves week 1-2",
                "Sleep quality improves within weeks"
            ],
            synergies: ["tirzepatide", "mots-c"],
            evidenceLevel: .emerging
        ),
        
        // Cognitive
        Peptide(
            id: "semax",
            name: "Semax",
            category: .cognitive,
            description: "Nootropic peptide for cognitive enhancement and neuroprotection",
            mechanism: "Increases BDNF, enhances neurotransmitter activity, and protects neurons",
            benefits: [
                "Improved focus and concentration",
                "Enhanced memory formation",
                "Neuroprotection",
                "Reduced anxiety and stress"
            ],
            typicalDose: DoseRange(min: 300, max: 1000, unit: "mcg"),
            frequency: "Daily (intranasal)",
            cycleLength: "4-8 weeks, then break",
            contraindications: [
                "Epilepsy",
                "Schizophrenia",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Focus improves within hours",
                "Memory enhancement within days",
                "Mood elevation within 1-2 weeks"
            ],
            synergies: [],
            evidenceLevel: .moderate
        ),
        
        // Metabolic
        Peptide(
            id: "mots-c",
            name: "MOTS-c",
            category: .metabolic,
            description: "Mitochondrial-derived peptide for metabolic health and exercise performance",
            mechanism: "Regulates mitochondrial function, improves insulin sensitivity, and enhances fat oxidation",
            benefits: [
                "Improved metabolic flexibility",
                "Enhanced exercise performance",
                "Better insulin sensitivity",
                "Increased fat oxidation"
            ],
            typicalDose: DoseRange(min: 5, max: 15, unit: "mg"),
            frequency: "2-3x per week",
            cycleLength: "8-12 weeks",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Energy increase within days",
                "Exercise capacity improves week 2-3",
                "Metabolic markers improve by week 6-8"
            ],
            synergies: ["nad+", "semaglutide"],
            evidenceLevel: .emerging
        ),

        Peptide(
            id: "retatrutide",
            name: "Retatrutide",
            category: .glp1,
            description: "Triple agonist for aggressive fat loss",
            mechanism: "GLP-1 (satiety), GIP (insulinotropic), glucagon (lipolysis) agonist",
            benefits: [
                "Aggressive fat loss",
                "Energy expenditure",
                "Satiety control"
            ],
            typicalDose: DoseRange(min: 1, max: 2, unit: "mg"),
            frequency: "q2d - Weekly",
            cycleLength: "12-24 weeks",
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
            synergies: ["tesamorelin", "mots-c", "lcarnitine", "nad+"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "ss31",
            name: "SS-31",
            category: .metabolic,
            description: "Mitochondrial function optimizer",
            mechanism: "Binds cardiolipin, stabilizes cristae, improves electron transport",
            benefits: [
                "Reduces fatigue",
                "Improves HRV",
                "Lowers post-exertional malaise"
            ],
            typicalDose: DoseRange(min: 5, max: 20, unit: "mg"),
            frequency: "3-5x / Week",
            cycleLength: "4-8 weeks",
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
            synergies: ["nad+", "mots-c"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "aod9604",
            name: "AOD-9604",
            category: .metabolic,
            description: "Fat mobilization support",
            mechanism: "Lipolysis signaling via GH fragment",
            benefits: [
                "Fat mobilization",
                "Gentle cut support",
                "No hyperglycemia"
            ],
            typicalDose: DoseRange(min: 250, max: 500, unit: "mcg"),
            frequency: "Daily (AM fasted)",
            cycleLength: "6-12 weeks",
            contraindications: [
                "Limited robust clinical data",
                "Generally well-tolerated"
            ],
            signals: [
                "Subtle effects",
                "Improved fat mobilization markers",
                "Not dramatic standalone—works best in comprehensive program"
            ],
            synergies: ["mots-c", "lcarnitine", "retatrutide", "tesamorelin"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "lcarnitine",
            name: "L-Carnitine",
            category: .metabolic,
            description: "Fat oxidation & endurance",
            mechanism: "Carnitine shuttle for fatty acid transport to mitochondria",
            benefits: [
                "Fat oxidation",
                "Endurance enhancement",
                "Muscle recovery"
            ],
            typicalDose: DoseRange(min: 200, max: 400, unit: "mg"),
            frequency: "3-5x / week (IM - pre-training)",
            cycleLength: "4-8 weeks",
            contraindications: [
                "Fishy odor (TMA production in some individuals)",
                "GI upset with oral—split doses or switch to IM",
                "Seizure disorders (rare reports of lowered threshold)"
            ],
            signals: [
                "Endurance floor rises (less fatigue at submaximal efforts)",
                "Improved recovery between training sessions",
                "Better fat utilization during fasted cardio"
            ],
            synergies: ["mots-c", "retatrutide"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "5amino1mq",
            name: "5-Amino-1MQ",
            category: .metabolic,
            description: "Body recomp via NNMT inhibition",
            mechanism: "Inhibits NNMT, shifts methyl/NAD metabolism",
            benefits: [
                "Fat loss",
                "Metabolic flexibility",
                "Insulin sensitivity"
            ],
            typicalDose: DoseRange(min: 25, max: 50, unit: "mg"),
            frequency: "Daily",
            cycleLength: "4-6 weeks",
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
            synergies: ["nad+", "mots-c", "lcarnitine", "retatrutide"],
            evidenceLevel: .emerging
        ),

        Peptide(
            id: "kpv",
            name: "KPV",
            category: .healing,
            description: "Anti-inflammatory peptide",
            mechanism: "α-MSH fragment, NF-κB down-regulation, mast-cell stabilization",
            benefits: [
                "Mucosal inflammation",
                "IBD symptom support",
                "Post-injury swelling"
            ],
            typicalDose: DoseRange(min: 250, max: 1000, unit: "mcg"),
            frequency: "Daily",
            cycleLength: "4-8 weeks",
            contraindications: [
                "Hypotension-prone → start lower dose"
            ],
            signals: [
                "Less hot swelling",
                "Improved stool calmness/urgency in IBD-adjacent use",
                "Reduced inflammatory markers"
            ],
            synergies: ["bpc-157", "tb-500"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "ara290",
            name: "ARA-290",
            category: .healing,
            description: "Neuropathic pain & nerve healing",
            mechanism: "Innate repair receptor agonist, tissue-protective signaling",
            benefits: [
                "Neuropathic pain reduction",
                "Nerve injury recovery",
                "Improved sleep"
            ],
            typicalDose: DoseRange(min: 2, max: 4, unit: "mg"),
            frequency: "Daily",
            cycleLength: "4-12 weeks",
            contraindications: [
                "Monitor for injection site reactions",
                "Limited long-term safety data"
            ],
            signals: [
                "Neuropathic pain ↓ (burning, tingling, shooting pain)",
                "Improved nerve conduction subjectively",
                "Better sleep quality"
            ],
            synergies: ["bpc-157", "tb-500", "p21"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "cartalax",
            name: "Cartalax",
            category: .healing,
            description: "Cartilage & joint support",
            mechanism: "Gene-expression normalization in chondrocytes",
            benefits: [
                "Joint comfort",
                "Cartilage symptoms",
                "Reduced stiffness"
            ],
            typicalDose: DoseRange(min: 2, max: 2, unit: "mg"),
            frequency: "Daily (pulse)",
            cycleLength: "10-20 days",
            contraindications: [
                "Limited modern trial data—use as adjunct to proven therapies"
            ],
            signals: [
                "Morning creak/stiffness ↓",
                "Step-down pain ↓",
                "Improved joint comfort"
            ],
            synergies: ["bpc-157", "tb-500"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "selank",
            name: "Selank",
            category: .cognitive,
            description: "Anxiolytic & stress resilience",
            mechanism: "Tuftsin analog, GABAergic modulation, anti-inflammatory",
            benefits: [
                "Anxiety reduction",
                "Stress resilience",
                "Improved mood"
            ],
            typicalDose: DoseRange(min: 200, max: 600, unit: "mcg"),
            frequency: "As needed",
            cycleLength: "14-28 days",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Reduced anxiety within days",
                "Improved stress tolerance",
                "Better mood regulation"
            ],
            synergies: ["semax", "dsip"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "p21",
            name: "P21",
            category: .cognitive,
            description: "Neuroplasticity enhancer",
            mechanism: "BDNF upregulation, synaptic plasticity enhancement",
            benefits: [
                "Motor learning",
                "Neuroplasticity",
                "Post-TBI recovery"
            ],
            typicalDose: DoseRange(min: 500, max: 1000, unit: "mcg"),
            frequency: "Daily (pre-training)",
            cycleLength: "4-8 weeks",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Improved learning speed",
                "Enhanced skill acquisition",
                "Better cognitive recovery"
            ],
            synergies: ["semax", "ara290"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "dsip",
            name: "DSIP",
            category: .cognitive,
            description: "Sleep onset & circadian support",
            mechanism: "Modulates sleep-arousal networks via hypothalamic signaling",
            benefits: [
                "Faster sleep onset",
                "Fewer awakenings",
                "Improved sleep continuity"
            ],
            typicalDose: DoseRange(min: 100, max: 300, unit: "mcg"),
            frequency: "Nightly (pre-bed)",
            cycleLength: "2-3 weeks",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Faster sleep onset within days",
                "Better sleep quality",
                "Reduced nighttime awakenings"
            ],
            synergies: ["sermorelin", "pinealon", "selank"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "epitalon",
            name: "Epitalon",
            category: .cognitive,
            description: "Circadian & longevity support",
            mechanism: "Telomere/clock-gene regulation, melatonin modulation",
            benefits: [
                "Sleep quality",
                "Circadian regularity",
                "Stress resilience"
            ],
            typicalDose: DoseRange(min: 5, max: 10, unit: "mg"),
            frequency: "Daily (pulse)",
            cycleLength: "10-20 days",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Improved sleep quality",
                "Better circadian rhythm",
                "Enhanced recovery"
            ],
            synergies: ["pinealon", "vip"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "pinealon",
            name: "Pinealon",
            category: .cognitive,
            description: "CNS trophic support",
            mechanism: "Oligopeptide regulatory effects on brain tissue",
            benefits: [
                "Cognitive support",
                "Neuroprotection",
                "Stress resilience"
            ],
            typicalDose: DoseRange(min: 10, max: 10, unit: "mg"),
            frequency: "Daily (pulse)",
            cycleLength: "10 days",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Improved cognitive function",
                "Better stress management",
                "Enhanced mental clarity"
            ],
            synergies: ["dsip", "epitalon"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "tesamorelin",
            name: "Tesamorelin",
            category: .growthHormone,
            description: "Visceral fat reduction via GH",
            mechanism: "Stimulates pituitary GH release, IGF-1 elevation, lipolysis",
            benefits: [
                "Visceral fat reduction",
                "Improved body composition",
                "Enhanced recovery"
            ],
            typicalDose: DoseRange(min: 1, max: 2, unit: "mg"),
            frequency: "3-5x / week (pre-bed)",
            cycleLength: "12-16 weeks",
            contraindications: [
                "Active malignancy",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Visceral fat reduction within 6-8 weeks",
                "Improved body composition",
                "Better recovery"
            ],
            synergies: ["ipamorelin", "aod9604", "retatrutide"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "sermorelin",
            name: "Sermorelin",
            category: .growthHormone,
            description: "Pulsatile GH release",
            mechanism: "Pulsatile GH release from pituitary, modest IGF-1 rise",
            benefits: [
                "Sleep quality",
                "Enhanced recovery",
                "Modest body composition"
            ],
            typicalDose: DoseRange(min: 100, max: 300, unit: "mcg"),
            frequency: "3-5x / week (pre-bed)",
            cycleLength: "8-12 weeks",
            contraindications: [
                "Active malignancy",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Better sleep quality",
                "Improved recovery",
                "Gradual body composition changes"
            ],
            synergies: ["ipamorelin", "dsip"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "ipamorelin",
            name: "Ipamorelin",
            category: .growthHormone,
            description: "Clean GH secretagogue",
            mechanism: "Selective GHS-R agonist, GH release without prolactin/cortisol",
            benefits: [
                "Deeper sleep",
                "Enhanced recovery",
                "Improved training capacity"
            ],
            typicalDose: DoseRange(min: 200, max: 300, unit: "mcg"),
            frequency: "3-5x / week (pre-bed)",
            cycleLength: "8-12 weeks",
            contraindications: [
                "Active malignancy",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Sleep depth improves within days",
                "Better recovery markers",
                "Enhanced training capacity"
            ],
            synergies: ["sermorelin", "tesamorelin"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "thymosinalpha1",
            name: "Thymosin-α1",
            category: .immune,
            description: "Immune modulation & post-viral support",
            mechanism: "Enhances T-cell function, upregulates MHC, re-balances Th1/Th2",
            benefits: [
                "Infection frequency reduction",
                "Faster viral recovery",
                "Improved energy"
            ],
            typicalDose: DoseRange(min: 1.6, max: 3.2, unit: "mg"),
            frequency: "2-3x / Week",
            cycleLength: "6-12 weeks",
            contraindications: [
                "Autoimmune conditions (consult physician)",
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Reduced infection frequency",
                "Faster recovery from illness",
                "Improved overall energy"
            ],
            synergies: ["nad+", "vip"],
            evidenceLevel: .high
        ),

        Peptide(
            id: "vip",
            name: "VIP",
            category: .immune,
            description: "MCAS & dysautonomia support",
            mechanism: "VPAC receptor activation, anti-inflammatory, mast cell modulation",
            benefits: [
                "Heat intolerance reduction",
                "Brain fog reduction",
                "HRV improvement"
            ],
            typicalDose: DoseRange(min: 50, max: 200, unit: "mcg"),
            frequency: "1-2x / day",
            cycleLength: "4-8 weeks",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Reduced heat intolerance",
                "Clearer cognition",
                "Better HRV metrics"
            ],
            synergies: ["kpv", "thymosinalpha1", "nad+"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "kisspeptin",
            name: "Kisspeptin-10",
            category: .reproductive,
            description: "HPG-axis support",
            mechanism: "Stimulates GnRH neurons, pulsatile LH/FSH release",
            benefits: [
                "Libido improvement",
                "LH/FSH elevation",
                "Testicular function"
            ],
            typicalDose: DoseRange(min: 50, max: 750, unit: "mcg"),
            frequency: "2-3x / Week",
            cycleLength: "4-12 weeks",
            contraindications: [
                "Pregnancy and breastfeeding"
            ],
            signals: [
                "Improved libido",
                "Better hormonal balance",
                "Enhanced reproductive function"
            ],
            synergies: ["hcg"],
            evidenceLevel: .moderate
        ),

        Peptide(
            id: "hcg",
            name: "hCG",
            category: .reproductive,
            description: "Testicular maintenance & fertility",
            mechanism: "Mimics LH, stimulates Leydig/theca cells",
            benefits: [
                "Testicular volume maintenance",
                "Libido",
                "Semen quality"
            ],
            typicalDose: DoseRange(min: 500, max: 2000, unit: "IU"),
            frequency: "2-3x / Week",
            cycleLength: "4-24 weeks",
            contraindications: [
                "Hormone-sensitive cancers",
                "Pregnancy (for males)"
            ],
            signals: [
                "Maintained testicular volume",
                "Improved libido",
                "Better fertility markers"
            ],
            synergies: ["kisspeptin"],
            evidenceLevel: .high
        )
    ]
    
    public static func peptide(withId id: String) -> Peptide? {
        all.first { $0.id == id }
    }
    
    public static func peptides(in category: PeptideCategory) -> [Peptide] {
        all.filter { $0.category == category }
    }
    
    public static func search(query: String) -> [Peptide] {
        guard !query.isEmpty else { return all }
        
        let lowercasedQuery = query.lowercased()
        return all.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery) ||
            $0.benefits.joined().lowercased().contains(lowercasedQuery)
        }
    }
}
