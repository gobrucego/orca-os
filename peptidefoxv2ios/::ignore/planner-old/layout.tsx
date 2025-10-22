import type { ReactNode } from "react"
import type { Metadata } from "next"
import { ProtocolToolProviders } from "../protocol-tool/providers"

export const metadata: Metadata = {
  title: "Peptide Supply Planner - Calculate Vials Needed & Protocol Costs | Peptide Fox",
  description: "Plan your peptide supply requirements and calculate vials needed for Semaglutide, Tirzepatide, Retatrutide, BPC-157, NAD+, and GLOW protocols. Estimate costs, track inventory, and ensure you have enough peptides for your complete cycle.",
  keywords: [
    "peptide supply planner",
    "peptide vial calculator",
    "how many vials needed",
    "peptide cost calculator",
    "semaglutide supply",
    "sema vials needed",
    "tirzepatide vials",
    "tirz supply planner",
    "retatrutide supply",
    "reta vials",
    "BPC-157 supply",
    "BPC vials needed",
    "peptide protocol planning",
    "peptide inventory tracker",
    "GLOW supply calculator",
    "peptide cycle planning",
    "how much peptide do I need",
    "peptide dosing schedule",
    "GLP supply",
  ],
  openGraph: {
    title: "Peptide Supply Planner - Peptide Fox",
    description: "Plan your peptide supply needs and calculate vials required for Semaglutide, Tirzepatide, Retatrutide, BPC-157, GLOW, and more.",
    type: "website",
  },
}

export default function PlannerLayout({
  children,
}: {
  children: ReactNode
}) {
  return <ProtocolToolProviders>{children}</ProtocolToolProviders>
}