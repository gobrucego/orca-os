import type { ReactNode } from "react"
import type { Metadata } from "next"
import { ProtocolToolProviders } from "../protocol-tool/providers"

export const metadata: Metadata = {
  title: "Peptide Protocol Tracker - Track Doses, Progress & Cycles | Peptide Fox",
  description: "Track your peptide injections, monitor dose progress, and manage multiple protocols for Semaglutide, Tirzepatide, Retatrutide, BPC-157, NAD+, and GLOW. Log doses taken, track cycle progress, and stay on schedule with your peptide protocols.",
  keywords: [
    "peptide protocol tracker",
    "track peptide doses",
    "peptide injection tracker",
    "peptide dose log",
    "semaglutide tracker",
    "sema dose tracking",
    "tirzepatide progress tracker",
    "tirz cycle tracker",
    "retatrutide tracker",
    "reta progress",
    "BPC-157 tracker",
    "BPC dose log",
    "peptide cycle tracker",
    "track peptide injections",
    "GLOW protocol tracker",
    "peptide dosing schedule",
    "GLP-1 tracking",
    "peptide progress monitor",
    "wolverine stack tracker",
    "peptide journal",
  ],
  openGraph: {
    title: "Peptide Protocol Tracker - Peptide Fox",
    description: "Track your peptide doses, monitor progress, and manage protocols for Semaglutide, Tirzepatide, BPC-157, GLOW, and more.",
    type: "website",
  },
}

export default function TrackerLayout({
  children,
}: {
  children: ReactNode
}) {
  return <ProtocolToolProviders>{children}</ProtocolToolProviders>
}