import { useState, useMemo } from 'react'
import { View, Text, ScrollView, StyleSheet, TouchableOpacity, Dimensions } from 'react-native'
import { StatusBar } from 'expo-status-bar'
import { Picker } from '@react-native-picker/picker'
import { LinearGradient } from 'expo-linear-gradient'
import { glpDrugs, FREQUENCY_OPTIONS } from '../utils/data'
import { computeMetrics, formatNumber, getStabilityCategory, getStabilityLabel, getStabilityDescription, frequencyPillLabel, getFrequencyTheme, varianceLabel, varianceColor } from '../utils/calculations'

const { width } = Dimensions.get('window')

export default function HomeScreen() {
  const [selectedDrug, setSelectedDrug] = useState(glpDrugs[0])
  const [weeklyDose, setWeeklyDose] = useState(selectedDrug.weeklyDoseOptions[0].value)
  const [frequency, setFrequency] = useState(FREQUENCY_OPTIONS[0].value)

  const metrics = useMemo(() => {
    return computeMetrics(weeklyDose, frequency, selectedDrug.eliminationRate)
  }, [weeklyDose, frequency, selectedDrug])

  const stabilityCategory = getStabilityCategory(metrics.peakTroughPercent)
  const delta = metrics.weeklyDelivered - weeklyDose
  const varianceColorValue = varianceColor(delta)

  const colorMap = {
    blue: { primary: '#3b82f6', light: '#dbeafe', dark: '#1e40af' },
    emerald: { primary: '#10b981', light: '#d1fae5', dark: '#047857' },
    purple: { primary: '#8b5cf6', light: '#ede9fe', dark: '#6d28d9' },
  }

  const stabilityColorMap = {
    excellent: { bg: '#dbeafe', text: '#1e40af', border: '#93c5fd' },
    moderate: { bg: '#d1fae5', text: '#047857', border: '#6ee7b7' },
    high: { bg: '#fee2e2', text: '#b91c1c', border: '#fca5a5' },
  }

  const drugColor = colorMap[selectedDrug.color]
  const stabilityColor = stabilityColorMap[stabilityCategory]

  return (
    <ScrollView style={styles.container}>
      <StatusBar style="light" />

      {/* Drug Selection */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Select GLP Medication</Text>
        <View style={styles.drugButtons}>
          {glpDrugs.map((drug) => (
            <TouchableOpacity
              key={drug.id}
              style={[
                styles.drugButton,
                { borderColor: colorMap[drug.color].primary },
                selectedDrug.id === drug.id && { backgroundColor: colorMap[drug.color].light }
              ]}
              onPress={() => {
                setSelectedDrug(drug)
                setWeeklyDose(drug.weeklyDoseOptions[0].value)
              }}
            >
              <Text style={[
                styles.drugButtonText,
                { color: colorMap[drug.color].dark },
                selectedDrug.id === drug.id && styles.drugButtonTextActive
              ]}>
                {drug.name}
              </Text>
              <Text style={[styles.drugButtonSubtext, { color: colorMap[drug.color].primary }]}>
                {drug.receptors}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Weekly Dose Selection */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Weekly Dose</Text>
        <View style={styles.pickerContainer}>
          <Picker
            selectedValue={weeklyDose}
            onValueChange={(value) => setWeeklyDose(value)}
            style={styles.picker}
          >
            {selectedDrug.weeklyDoseOptions.map((option) => (
              <Picker.Item
                key={option.value}
                label={`${option.label} - ${option.category}`}
                value={option.value}
              />
            ))}
          </Picker>
        </View>
      </View>

      {/* Frequency Selection */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Dosing Frequency</Text>
        <View style={styles.frequencyButtons}>
          {FREQUENCY_OPTIONS.map((option) => (
            <TouchableOpacity
              key={option.value}
              style={[
                styles.frequencyButton,
                frequency === option.value && { backgroundColor: drugColor.primary }
              ]}
              onPress={() => setFrequency(option.value)}
            >
              <Text style={[
                styles.frequencyButtonText,
                frequency === option.value && styles.frequencyButtonTextActive
              ]}>
                {option.shortLabel}
              </Text>
              <Text style={[
                styles.frequencyButtonSubtext,
                frequency === option.value && styles.frequencyButtonSubtextActive
              ]}>
                {option.description}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Metrics Card */}
      <View style={[styles.metricsCard, { backgroundColor: stabilityColor.bg, borderColor: stabilityColor.border }]}>
        <Text style={[styles.metricsTitle, { color: stabilityColor.text }]}>
          {getStabilityLabel(metrics.peakTroughPercent)}
        </Text>
        <Text style={styles.metricsValue}>
          {formatNumber(metrics.peakTroughPercent, { maximumFractionDigits: 0 })}% Peak-Trough
        </Text>
        <Text style={styles.metricsDescription}>
          {getStabilityDescription(metrics.peakTroughPercent)}
        </Text>

        <View style={styles.metricRow}>
          <View style={styles.metricItem}>
            <Text style={styles.metricLabel}>Dose per Injection</Text>
            <Text style={[styles.metricValue, { color: drugColor.dark }]}>
              {formatNumber(metrics.dosePerAdmin, { minimumFractionDigits: 1, maximumFractionDigits: 1 })} mg
            </Text>
          </View>
          <View style={styles.metricItem}>
            <Text style={styles.metricLabel}>Injections/Week</Text>
            <Text style={[styles.metricValue, { color: drugColor.dark }]}>
              {formatNumber(metrics.injectionsPerWeek, { minimumFractionDigits: 1, maximumFractionDigits: 1 })}×
            </Text>
          </View>
        </View>

        <View style={styles.metricRow}>
          <View style={styles.metricItem}>
            <Text style={styles.metricLabel}>Peak Plasma</Text>
            <Text style={[styles.metricValue, { color: drugColor.dark }]}>
              {formatNumber(metrics.maxAmount, { maximumFractionDigits: 1 })} mg
            </Text>
          </View>
          <View style={styles.metricItem}>
            <Text style={styles.metricLabel}>Trough Plasma</Text>
            <Text style={[styles.metricValue, { color: drugColor.dark }]}>
              {formatNumber(metrics.minAmount, { maximumFractionDigits: 1 })} mg
            </Text>
          </View>
        </View>

        <View style={styles.varianceContainer}>
          <Text style={[
            styles.varianceText,
            { color: varianceColorValue === 'amber' ? '#d97706' : varianceColorValue === 'emerald' ? '#059669' : '#6b7280' }
          ]}>
            Weekly delivered: {formatNumber(metrics.weeklyDelivered, { minimumFractionDigits: 2 })} mg ({varianceLabel(delta)})
          </Text>
        </View>
      </View>

      {/* Drug Info */}
      <View style={[styles.infoCard, { borderColor: drugColor.primary }]}>
        <Text style={[styles.infoTitle, { color: drugColor.dark }]}>{selectedDrug.name} Info</Text>
        <Text style={styles.infoText}>Brand: {selectedDrug.brandNames}</Text>
        <Text style={styles.infoText}>Half-life: {selectedDrug.halfLife} days</Text>
        <Text style={styles.infoText}>Time to steady-state: {selectedDrug.timeToSteadyState}</Text>
        <Text style={styles.infoText}>Missed dose window: {selectedDrug.missedDoseWindow}</Text>

        {selectedDrug.warnings.length > 0 && (
          <>
            <Text style={[styles.warningTitle, { color: drugColor.dark }]}>Warnings:</Text>
            {selectedDrug.warnings.map((warning, index) => (
              <Text key={index} style={styles.warningText}>• {warning}</Text>
            ))}
          </>
        )}
      </View>

      <View style={{ height: 40 }} />
    </ScrollView>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f9fafb',
  },
  section: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#111827',
    marginBottom: 12,
  },
  drugButtons: {
    flexDirection: 'column',
    gap: 8,
  },
  drugButton: {
    padding: 16,
    borderRadius: 12,
    borderWidth: 2,
    backgroundColor: '#fff',
  },
  drugButtonText: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  drugButtonTextActive: {
    fontWeight: '700',
  },
  drugButtonSubtext: {
    fontSize: 12,
    fontWeight: '500',
  },
  pickerContainer: {
    backgroundColor: '#fff',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#e5e7eb',
    overflow: 'hidden',
  },
  picker: {
    height: 50,
  },
  frequencyButtons: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  frequencyButton: {
    flex: 1,
    minWidth: (width - 48) / 2,
    padding: 12,
    borderRadius: 12,
    backgroundColor: '#fff',
    borderWidth: 1,
    borderColor: '#e5e7eb',
    alignItems: 'center',
  },
  frequencyButtonText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#374151',
    marginBottom: 4,
  },
  frequencyButtonTextActive: {
    color: '#fff',
  },
  frequencyButtonSubtext: {
    fontSize: 12,
    color: '#6b7280',
  },
  frequencyButtonSubtextActive: {
    color: '#fff',
    opacity: 0.9,
  },
  metricsCard: {
    margin: 16,
    padding: 20,
    borderRadius: 16,
    borderWidth: 2,
  },
  metricsTitle: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 8,
  },
  metricsValue: {
    fontSize: 32,
    fontWeight: '700',
    color: '#111827',
    marginBottom: 8,
  },
  metricsDescription: {
    fontSize: 14,
    color: '#6b7280',
    marginBottom: 16,
  },
  metricRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 12,
  },
  metricItem: {
    flex: 1,
  },
  metricLabel: {
    fontSize: 12,
    color: '#6b7280',
    marginBottom: 4,
  },
  metricValue: {
    fontSize: 18,
    fontWeight: '600',
  },
  varianceContainer: {
    marginTop: 16,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: '#e5e7eb',
  },
  varianceText: {
    fontSize: 14,
    fontWeight: '500',
    textAlign: 'center',
  },
  infoCard: {
    margin: 16,
    marginTop: 0,
    padding: 16,
    backgroundColor: '#fff',
    borderRadius: 12,
    borderWidth: 2,
  },
  infoTitle: {
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 12,
  },
  infoText: {
    fontSize: 14,
    color: '#374151',
    marginBottom: 6,
  },
  warningTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginTop: 12,
    marginBottom: 8,
  },
  warningText: {
    fontSize: 13,
    color: '#6b7280',
    marginBottom: 4,
    lineHeight: 18,
  },
})
