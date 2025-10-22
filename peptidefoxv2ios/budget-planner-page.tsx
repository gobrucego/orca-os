"use client"

import { useEffect, useMemo, useState } from "react"
import Link from "next/link"
import { Activity, AlertCircle, Calendar, CheckCircle2, ChevronDown, Info, Plus, Clock, Package, TrendingUp, Calculator, ShoppingCart, DollarSign, Target, PiggyBank, Receipt } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Input } from "@/components/ui/input"
import { cn } from "@/lib/utils"
import { calculatePeptideMetrics, commonPeptides, generatePeptideId } from "@/features/peptide/lib/peptideCalculations"
import { Peptide } from "@/features/peptide/types/peptide"

// Types for supply planning
interface PlannedPurchase {
  id: string
  peptideName: string
  vialSize: number
  vialsNeeded: number
  costPerVial: number
  totalCost: number
  priority: 'high' | 'medium' | 'low'
  timeline: 'immediate' | 'soon' | 'later'
  rationale: string
  protocolWeeks: number
}

interface SupplyPlan {
  id: string
  name: string
  description: string
  durationWeeks: number
  totalCost: number
  purchases: PlannedPurchase[]
  status: 'planned' | 'in-progress' | 'completed'
  startDate?: string
}

export default function SupplyPlannerPage() {
  const [supplyPlans, setSupplyPlans] = useState<SupplyPlan[]>([])
  const [plannedPurchases, setPlannedPurchases] = useState<PlannedPurchase[]>([])
  const [selectedCategory, setSelectedCategory] = useState<string>("all")
  const [viewMode, setViewMode] = useState<"planning" | "purchases" | "analysis">("planning")

  // Load existing supply plans on mount
  useEffect(() => {
    if (typeof window === "undefined") return
    const stored = localStorage.getItem("supplyPlans")
    if (stored) {
      setSupplyPlans(JSON.parse(stored))
    }
  }, [])

  // Auto-generate planned purchases based on common protocols
  useEffect(() => {
    const purchases: PlannedPurchase[] = []

    // GLP-1 Protocol (12 weeks)
    purchases.push({
      id: generatePeptideId(),
      peptideName: "Tirzepatide",
      vialSize: 30,
      vialsNeeded: 3,
      costPerVial: 150,
      totalCost: 450,
      priority: 'high',
      timeline: 'immediate',
      rationale: "12-week GLP-1 protocol for metabolic health",
      protocolWeeks: 12
    })

    purchases.push({
      id: generatePeptideId(),
      peptideName: "BPC-157",
      vialSize: 10,
      vialsNeeded: 4,
      costPerVial: 80,
      totalCost: 320,
      priority: 'medium',
      timeline: 'soon',
      rationale: "Injury recovery protocol (8 weeks)",
      protocolWeeks: 8
    })

    purchases.push({
      id: generatePeptideId(),
      peptideName: "NAD+",
      vialSize: 500,
      vialsNeeded: 2,
      costPerVial: 200,
      totalCost: 400,
      priority: 'medium',
      timeline: 'later',
      rationale: "Metabolic support (quarterly protocol)",
      protocolWeeks: 12
    })

    purchases.push({
      id: generatePeptideId(),
      peptideName: "GHK-Cu",
      vialSize: 50,
      vialsNeeded: 2,
      costPerVial: 120,
      totalCost: 240,
      priority: 'low',
      timeline: 'later',
      rationale: "Skin health and anti-aging (6 weeks)",
      protocolWeeks: 6
    })

    setPlannedPurchases(purchases)
  }, [])

  const createSupplyPlan = () => {
    const newPlan: SupplyPlan = {
      id: generatePeptideId(),
      name: "Q1 2025 Protocol Suite",
      description: "Complete metabolic health and recovery protocol package",
      durationWeeks: 12,
      totalCost: plannedPurchases.reduce((total, purchase) => total + purchase.totalCost, 0),
      purchases: [...plannedPurchases],
      status: 'planned',
      startDate: new Date().toISOString().split('T')[0]
    }

    setSupplyPlans(prev => [...prev, newPlan])

    // Save to localStorage
    if (typeof window !== "undefined") {
      const updated = [...supplyPlans, newPlan]
      localStorage.setItem("supplyPlans", JSON.stringify(updated))
    }
  }

  const totalPlannedCost = useMemo(() =>
    plannedPurchases.reduce((total, purchase) => total + purchase.totalCost, 0),
    [plannedPurchases]
  )

  const priorityBreakdown = useMemo(() => {
    const breakdown = { high: 0, medium: 0, low: 0 }
    plannedPurchases.forEach(purchase => {
      breakdown[purchase.priority] += purchase.totalCost
    })
    return breakdown
  }, [plannedPurchases])

  const timelineBreakdown = useMemo(() => {
    const breakdown = { immediate: 0, soon: 0, later: 0 }
    plannedPurchases.forEach(purchase => {
      breakdown[purchase.timeline] += purchase.totalCost
    })
    return breakdown
  }, [plannedPurchases])

  const totalProtocolWeeks = useMemo(() =>
    plannedPurchases.reduce((total, purchase) => total + purchase.protocolWeeks, 0),
    [plannedPurchases]
  )

  return (
    <div className="min-h-screen bg-gradient-to-br from-white via-blue-50/30 to-purple-50/30">
      <div className="ds-page space-y-6">
        {/* Header */}
        <section className="flex flex-col items-center text-center gap-5 pt-4">
          <Badge variant="outline" className="ds-pill pointer-events-none gap-2">
            <PiggyBank className="h-4 w-4" />
            Budget Planner
          </Badge>
          <h1 className="ds-hero-title">Protocol Budget Planner</h1>
          <p className="ds-hero-subtitle">
            Plan your peptide budget with precision. Calculate costs, optimize spending, and ensure you have funds when protocols begin.
          </p>
        </section>

        {/* Quick Stats Dashboard */}
        <section className="grid gap-6 lg:grid-cols-5">
          <div className="rounded-[18px] border border-slate-200 bg-slate-50 px-7 py-7 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2.5">
                <ShoppingCart className="h-5 w-5 text-slate-900" />
                <h2 className="text-lg font-semibold text-slate-900">Planned Purchases</h2>
              </div>
              <Badge className="bg-blue-100 text-blue-700 rounded-full px-3 py-1 text-xs font-semibold pointer-events-none">
                {plannedPurchases.length}
              </Badge>
            </div>

            <div className="mt-6">
              <p className="ds-label mb-3">Items to Purchase</p>
              <p className="text-2xl md:text-4xl font-light text-slate-900 leading-none mb-3">
                {plannedPurchases.length}
              </p>
            </div>
          </div>

          <div className="rounded-[18px] border border-emerald-200 bg-emerald-50/50 px-7 py-7 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2.5">
                <DollarSign className="h-5 w-5 text-emerald-600" />
                <h2 className="text-lg font-semibold text-slate-900">Total Investment</h2>
              </div>
              <Badge className="bg-emerald-100 text-emerald-700 rounded-full px-3 py-1 text-xs font-semibold pointer-events-none">
                Budgeted
              </Badge>
            </div>

            <div className="mt-6">
              <p className="ds-label mb-3">Total Cost</p>
              <p className="text-2xl md:text-4xl font-light text-slate-900 leading-none mb-3">
                ${totalPlannedCost.toLocaleString()}
              </p>
            </div>
          </div>

          <div className="rounded-[18px] border border-amber-200 bg-amber-50/50 px-7 py-7 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2.5">
                <Target className="h-5 w-5 text-amber-600" />
                <h2 className="text-lg font-semibold text-slate-900">High Priority</h2>
              </div>
              <Badge className="bg-amber-100 text-amber-700 rounded-full px-3 py-1 text-xs font-semibold pointer-events-none">
                Urgent
              </Badge>
            </div>

            <div className="mt-6">
              <p className="ds-label mb-3">Immediate Purchases</p>
              <p className="text-2xl md:text-4xl font-light text-slate-900 leading-none mb-3">
                ${priorityBreakdown.high.toLocaleString()}
              </p>
            </div>
          </div>

          <div className="rounded-[18px] border border-purple-200 bg-purple-50/50 px-7 py-7 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2.5">
                <Calendar className="h-5 w-5 text-purple-600" />
                <h2 className="text-lg font-semibold text-slate-900">Timeline</h2>
              </div>
              <Badge className="bg-purple-100 text-purple-700 rounded-full px-3 py-1 text-xs font-semibold pointer-events-none">
                {totalProtocolWeeks} weeks
              </Badge>
            </div>

            <div className="mt-6">
              <p className="ds-label mb-3">Total Protocol Duration</p>
              <p className="text-2xl md:text-4xl font-light text-slate-900 leading-none mb-3">
                {totalProtocolWeeks} <span className="text-xl md:text-3xl">weeks</span>
              </p>
            </div>
          </div>

          <div className="rounded-[18px] border border-indigo-200 bg-indigo-50/50 px-7 py-7 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2.5">
                <PiggyBank className="h-5 w-5 text-indigo-600" />
                <h2 className="text-lg font-semibold text-slate-900">Cost per Week</h2>
              </div>
              <Badge className="bg-indigo-100 text-indigo-700 rounded-full px-3 py-1 text-xs font-semibold pointer-events-none">
                Efficiency
              </Badge>
            </div>

            <div className="mt-6">
              <p className="ds-label mb-3">Weekly Cost</p>
              <p className="text-2xl md:text-4xl font-light text-slate-900 leading-none mb-3">
                ${totalProtocolWeeks > 0 ? Math.round(totalPlannedCost / totalProtocolWeeks).toLocaleString() : '0'}
              </p>
            </div>
          </div>
        </section>

        {/* View Mode Toggle */}
        <section className="flex justify-center">
          <div className="flex gap-2 overflow-x-auto scrollbar-hide px-1 bg-white rounded-full p-1 border border-slate-200">
            <button
              onClick={() => setViewMode("planning")}
              className={cn(
                "rounded-full px-4 py-2 text-sm font-medium transition-all whitespace-nowrap flex items-center gap-2",
                viewMode === "planning"
                  ? "bg-blue-600 text-white shadow-md"
                  : "text-slate-700 hover:bg-slate-50"
              )}
            >
              <PiggyBank className="h-4 w-4" />
              Budget Planning
            </button>
            <button
              onClick={() => setViewMode("purchases")}
              className={cn(
                "rounded-full px-4 py-2 text-sm font-medium transition-all whitespace-nowrap flex items-center gap-2",
                viewMode === "purchases"
                  ? "bg-blue-600 text-white shadow-md"
                  : "text-slate-700 hover:bg-slate-50"
              )}
            >
              <Receipt className="h-4 w-4" />
              Spending Plan
            </button>
            <button
              onClick={() => setViewMode("analysis")}
              className={cn(
                "rounded-full px-4 py-2 text-sm font-medium transition-all whitespace-nowrap flex items-center gap-2",
                viewMode === "analysis"
                  ? "bg-blue-600 text-white shadow-md"
                  : "text-slate-700 hover:bg-slate-50"
              )}
            >
              <TrendingUp className="h-4 w-4" />
              Cost Analysis
            </button>
          </div>
        </section>

        {/* Protocol Planning View */}
        {viewMode === "planning" && (
          <section className="space-y-6">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-semibold text-slate-900">Plan Your Protocol Budget</h2>
              <Button
                onClick={createSupplyPlan}
                className="bg-blue-600 hover:bg-blue-700 text-white"
              >
                <Plus className="h-4 w-4 mr-2" />
                Create Budget Plan
              </Button>
            </div>

            <div className="grid gap-6 lg:grid-cols-2">
              {/* Protocol Planning Cards */}
              <div className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-6 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
                <h3 className="text-lg font-semibold text-slate-900 mb-4">Budgeted Protocols</h3>

                <div className="space-y-4">
                  <div className="p-4 border border-blue-200 bg-blue-50/50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">GLP-1 Protocol (12 weeks)</h4>
                    <p className="text-sm text-slate-600 mb-3">Tirzepatide for metabolic health and weight management</p>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-slate-600">Cost: $450</span>
                      <Badge className="bg-blue-100 text-blue-700 text-xs">High Priority</Badge>
                    </div>
                  </div>

                  <div className="p-4 border border-emerald-200 bg-emerald-50/50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Recovery Protocol (8 weeks)</h4>
                    <p className="text-sm text-slate-600 mb-3">BPC-157 for injury recovery and tissue repair</p>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-slate-600">Cost: $320</span>
                      <Badge className="bg-emerald-100 text-emerald-700 text-xs">Medium Priority</Badge>
                    </div>
                  </div>

                  <div className="p-4 border border-purple-200 bg-purple-50/50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Metabolic Support (Quarterly)</h4>
                    <p className="text-sm text-slate-600 mb-3">NAD+ for cellular energy and metabolic function</p>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-slate-600">Cost: $400</span>
                      <Badge className="bg-purple-100 text-purple-700 text-xs">Low Priority</Badge>
                    </div>
                  </div>
                </div>
              </div>

              {/* Procurement Timeline */}
              <div className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-6 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
                <h3 className="text-lg font-semibold text-slate-900 mb-4">Spending Timeline</h3>

                <div className="space-y-4">
                  <div className="flex items-center gap-3 p-3 border border-amber-200 bg-amber-50/50 rounded-lg">
                    <div className="w-3 h-3 bg-amber-500 rounded-full"></div>
                    <div className="flex-1">
                      <div className="font-semibold text-slate-900 text-sm">Week 1: Order GLP-1</div>
                      <div className="text-xs text-slate-600">Tirzepatide - $450 • 12-week protocol</div>
                    </div>
                  </div>

                  <div className="flex items-center gap-3 p-3 border border-blue-200 bg-blue-50/50 rounded-lg">
                    <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                    <div className="flex-1">
                      <div className="font-semibold text-slate-900 text-sm">Week 2: Order Recovery</div>
                      <div className="text-xs text-slate-600">BPC-157 - $320 • 8-week protocol</div>
                    </div>
                  </div>

                  <div className="flex items-center gap-3 p-3 border border-slate-200 bg-slate-50/50 rounded-lg">
                    <div className="w-3 h-3 bg-slate-400 rounded-full"></div>
                    <div className="flex-1">
                      <div className="font-semibold text-slate-900 text-sm">Month 3: Metabolic Support</div>
                      <div className="text-xs text-slate-600">NAD+ - $400 • Quarterly protocol</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>
        )}

        {/* Purchase List View */}
        {viewMode === "purchases" && (
          <section className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-8 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center gap-2 mb-6">
              <ShoppingCart className="h-5 w-5 text-slate-900" />
              <h2 className="text-lg font-semibold text-slate-900">Detailed Purchase List</h2>
            </div>

            <div className="space-y-4">
              {plannedPurchases.map((purchase) => (
                <div key={purchase.id} className="border border-slate-200 rounded-lg p-4">
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <h3 className="font-semibold text-slate-900">{purchase.peptideName}</h3>
                      <p className="text-sm text-slate-600">{purchase.rationale}</p>
                    </div>
                    <div className="text-right">
                      <div className="font-semibold text-slate-900">${purchase.totalCost}</div>
                      <Badge className={cn(
                        "text-xs",
                        purchase.priority === 'high' ? "bg-amber-100 text-amber-700" :
                        purchase.priority === 'medium' ? "bg-blue-100 text-blue-700" :
                        "bg-slate-100 text-slate-700"
                      )}>
                        {purchase.priority} priority
                      </Badge>
                    </div>
                  </div>

                  <div className="grid grid-cols-4 gap-4 text-sm">
                    <div>
                      <div className="text-slate-600 mb-1">Vial Size</div>
                      <div className="font-mono font-medium text-slate-900">{purchase.vialSize} mg</div>
                    </div>
                    <div>
                      <div className="text-slate-600 mb-1">Quantity</div>
                      <div className="font-mono font-medium text-slate-900">{purchase.vialsNeeded} vials</div>
                    </div>
                    <div>
                      <div className="text-slate-600 mb-1">Cost per Vial</div>
                      <div className="font-mono font-medium text-slate-900">${purchase.costPerVial}</div>
                    </div>
                    <div>
                      <div className="text-slate-600 mb-1">Protocol Length</div>
                      <div className="font-mono font-medium text-slate-900">{purchase.protocolWeeks} weeks</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Budget Analysis View */}
        {viewMode === "analysis" && (
          <section className="space-y-6">
            <div className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-8 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
              <div className="flex items-center gap-2 mb-6">
                <TrendingUp className="h-5 w-5 text-slate-900" />
                <h2 className="text-lg font-semibold text-slate-900">Budget Analysis</h2>
              </div>

              <div className="grid gap-6 md:grid-cols-2">
                <div className="space-y-4">
                  <h3 className="font-semibold text-slate-900">Cost by Priority</h3>
                  <div className="space-y-3">
                    <div className="flex justify-between items-center p-3 bg-amber-50 rounded-lg">
                      <span className="text-slate-700">High Priority (Urgent)</span>
                      <span className="font-semibold text-amber-700">${priorityBreakdown.high.toLocaleString()}</span>
                    </div>
                    <div className="flex justify-between items-center p-3 bg-blue-50 rounded-lg">
                      <span className="text-slate-700">Medium Priority</span>
                      <span className="font-semibold text-blue-700">${priorityBreakdown.medium.toLocaleString()}</span>
                    </div>
                    <div className="flex justify-between items-center p-3 bg-slate-50 rounded-lg">
                      <span className="text-slate-700">Low Priority</span>
                      <span className="font-semibold text-slate-700">${priorityBreakdown.low.toLocaleString()}</span>
                    </div>
                  </div>
                </div>

                <div className="space-y-4">
                  <h3 className="font-semibold text-slate-900">Timeline Breakdown</h3>
                  <div className="space-y-3">
                    <div className="flex justify-between items-center p-3 bg-red-50 rounded-lg">
                      <span className="text-slate-700">Immediate (Week 1)</span>
                      <span className="font-semibold text-red-700">${timelineBreakdown.immediate.toLocaleString()}</span>
                    </div>
                    <div className="flex justify-between items-center p-3 bg-orange-50 rounded-lg">
                      <span className="text-slate-700">Soon (Week 2)</span>
                      <span className="font-semibold text-orange-700">${timelineBreakdown.soon.toLocaleString()}</span>
                    </div>
                    <div className="flex justify-between items-center p-3 bg-purple-50 rounded-lg">
                      <span className="text-slate-700">Later (Month 3)</span>
                      <span className="font-semibold text-purple-700">${timelineBreakdown.later.toLocaleString()}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Protocol Cost Calculator */}
            <div className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-8 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
              <h3 className="text-lg font-semibold text-slate-900 mb-4">Custom Protocol Calculator</h3>

              <div className="grid gap-4 md:grid-cols-3">
                <div className="space-y-2">
                  <label className="text-sm font-medium text-slate-600">Protocol Duration (weeks)</label>
                  <Select defaultValue="12">
                    <SelectTrigger className="h-9">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="4">4 weeks</SelectItem>
                      <SelectItem value="8">8 weeks</SelectItem>
                      <SelectItem value="12">12 weeks</SelectItem>
                      <SelectItem value="16">16 weeks</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium text-slate-600">Number of Peptides</label>
                  <Select defaultValue="3">
                    <SelectTrigger className="h-9">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="1">1 peptide</SelectItem>
                      <SelectItem value="2">2 peptides</SelectItem>
                      <SelectItem value="3">3 peptides</SelectItem>
                      <SelectItem value="4">4 peptides</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium text-slate-600">Avg Cost per Vial</label>
                  <Select defaultValue="150">
                    <SelectTrigger className="h-9">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="50">$50</SelectItem>
                      <SelectItem value="100">$100</SelectItem>
                      <SelectItem value="150">$150</SelectItem>
                      <SelectItem value="200">$200</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="mt-6 p-4 bg-slate-50 rounded-lg">
                <div className="text-center">
                  <div className="text-2xl font-bold text-slate-900 mb-2">$1,350</div>
                  <div className="text-sm text-slate-600">Estimated total cost for 12-week protocol</div>
                  <div className="text-xs text-slate-500 mt-2">Based on 3 peptides at $150 average per vial</div>
                </div>
              </div>
            </div>

            {/* Savings Calculator */}
            <div className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-8 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
              <h3 className="text-lg font-semibold text-slate-900 mb-4">Potential Savings</h3>

              <div className="grid gap-4 md:grid-cols-2">
                <div className="p-4 bg-green-50 rounded-lg border border-green-200">
                  <div className="flex items-center gap-2 mb-2">
                    <PiggyBank className="h-4 w-4 text-green-600" />
                    <span className="font-semibold text-green-800">Bulk Purchase Discount</span>
                  </div>
                  <p className="text-sm text-green-700 mb-2">Order 3+ vials of same peptide</p>
                  <div className="text-lg font-bold text-green-800">Save $150</div>
                </div>

                <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
                  <div className="flex items-center gap-2 mb-2">
                    <Receipt className="h-4 w-4 text-blue-600" />
                    <span className="font-semibold text-blue-800">Supplier Comparison</span>
                  </div>
                  <p className="text-sm text-blue-700 mb-2">Shop around for better prices</p>
                  <div className="text-lg font-bold text-blue-800">Save $200</div>
                </div>
              </div>
            </div>
          </section>
        )}

        {/* Supply Plan Summary */}
        {supplyPlans.length > 0 && (
          <section className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-8 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
            <div className="flex items-center gap-2 mb-6">
              <Calculator className="h-5 w-5 text-slate-900" />
              <h2 className="text-lg font-semibold text-slate-900">Budgeted Plans</h2>
            </div>

            <div className="space-y-4">
              {supplyPlans.map((plan) => (
                <div key={plan.id} className="border border-slate-200 rounded-lg p-4">
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <h3 className="font-semibold text-slate-900">{plan.name}</h3>
                      <p className="text-sm text-slate-600">{plan.description}</p>
                    </div>
                    <Badge className={cn(
                      "text-xs",
                      plan.status === 'planned' ? "bg-blue-100 text-blue-700" :
                      plan.status === 'in-progress' ? "bg-amber-100 text-amber-700" :
                      "bg-emerald-100 text-emerald-700"
                    )}>
                      {plan.status}
                    </Badge>
                  </div>

                  <div className="grid grid-cols-4 gap-4 text-sm">
                    <div>
                      <div className="text-slate-600 mb-1">Duration</div>
                      <div className="font-mono font-medium text-slate-900">{plan.durationWeeks} weeks</div>
                    </div>
                    <div>
                      <div className="text-slate-600 mb-1">Items</div>
                      <div className="font-mono font-medium text-slate-900">{plan.purchases.length} peptides</div>
                    </div>
                    <div>
                      <div className="text-slate-600 mb-1">Total Cost</div>
                      <div className="font-mono font-medium text-slate-900">${plan.totalCost.toLocaleString()}</div>
                    </div>
                    <div>
                      <div className="text-slate-600 mb-1">Weekly Cost</div>
                      <div className="font-mono font-medium text-slate-900">${Math.round(plan.totalCost / plan.durationWeeks).toLocaleString()}</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Integration Links */}
        <section className="rounded-[18px] border border-slate-200/70 bg-white/95 px-6 py-8 shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)]">
          <h2 className="text-lg font-semibold text-blue-600 mb-4">Budget & Protocol Tools</h2>

          <div className="grid gap-4 md:grid-cols-2">
            <Link
              href="/tracker"
              className="flex items-center gap-3 p-4 rounded-lg border border-emerald-200 bg-emerald-50/50 hover:bg-emerald-100/50 transition-colors"
            >
              <Package className="h-5 w-5 text-emerald-600" />
              <div>
                <h3 className="font-semibold text-slate-900">Protocol Tracker</h3>
                <p className="text-sm text-slate-600">Monitor active protocols and track progress</p>
              </div>
            </Link>

            <Link
              href="/dosing-frequency"
              className="flex items-center gap-3 p-4 rounded-lg border border-blue-200 bg-blue-50/50 hover:bg-blue-100/50 transition-colors"
            >
              <Activity className="h-5 w-5 text-blue-600" />
              <div>
                <h3 className="font-semibold text-slate-900">Dosing Strategy Tool</h3>
                <p className="text-sm text-slate-600">Optimize dosing schedules and compare frequencies</p>
              </div>
            </Link>
          </div>
        </section>
      </div>
    </div>
  )
}
