import { DosingMetrics, StabilityCategory, FrequencyOption } from '../types'

export function roundToTenth(value: number): number {
  return Math.max(0.1, Math.round(value * 10) / 10)
}

export function computeMetrics(weeklyDoseMg: number, intervalDays: number, eliminationRate: number): DosingMetrics {
  const injectionsPerWeek = 7 / intervalDays
  const theoreticalDosePerAdmin = (weeklyDoseMg * intervalDays) / 7
  const dosePerAdmin = roundToTenth(theoreticalDosePerAdmin)
  const weeklyDelivered = dosePerAdmin * injectionsPerWeek
  const decay = Math.exp(-eliminationRate * intervalDays)
  const maxAmount = dosePerAdmin / (1 - decay)
  const minAmount = maxAmount * decay
  const averageAmount = dosePerAdmin / (eliminationRate * intervalDays)
  const peakTroughPercent = (maxAmount / minAmount - 1) * 100
  const troughAsFractionOfPeak = minAmount / maxAmount

  return {
    dosePerAdmin,
    theoreticalDosePerAdmin,
    weeklyDelivered,
    averageAmount,
    minAmount,
    maxAmount,
    peakTroughPercent,
    troughAsFractionOfPeak,
    injectionsPerWeek,
  }
}

export function formatNumber(value: number, options: { minimumFractionDigits?: number; maximumFractionDigits?: number } = {}) {
  const formatter = new Intl.NumberFormat("en-US", {
    minimumFractionDigits: options.minimumFractionDigits ?? 0,
    maximumFractionDigits: options.maximumFractionDigits ?? 2,
  })
  return formatter.format(value)
}

export function getStabilityCategory(value: number): StabilityCategory {
  if (value < 30) return "excellent"
  if (value < 75) return "moderate"
  return "high"
}

export function getStabilityLabel(value: number) {
  if (value < 30) return "Excellent stability"
  if (value < 75) return "Moderate stability"
  return "High variation"
}

export function getStabilityDescription(value: number) {
  if (value < 30) {
    return "Lower is better—less fluctuation means more stable drug levels and fewer side effects."
  }
  if (value < 75) {
    return "Consider splitting the dose or adding an extra injection to smooth peaks."
  }
  return "Very high swings—side effects more common. Discuss more frequent injections with your clinician."
}

export function frequencyPillLabel(option: FrequencyOption) {
  switch (option.value) {
    case 7:
      return "Inject weekly"
    case 3.5:
      return "Inject twice weekly"
    case 3:
      return "Inject every 3 days"
    case 2:
    default:
      return "Inject every other day"
  }
}

export function getFrequencyTheme(injectionsPerWeek: number): { pill: string } {
  if (injectionsPerWeek >= 3.5) {
    return { pill: "high" } // High frequency = red (worst)
  }
  if (injectionsPerWeek >= 2) {
    return { pill: "moderate" } // Medium frequency = green (2nd best)
  }
  return { pill: "excellent" } // Low frequency = blue (best)
}

export function varianceLabel(delta: number) {
  if (Math.abs(delta) < 0.01) return "Matches target"
  const prefix = delta > 0 ? "+" : ""
  return `${prefix}${delta.toFixed(2)} mg vs target`
}

export function varianceColor(delta: number): "gray" | "amber" | "emerald" {
  if (Math.abs(delta) < 0.01) return "gray"
  return delta > 0 ? "amber" : "emerald"
}
