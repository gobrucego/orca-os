# PeptideDatabase

Central peptide database for the PeptideFox iOS app. This is the **single source of truth** for all peptide information, ported directly from the TypeScript source (`lib/peptide-data.ts`).

## Overview

The `PeptideDatabase` provides a complete, medically accurate database of 28 peptides across 7 categories:

- **GLP-1 Agonists** (3): Semaglutide, Tirzepatide, Retatrutide
- **Metabolic** (6): SS-31, MOTS-c, NAD+, AOD-9604, L-Carnitine, 5-Amino-1MQ
- **Healing** (6): BPC-157, TB-500, GHK-Cu, KPV, ARA-290, Cartalax
- **Cognitive** (6): Semax, Selank, P21, DSIP, Epitalon, Pinealon
- **Growth Hormone** (3): Tesamorelin, Sermorelin, Ipamorelin
- **Immune** (2): Thymosin-α1, VIP
- **HPTA** (2): Kisspeptin-10, hCG

## Medical Data Integrity

**CRITICAL**: This database contains medical information. The following principles MUST be followed:

1. **NEVER fabricate medical data** - all information comes from the TypeScript source
2. **NEVER modify contraindications** - these are safety-critical
3. **NEVER change dosing information** - could lead to harmful outcomes
4. **ALWAYS preserve protocol details** - clinical guidance is essential
5. **MAINTAIN exact text** - medical terminology must be precise

## Data Structure

Each `Peptide` contains:

### Core Properties
- `id`: Unique identifier (lowercase, no spaces)
- `name`: Display name
- `category`: One of 7 categories
- `description`: One-line summary
- `mechanism`: How it works
- `typicalDose`: Standard dosing range
- `cycleLength`: Recommended cycle duration
- `frequency`: Injection frequency
- `benefits`: Array of clinical benefits

### Enhanced Clinical Fields
- `protocol`: Detailed dosing protocol (optional)
- `rationale`: Clinical reasoning (optional)
- `contraindications`: Safety warnings (array, optional)
- `signals`: Success indicators (array, optional)
- `cost`: Relative cost level (Low/Medium/High/Very High, optional)
- `evidence`: Clinical evidence strength (Strong/Moderate/Limited/Experimental, optional)
- `notes`: Additional clinical notes (optional)

### Relationships & Styling
- `synergies`: Array of peptide IDs that work well in combination
- `colorScheme`: Visual styling with 7 hex color properties

## Usage

### Basic Access

```swift
// Get the shared database instance
let db = PeptideDatabase.shared

// Get a specific peptide
if let semaglutide = db.peptide(byID: "semaglutide") {
    print(semaglutide.name)
    print(semaglutide.description)
    print(semaglutide.typicalDose)
}

// Get all peptides in a category
let glp1s = db.peptides(byCategory: .glp)
let healingPeptides = db.peptides(byCategory: .healing)
```

### Search

```swift
// Search by query (name, description, mechanism, benefits)
let results = db.search(query: "healing")
let fatLossPeptides = db.search(query: "fat")
```

### Synergies

```swift
// Find peptides that work well together
let synergies = db.synergisticPairs(for: "bpc157")
// Returns: [TB-500, GHK-Cu, KPV, ARA-290, NAD+]
```

### Filtering

```swift
// Get peptides by cost
let lowCost = db.peptides(byCost: .low)

// Get evidence-based peptides (strong or moderate evidence)
let evidenceBased = db.evidenceBasedPeptides

// Category distribution
let distribution = db.categoryDistribution
// Returns: [.glp: 3, .metabolic: 6, .healing: 6, ...]
```

### Statistics

```swift
// Get database statistics
let stats = db.statistics
print("Total: \(stats.totalPeptides)")
print("With full protocol: \(stats.withFullProtocol)")
print("With contraindications: \(stats.withContraindications)")
print("Strong evidence: \(stats.withStrongEvidence)")
```

## Examples

See `PeptideDatabaseExample.swift` for complete usage examples including:
- Getting specific peptides
- Category filtering
- Search functionality
- Synergy lookups
- Database validation
- Statistics reporting

## Validation

The database includes built-in validation:

```swift
let issues = PeptideDatabaseExamples.validateDatabase()
// Checks for:
// - Minimum peptide count
// - Category coverage
// - Duplicate IDs
// - Missing critical fields
// - GLP-1 contraindications
```

## File Organization

```
Core/Data/LocalData/
├── PeptideDatabase.swift          # Main database (1,198 lines)
├── PeptideDatabaseExample.swift   # Usage examples
└── README.md                      # This file
```

## Peptide ID Naming Convention

All peptide IDs follow these rules:
- Lowercase only
- No spaces or special characters
- Descriptive and unique
- Match TypeScript source exactly

Examples:
- `semaglutide` (not `Semaglutide` or `sema-glutide`)
- `bpc157` (not `bpc-157` or `BPC157`)
- `5amino1mq` (not `5-amino-1mq` or `5Amino1MQ`)

## Synergy ID Format

Synergy arrays use peptide IDs directly:
```swift
synergies: ["bpc157", "tb500", "nad"]
```

Special cases handled in code:
- `"hcg (alternating)"` → cleans to `"hcg"`
- `"GLP-1s"` → handled specially (could expand to all GLP category)

## Color Scheme Structure

Each peptide has a complete 7-color scheme for UI rendering:
- `bgColor`: Background color
- `borderColor`: Border color
- `accentColor`: Accent/highlight color
- `bulletColor`: Bullet point color
- `badgeBg`: Badge background
- `badgeText`: Badge text color
- `badgeBorder`: Badge border color

All colors are hex format: `"#RRGGBB"`

## Port History

- **Source**: `/lib/peptide-data.ts` (TypeScript)
- **Target**: `PeptideFoxModels/Core/Data/LocalData/PeptideDatabase.swift`
- **Ported**: 2025-10-20
- **Peptide Count**: 28 peptides
- **Data Integrity**: 100% preserved from source

## Maintenance

When updating the database:

1. **ALWAYS** update from TypeScript source
2. **NEVER** add peptides without medical source data
3. **VERIFY** contraindications are preserved exactly
4. **TEST** with validation examples
5. **DOCUMENT** any changes in this README

## Related Files

- `Core/Domain/Models/Peptide.swift` - Peptide model definition
- `Core/Domain/Models/Enums.swift` - Category, Cost, Evidence enums
- `Core/Domain/Models/ValueTypes.swift` - PeptideColorScheme struct

## Safety Notice

This database contains medical information for educational and research purposes. All peptide usage should be:
- Discussed with qualified healthcare providers
- Based on individual medical needs and contraindications
- Monitored for safety and efficacy
- Obtained from legitimate pharmaceutical sources

**This database is NOT medical advice.**
