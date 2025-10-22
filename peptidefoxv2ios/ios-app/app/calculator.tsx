import { useState, useMemo } from 'react'
import { View, Text, ScrollView, StyleSheet, TextInput, TouchableOpacity } from 'react-native'
import { Picker } from '@react-native-picker/picker'
import { glpDrugs } from '../utils/data'

export default function CalculatorScreen() {
  const [selectedDrug, setSelectedDrug] = useState(glpDrugs[0])
  const [vialSize, setVialSize] = useState(selectedDrug.weeklyDoseOptions[0].value.toString())
  const [bacWater, setBacWater] = useState('1')
  const [desiredDose, setDesiredDose] = useState(selectedDrug.weeklyDoseOptions[0].value.toString())

  // Calculate concentration
  const concentration = useMemo(() => {
    const vial = parseFloat(vialSize) || 0
    const water = parseFloat(bacWater) || 0
    return water > 0 ? vial / water : 0
  }, [vialSize, bacWater])

  // Calculate injection volume
  const injectionVolume = useMemo(() => {
    const dose = parseFloat(desiredDose) || 0
    return concentration > 0 ? dose / concentration : 0
  }, [desiredDose, concentration])

  const colorMap = {
    blue: { primary: '#3b82f6', light: '#dbeafe', dark: '#1e40af' },
    emerald: { primary: '#10b981', light: '#d1fae5', dark: '#047857' },
    purple: { primary: '#8b5cf6', light: '#ede9fe', dark: '#6d28d9' },
  }

  const drugColor = colorMap[selectedDrug.color]

  return (
    <ScrollView style={styles.container}>
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
                setVialSize(drug.weeklyDoseOptions[0].value.toString())
                setDesiredDose(drug.weeklyDoseOptions[0].value.toString())
              }}
            >
              <Text style={[
                styles.drugButtonText,
                { color: colorMap[drug.color].dark },
                selectedDrug.id === drug.id && styles.drugButtonTextActive
              ]}>
                {drug.name}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Reconstitution Calculator */}
      <View style={[styles.card, { borderColor: drugColor.primary }]}>
        <Text style={[styles.cardTitle, { color: drugColor.dark }]}>Reconstitution</Text>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Vial Size (mg)</Text>
          <TextInput
            style={[styles.input, { borderColor: drugColor.primary }]}
            value={vialSize}
            onChangeText={setVialSize}
            keyboardType="decimal-pad"
            placeholder="Enter vial size"
          />
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>BAC Water (mL)</Text>
          <TextInput
            style={[styles.input, { borderColor: drugColor.primary }]}
            value={bacWater}
            onChangeText={setBacWater}
            keyboardType="decimal-pad"
            placeholder="Enter water amount"
          />
        </View>

        <View style={[styles.resultBox, { backgroundColor: drugColor.light, borderColor: drugColor.primary }]}>
          <Text style={styles.resultLabel}>Concentration</Text>
          <Text style={[styles.resultValue, { color: drugColor.dark }]}>
            {concentration.toFixed(2)} mg/mL
          </Text>
        </View>
      </View>

      {/* Injection Volume Calculator */}
      <View style={[styles.card, { borderColor: drugColor.primary }]}>
        <Text style={[styles.cardTitle, { color: drugColor.dark }]}>Injection Volume</Text>

        <View style={styles.inputGroup}>
          <Text style={styles.label}>Desired Dose (mg)</Text>
          <View style={styles.pickerContainer}>
            <Picker
              selectedValue={parseFloat(desiredDose)}
              onValueChange={(value) => setDesiredDose(value.toString())}
              style={styles.picker}
            >
              {selectedDrug.weeklyDoseOptions.map((option) => (
                <Picker.Item
                  key={option.value}
                  label={`${option.label} (${option.category})`}
                  value={option.value}
                />
              ))}
            </Picker>
          </View>
        </View>

        <View style={[styles.resultBox, { backgroundColor: drugColor.light, borderColor: drugColor.primary }]}>
          <Text style={styles.resultLabel}>Injection Volume</Text>
          <Text style={[styles.resultValue, { color: drugColor.dark }]}>
            {injectionVolume.toFixed(2)} mL
          </Text>
          <Text style={styles.resultSubtext}>
            ({(injectionVolume * 100).toFixed(0)} units on insulin syringe)
          </Text>
        </View>
      </View>

      {/* Quick Reference */}
      <View style={[styles.referenceCard, { borderColor: drugColor.primary }]}>
        <Text style={[styles.cardTitle, { color: drugColor.dark }]}>Quick Reference</Text>
        <View style={styles.referenceRow}>
          <Text style={styles.referenceLabel}>1 mL</Text>
          <Text style={styles.referenceValue}>= 100 units</Text>
        </View>
        <View style={styles.referenceRow}>
          <Text style={styles.referenceLabel}>0.5 mL</Text>
          <Text style={styles.referenceValue}>= 50 units</Text>
        </View>
        <View style={styles.referenceRow}>
          <Text style={styles.referenceLabel}>0.25 mL</Text>
          <Text style={styles.referenceValue}>= 25 units</Text>
        </View>
        <View style={styles.referenceRow}>
          <Text style={styles.referenceLabel}>0.1 mL</Text>
          <Text style={styles.referenceValue}>= 10 units</Text>
        </View>
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
    textAlign: 'center',
  },
  drugButtonTextActive: {
    fontWeight: '700',
  },
  card: {
    margin: 16,
    marginTop: 0,
    padding: 20,
    backgroundColor: '#fff',
    borderRadius: 16,
    borderWidth: 2,
  },
  cardTitle: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 16,
  },
  inputGroup: {
    marginBottom: 16,
  },
  label: {
    fontSize: 14,
    fontWeight: '600',
    color: '#374151',
    marginBottom: 8,
  },
  input: {
    height: 50,
    borderWidth: 2,
    borderRadius: 12,
    paddingHorizontal: 16,
    fontSize: 16,
    backgroundColor: '#fff',
  },
  pickerContainer: {
    borderWidth: 2,
    borderColor: '#e5e7eb',
    borderRadius: 12,
    overflow: 'hidden',
    backgroundColor: '#fff',
  },
  picker: {
    height: 50,
  },
  resultBox: {
    padding: 20,
    borderRadius: 12,
    borderWidth: 2,
    alignItems: 'center',
    marginTop: 8,
  },
  resultLabel: {
    fontSize: 14,
    color: '#6b7280',
    marginBottom: 8,
  },
  resultValue: {
    fontSize: 32,
    fontWeight: '700',
  },
  resultSubtext: {
    fontSize: 12,
    color: '#6b7280',
    marginTop: 4,
  },
  referenceCard: {
    margin: 16,
    marginTop: 0,
    padding: 20,
    backgroundColor: '#fff',
    borderRadius: 16,
    borderWidth: 2,
  },
  referenceRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#f3f4f6',
  },
  referenceLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#374151',
  },
  referenceValue: {
    fontSize: 14,
    color: '#6b7280',
  },
})
