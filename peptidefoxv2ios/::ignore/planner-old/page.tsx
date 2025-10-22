"use client"

import { Badge } from "@/components/ui/badge"
import { PeptideCalculator } from "@/features/peptide/components/PeptideCalculator"
import { Peptide } from "@/features/peptide/types/peptide"
import { ClipboardList, Info, ArrowLeftRight } from "lucide-react"
import Link from "next/link"
import { useState } from "react"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"

import "../protocol-tool/protocol-tool.css"

type InputMode = "bacwater" | "concentration"

export default function PlannerPage() {
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [vialSize, setVialSize] = useState<string>("10")
  const [customVialSize, setCustomVialSize] = useState<string>("")
  const [bacteriostaticWater, setBacteriostaticWater] = useState<string>("2")
  const [customBacWater, setCustomBacWater] = useState<string>("")
  const [inputMode, setInputMode] = useState<InputMode>("bacwater")
  const [concentration, setConcentration] = useState<string>("5.0")
  const [customConcentration, setCustomConcentration] = useState<string>("")

  const vialSizes = [
    { value: "5", label: "5 mg" },
    { value: "10", label: "10 mg" },
    { value: "20", label: "20 mg" },
    { value: "30", label: "30 mg" },
    { value: "50", label: "50 mg" },
  ]

  const waterVolumes = [
    { value: "1", label: "1 mL" },
    { value: "2", label: "2 mL" },
    { value: "3", label: "3 mL" },
    { value: "4", label: "4 mL" },
    { value: "5", label: "5 mL" },
  ]

  const getVialSizeValue = () => {
    return vialSize === "custom" ? Number.parseFloat(customVialSize) || 0 : Number.parseFloat(vialSize)
  }

  const getBacWaterValue = () => {
    return bacteriostaticWater === "custom"
      ? Number.parseFloat(customBacWater) || 0
      : Number.parseFloat(bacteriostaticWater)
  }

  const getCurrentConcentration = () => {
    return Number.parseFloat(concentration) || 5.0
  }

  const handleConcentrationChange = (newConcentration: string) => {
    setConcentration(newConcentration)

    if (inputMode === "concentration") {
      const vialMg = getVialSizeValue()
      const targetConc = parseFloat(newConcentration)

      if (vialMg && targetConc && targetConc > 0) {
        const requiredWater = vialMg / targetConc
        const roundedWater = requiredWater.toFixed(1)

        const matchingPreset = waterVolumes.find(v => v.value === roundedWater)
        if (matchingPreset) {
          setBacteriostaticWater(matchingPreset.value)
          setCustomBacWater("")
        } else {
          setBacteriostaticWater("custom")
          setCustomBacWater(roundedWater)
        }
      }
    }
  }

  const handleBacWaterChange = (newBacWater: string) => {
    setBacteriostaticWater(newBacWater)

    if (inputMode === "bacwater") {
      const vialMg = getVialSizeValue()
      const waterMl = newBacWater === "custom" ? Number.parseFloat(customBacWater) || 0 : Number.parseFloat(newBacWater)

      if (vialMg && waterMl) {
        const calculatedConc = vialMg / waterMl
        setConcentration(calculatedConc.toFixed(1))
      }
    }
  }

  const handleCustomBacWaterChange = (value: string) => {
    setCustomBacWater(value)
    setBacteriostaticWater("custom")

    if (inputMode === "bacwater" && value) {
      const vialMg = getVialSizeValue()
      const waterMl = Number.parseFloat(value)
      if (vialMg && waterMl) {
        const calculatedConc = vialMg / waterMl
        setConcentration(calculatedConc.toFixed(1))
      }
    }
  }

  const handleVialSizeChange = (newVialSize: string) => {
    setVialSize(newVialSize)

    if (inputMode === "bacwater") {
      const vialMg = newVialSize === "custom" ? Number.parseFloat(customVialSize) || 0 : Number.parseFloat(newVialSize)
      const waterMl = getBacWaterValue()

      if (vialMg && waterMl) {
        const calculatedConc = vialMg / waterMl
        setConcentration(calculatedConc.toFixed(1))
      }
    } else {
      const vialMg = newVialSize === "custom" ? Number.parseFloat(customVialSize) || 0 : Number.parseFloat(newVialSize)
      const targetConc = getCurrentConcentration()

      if (vialMg && targetConc) {
        const requiredWater = vialMg / targetConc
        const roundedWater = requiredWater.toFixed(1)

        const matchingPreset = waterVolumes.find(v => v.value === roundedWater)
        if (matchingPreset) {
          setBacteriostaticWater(matchingPreset.value)
          setCustomBacWater("")
        } else {
          setBacteriostaticWater("custom")
          setCustomBacWater(roundedWater)
        }
      }
    }
  }

  const handleCustomVialSizeChange = (value: string) => {
    setCustomVialSize(value)
    setVialSize("custom")

    if (inputMode === "bacwater") {
      const vialMg = Number.parseFloat(value)
      const waterMl = getBacWaterValue()

      if (vialMg && waterMl) {
        const calculatedConc = vialMg / waterMl
        setConcentration(calculatedConc.toFixed(1))
      }
    } else {
      const vialMg = Number.parseFloat(value)
      const targetConc = getCurrentConcentration()

      if (vialMg && targetConc) {
        const requiredWater = vialMg / targetConc
        const roundedWater = requiredWater.toFixed(1)

        const matchingPreset = waterVolumes.find(v => v.value === roundedWater)
        if (matchingPreset) {
          setBacteriostaticWater(matchingPreset.value)
          setCustomBacWater("")
        } else {
          setBacteriostaticWater("custom")
          setCustomBacWater(roundedWater)
        }
      }
    }
  }

  const toggleInputMode = () => {
    const newMode: InputMode = inputMode === "bacwater" ? "concentration" : "bacwater"
    setInputMode(newMode)
  }

  const addPeptide = (peptide: Peptide) => {
    if (typeof window === "undefined") return

    const stored = localStorage.getItem("peptides")
    const existing: Peptide[] = stored ? JSON.parse(stored) : []
    const updated = [...existing, peptide]
    console.log('Saving peptide to localStorage:', peptide)
    console.log('Updated peptides array:', updated)
    localStorage.setItem("peptides", JSON.stringify(updated))
    console.log('Successfully saved to localStorage')
  }

  return (
    <div className="protocol-tool-page min-h-screen bg-gradient-to-br from-white via-blue-50/30 to-purple-50/30">
      <div className="ds-page pb-16 space-y-6">
        <section className="flex flex-col items-center text-center gap-5 pt-4">
          <Badge variant="outline" className="ds-pill pointer-events-none gap-2">
            <ClipboardList className="h-4 w-4" aria-hidden />
            Supply Planning
          </Badge>
          <h1 className="ds-hero-title">Dose & Supply Planner</h1>
          <p className="ds-hero-subtitle">
            Calculate peptide dosing, supply metrics, and plan your protocol with precision.
          </p>
        </section>

        {/* BAC Water Calculator Dialog */}
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogContent className="max-w-4xl">
            <DialogHeader>
              <DialogTitle className="flex items-center gap-2 text-xl text-primary">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z" />
                </svg>
                Calculate BAC water / concentration
              </DialogTitle>
            </DialogHeader>

            <div className="space-y-6 py-4">
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <Label className="text-base font-semibold text-slate-700">
                    Vial Size & Reconstitution
                  </Label>
                  <button
                    onClick={toggleInputMode}
                    className="flex items-center gap-2 px-3 py-1.5 rounded-lg border border-slate-300 bg-white hover:bg-slate-50 transition-colors"
                  >
                    <span className="text-xs font-medium text-slate-600">
                      Input: <span className="text-blue-600 font-semibold">{inputMode === "bacwater" ? "BAC Water" : "Concentration"}</span>
                    </span>
                    <ArrowLeftRight className="h-4 w-4 text-blue-600" />
                  </button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Vial Size */}
                  <div className="space-y-2">
                    <Label className="text-sm font-medium text-slate-600">Vial Size</Label>
                    <div className="grid grid-cols-3 gap-2">
                      {vialSizes.map((size) => (
                        <button
                          key={size.value}
                          onClick={() => handleVialSizeChange(size.value)}
                          className={`rounded-lg border-2 px-3 py-3 text-sm font-semibold transition-all ${
                            vialSize === size.value
                              ? "border-blue-400 bg-blue-50 text-blue-700"
                              : "border-slate-200 bg-white text-slate-600 hover:border-blue-200"
                          }`}
                        >
                          {size.label}
                        </button>
                      ))}
                      <div
                        className={`rounded-lg border-2 px-2 py-2 transition-all cursor-pointer ${
                          vialSize === "custom"
                            ? "border-blue-400 bg-blue-50"
                            : "border-slate-200 bg-white hover:border-blue-200"
                        }`}
                        onClick={() => handleVialSizeChange("custom")}
                      >
                        <div className="flex items-center justify-center gap-1 h-full">
                          <input
                            type="text"
                            value={customVialSize}
                            onChange={(e) => handleCustomVialSizeChange(e.target.value.replace(/[^0-9.]/g, ""))}
                            placeholder=""
                            className="w-12 text-center border border-blue-400 rounded px-1 py-0.5 text-sm font-bold text-blue-700 focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
                            onClick={(e) => e.stopPropagation()}
                          />
                          <span className="text-sm font-medium text-blue-600">mg</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* BAC Water or Concentration Input */}
                  {inputMode === "bacwater" ? (
                    <div className="space-y-2">
                      <Label className="text-sm font-medium text-slate-600">BAC Water Amount</Label>
                      <div className="grid grid-cols-3 gap-2">
                        {waterVolumes.map((volume) => (
                          <button
                            key={volume.value}
                            onClick={() => handleBacWaterChange(volume.value)}
                            className={`rounded-lg border-2 px-3 py-3 text-sm font-semibold transition-all ${
                              bacteriostaticWater === volume.value
                                ? "border-blue-400 bg-blue-50 text-blue-700"
                                : "border-slate-200 bg-white text-slate-600 hover:border-blue-200"
                            }`}
                          >
                            {volume.label}
                          </button>
                        ))}
                        <div
                          className={`rounded-lg border-2 px-2 py-2 transition-all cursor-pointer ${
                            bacteriostaticWater === "custom"
                              ? "border-blue-400 bg-blue-50"
                              : "border-slate-200 bg-white hover:border-blue-200"
                          }`}
                          onClick={() => handleBacWaterChange("custom")}
                        >
                          <div className="flex items-center justify-center gap-1 h-full">
                            <input
                              type="text"
                              value={customBacWater}
                              onChange={(e) => handleCustomBacWaterChange(e.target.value.replace(/[^0-9.]/g, ""))}
                              placeholder=""
                              className="w-12 text-center border border-blue-400 rounded px-1 py-0.5 text-sm font-bold text-blue-700 focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
                              onClick={(e) => e.stopPropagation()}
                            />
                            <span className="text-sm font-medium text-blue-600">mL</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  ) : (
                    <div className="space-y-2">
                      <Label className="text-sm font-medium text-slate-600">Desired Concentration</Label>
                      <div className="grid grid-cols-3 gap-2">
                        {[2, 3, 4, 5, 10].map((conc) => (
                          <button
                            key={conc}
                            onClick={() => {
                              setCustomConcentration("")
                              handleConcentrationChange(conc.toString())
                            }}
                            className={`rounded-lg border-2 px-3 py-3 text-sm font-semibold transition-all ${
                              parseFloat(concentration) === conc
                                ? "border-blue-400 bg-blue-50 text-blue-700"
                                : "border-slate-200 bg-white text-slate-600 hover:border-blue-200"
                            }`}
                          >
                            {conc} mg/mL
                          </button>
                        ))}
                        <div className={`rounded-lg border-2 px-2 py-2 transition-all ${
                          customConcentration && ![2, 3, 4, 5, 10].includes(parseFloat(concentration))
                            ? "border-blue-400 bg-blue-50"
                            : "border-slate-200 bg-white hover:border-blue-200"
                        }`}>
                          <div className="flex items-center justify-center gap-1 h-full">
                            <input
                              type="text"
                              value={customConcentration}
                              onChange={(e) => {
                                const value = e.target.value.replace(/[^0-9.]/g, "")
                                setCustomConcentration(value)
                                if (value) {
                                  handleConcentrationChange(value)
                                }
                              }}
                              placeholder=""
                              className="w-12 text-center border border-blue-400 rounded px-1 py-0.5 text-sm font-bold text-blue-700 focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
                            />
                            <span className="text-sm font-medium text-blue-600">mg/mL</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* Output Box */}
                <button
                  onClick={toggleInputMode}
                  className="w-full p-4 rounded-xl border-2 border-green-200 bg-green-50 hover:bg-green-100 transition-colors cursor-pointer"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Label className="text-sm font-semibold text-slate-700">
                        {inputMode === "bacwater" ? "Concentration" : "BAC Water Required"}
                      </Label>
                      <ArrowLeftRight className="h-4 w-4 text-green-600" />
                    </div>
                    <div className="flex items-baseline gap-2">
                      <span className="text-2xl font-bold text-green-700">
                        {inputMode === "bacwater"
                          ? (concentration || "5.0")
                          : (bacteriostaticWater === "custom" ? customBacWater : bacteriostaticWater) || "2.0"
                        }
                      </span>
                      <span className="text-sm font-medium text-green-600">
                        {inputMode === "bacwater" ? "mg/mL" : "mL"}
                      </span>
                    </div>
                  </div>
                </button>

                {/* Use Values in Supply Planner Button */}
                <button
                  onClick={() => {
                    setIsDialogOpen(false)
                    setTimeout(() => {
                      document.querySelector('.ds-card.overflow-hidden')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
                    }, 100)
                  }}
                  className="w-full flex items-center justify-center gap-2 px-4 py-3 rounded-xl border-2 border-blue-400 bg-blue-50 text-blue-700 font-semibold hover:bg-blue-100 transition-colors"
                >
                  Use Values in Supply Planner
                </button>
              </div>
            </div>
          </DialogContent>
        </Dialog>

        <section className="ds-card overflow-hidden p-0">
          <PeptideCalculator
            onAddPeptide={addPeptide}
            onOpenBacCalculator={() => setIsDialogOpen(true)}
            splitAtDosesPerVial={true}
          />
        </section>

        {/* Quick Dosing Reference Banner */}
        <div className="rounded-2xl border border-blue-300 bg-white px-6 md:px-8 py-5 md:py-6 flex items-start gap-3">
          <Info className="h-5 w-5 text-blue-600 flex-shrink-0 mt-0.5" />
          <div className="flex-1">
            <h3 className="font-semibold text-slate-900 mb-1">Looking for Standard Dosing Guidelines?</h3>
            <p className="text-sm text-slate-700">
              Access quick reference tables with typical doses, reconstitution ratios, and protocols for common peptides.
            </p>
          </div>
          <Link href="/reference" className="flex items-center gap-1.5 text-sm font-medium text-blue-600 hover:text-blue-700 transition-colors whitespace-nowrap">
            See Dosing Tables
            <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 17L17 7M17 7H7M17 7v10" />
            </svg>
          </Link>
        </div>
      </div>
    </div>
  )
}
