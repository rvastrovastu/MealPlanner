import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var pdfURL: URL?
    @State private var showShareSheet = false
    @State private var message = ""
    
    var body: some View {
        Group {
            if appState.subscriptionPlan == .familyPro || appState.subscriptionPlan == .ultimateAI {
                content
            } else {
                UpgradeRequiredView(
                    featureName: "PDF Reports & Export",
                    requiredPlan: "Family Pro"
                )
            }
        }
        .navigationTitle("Reports")
        .sheet(isPresented: $showShareSheet) {
            if let pdfURL {
                ShareSheet(items: [pdfURL])
            }
        }
    }
    
    private var content: some View {
        List {
            Section("Export Reports") {
                Button {
                    exportMealPlan()
                } label: {
                    Label("Export Weekly Meal Plan PDF", systemImage: "doc.richtext")
                }
                
                Button {
                    exportGroceryList()
                } label: {
                    Label("Export Grocery List PDF", systemImage: "cart")
                }
                
                Button {
                    exportNutritionReport()
                } label: {
                    Label("Export Nutrition Report PDF", systemImage: "heart.text.square")
                }
            }
            
            Section("Report Summary") {
                Text("Meals Completed: \(appState.confirmedMealCount()) / 21")
                Text("Weekly Calories: \(appState.weeklyConfirmedCalories())")
                Text("Meal Compliance: \(appState.mealCompliancePercent())%")
                Text("Average Rating: \(String(format: "%.1f", appState.averageMealRating()))")
            }
            
            if !message.isEmpty {
                Section {
                    Text(message)
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    private func exportMealPlan() {
        guard let plan = appState.currentMealPlan else {
            message = "Generate a meal plan first."
            return
        }
        
        if let url = PDFReportGenerator.shared.generateMealPlanPDF(plan: plan, appState: appState) {
            pdfURL = url
            showShareSheet = true
            message = "Meal plan PDF created."
        }
    }
    
    private func exportGroceryList() {
        guard let plan = appState.currentMealPlan else {
            message = "Generate a meal plan first."
            return
        }
        
        if let url = PDFReportGenerator.shared.generateGroceryPDF(groceryList: plan.groceryList, appState: appState) {
            pdfURL = url
            showShareSheet = true
            message = "Grocery PDF created."
        }
    }
    
    private func exportNutritionReport() {
        if let url = PDFReportGenerator.shared.generateNutritionPDF(appState: appState) {
            pdfURL = url
            showShareSheet = true
            message = "Nutrition report PDF created."
        }
    }
}
//
//  ReportsView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

