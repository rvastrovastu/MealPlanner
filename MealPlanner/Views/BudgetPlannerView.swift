import SwiftUI

struct BudgetPlannerView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var weeklyBudget = ""
    @State private var storePreference = "Walmart"
    
    let stores = ["Walmart", "Costco", "Kroger", "Indian Store", "Any Store"]
    
    var estimatedCost: Double {
        guard let plan = appState.currentMealPlan else { return 0 }
        return appState.estimatedGroceryCost(groceryList: plan.groceryList)
    }
    
    var budgetAmount: Double {
        Double(weeklyBudget) ?? appState.weeklyBudget
    }
    
    var isOverBudget: Bool {
        budgetAmount > 0 && estimatedCost > budgetAmount
    }
    
    var body: some View {
        Group {
            if appState.subscriptionPlan == .premium ||
                appState.subscriptionPlan == .familyPro ||
                appState.subscriptionPlan == .ultimateAI {
                budgetContent
            } else {
                UpgradeRequiredView(featureName: "Budget Meal Planner", requiredPlan: "Premium")
            }
        }
        .navigationTitle("Budget Planner")
        .onAppear {
            weeklyBudget = appState.weeklyBudget == 0 ? "100" : String(format: "%.0f", appState.weeklyBudget)
            storePreference = appState.preferredStore
        }
    }
    
    private var budgetContent: some View {
        Form {
            Section("Weekly Budget") {
                TextField("Budget amount", text: $weeklyBudget)
                    .keyboardType(.decimalPad)
                
                Picker("Preferred Store", selection: $storePreference) {
                    ForEach(stores, id: \.self) { Text($0) }
                }
                
                Button("Save Budget") {
                    appState.saveBudget(amount: budgetAmount, store: storePreference)
                }
            }
            
            Section("Estimated Grocery Cost") {
                Text("$\(estimatedCost, specifier: "%.2f")")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(isOverBudget ? .red : .green)
                
                if budgetAmount > 0 {
                    Text("Budget: $\(budgetAmount, specifier: "%.2f")")
                    Text(isOverBudget ? "Over budget by $\(estimatedCost - budgetAmount, specifier: "%.2f")" : "Within budget")
                        .foregroundColor(isOverBudget ? .red : .green)
                }
            }
            
            Section("Savings from Pantry") {
                if let plan = appState.currentMealPlan {
                    let totalItems = appState.allGroceryItems(from: plan.groceryList).count
                    let pantryMatched = appState.allGroceryItems(from: plan.groceryList).filter { appState.pantryHasItem($0) }.count
                    
                    Text("Items already in pantry: \(pantryMatched) of \(totalItems)")
                    Text("Store preference: \(storePreference)")
                } else {
                    Text("Generate meal plan first.")
                        .foregroundColor(.gray)
                }
            }
            
            Section("Budget Advice") {
                Text("Use pantry items first")
                Text("Buy grains and lentils in bulk")
                Text("Reuse vegetables across multiple meals")
                Text("Avoid duplicate grocery items")
            }
        }
    }
}
//
//  BudgetPlannerView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

