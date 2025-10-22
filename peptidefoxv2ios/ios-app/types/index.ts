export type FrequencyOption = {
  value: number
  label: string
  shortLabel: string
  description: string
}

export type Drug = {
  id: string
  name: string
  brandNames: string
  halfLife: number
  eliminationRate: number
  timeToSteadyState: string
  missedDoseWindow: string
  color: "blue" | "emerald" | "purple"
  description: string
  receptors: string
  warnings: string[]
  weeklyDoseOptions: Array<{
    value: number
    label: string
    category: string
    protocol: string
  }>
}

export interface DosingMetrics {
  dosePerAdmin: number
  theoreticalDosePerAdmin: number
  weeklyDelivered: number
  averageAmount: number
  minAmount: number
  maxAmount: number
  peakTroughPercent: number
  troughAsFractionOfPeak: number
  injectionsPerWeek: number
}

export type StabilityCategory = "excellent" | "moderate" | "high"
