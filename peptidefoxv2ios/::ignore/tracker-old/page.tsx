"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { FlaskConical, ClipboardList } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { PeptideCard } from "@/features/peptide/components/PeptideCard"
import { Peptide } from "@/features/peptide/types/peptide"
import { calculatePeptideMetrics } from "@/features/peptide/lib/peptideCalculations"

import "../protocol-tool/protocol-tool.css"

export default function TrackerPage() {
  const [peptides, setPeptides] = useState<Peptide[]>([])

  useEffect(() => {
    if (typeof window === "undefined") return
    const stored = localStorage.getItem("peptides")
    if (stored) {
      setPeptides(JSON.parse(stored))
    }
  }, [])

  useEffect(() => {
    if (typeof window === "undefined") return
    localStorage.setItem("peptides", JSON.stringify(peptides))
  }, [peptides])

  const updatePeptide = (id: string, dosesTaken: number, completedWeeks?: number) => {
    setPeptides((prev) =>
      prev.map((peptide) => {
        if (peptide.id !== id) return peptide

        let newCompletedWeeks: number
        let newDosesTaken: number

        if (completedWeeks !== undefined) {
          newCompletedWeeks = completedWeeks
          newDosesTaken = dosesTaken
        } else {
          const oldTotalDoses = peptide.completedWeeks * peptide.dosesPerWeek + peptide.dosesTaken
          const newTotalDoses = peptide.completedWeeks * peptide.dosesPerWeek + dosesTaken
          newCompletedWeeks = Math.floor(newTotalDoses / peptide.dosesPerWeek)
          newDosesTaken = newTotalDoses % peptide.dosesPerWeek
        }

        const formData = {
          name: peptide.name,
          concentration: peptide.concentration,
          vialSize: peptide.vialSize,
          vialCount: peptide.vialCount,
          remainingVials: peptide.remainingVials,
          typicalDose: peptide.typicalDose,
          dosesPerWeek: peptide.dosesPerWeek,
          cycleWeeks: peptide.cycleWeeks,
          completedWeeks: newCompletedWeeks,
        }
        const calculation = calculatePeptideMetrics(formData, newDosesTaken)

        return {
          ...peptide,
          dosesTaken: newDosesTaken,
          completedWeeks: newCompletedWeeks,
          remainingWeeks: calculation.weeksRemaining,
          status: calculation.status,
          gapWeeks: calculation.gapWeeks,
          additionalNeeded: calculation.additionalNeeded,
        }
      }),
    )
  }

  const deletePeptide = (id: string) => {
    setPeptides((prev) => prev.filter((peptide) => peptide.id !== id))
  }

  return (
    <div className="protocol-tool-page min-h-screen bg-gradient-to-br from-white via-blue-50/30 to-purple-50/30">
      <div className="ds-page pb-16 space-y-6">
        <section className="flex flex-col items-center text-center gap-5 pt-4">
          <Badge variant="outline" className="ds-pill">
            <ClipboardList className="h-4 w-4" />
            Protocol Tracking
          </Badge>
          <h1 className="ds-hero-title">Manage Your Peptide Protocol</h1>
          <p className="ds-hero-subtitle">
            Monitor your active peptide regimens, update completed doses, and keep supply levels synchronized with the planner.
          </p>
        </section>

        {peptides.length === 0 ? (
          <section className="ds-card-soft flex flex-col items-center gap-4 px-6 py-10 text-center">
            <FlaskConical className="h-12 w-12 text-slate-400" />
            <div>
              <h3 className="text-xl font-semibold text-slate-900">No peptides added yet</h3>
              <p className="mt-2 text-sm text-slate-600">
                Add your first protocol from the planner to begin tracking dose history and supply.
              </p>
            </div>
            <Link
              href="/planner"
              className="inline-flex items-center gap-2 rounded-full bg-blue-500 px-5 py-2 text-sm font-semibold text-white shadow-md transition-colors hover:bg-blue-600"
            >
              <FlaskConical className="h-4 w-4" />
              Go to Dose & Supply Planner
            </Link>
          </section>
        ) : (
          <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
            {peptides.map((peptide) => (
              <div key={peptide.id} className="ds-card-soft p-0">
                <PeptideCard peptide={peptide} onUpdate={updatePeptide} onDelete={deletePeptide} />
              </div>
            ))}
          </section>
        )}
      </div>
    </div>
  )
}
