import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 18) {
                header
                healthOverview
                mealOverview
                budgetOverview
                quickActions
            }
            .padding()
        }
        .background(Color(red: 0.97, green: 0.99, blue: 0.95))
        .navigationTitle("Dashboard")
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Health Dashboard")
                .font(.system(size: 32, weight: .black, design: .rounded))
            
            Text("Track meals, calories, weight, BMI, budget and weekly progress.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var healthOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Health Overview")
                .font(.headline)
            
            HStack {
                DashboardTile(
                    title: "BMI",
                    value: bmiText,
                    subtitle: bmiStatus,
                    icon: "heart.fill",
                    color: .red
                )
                
                DashboardTile(
                    title: "Daily Goal",
                    value: "\(appState.dashboardDailyGoal())",
                    subtitle: "calories",
                    icon: "flame.fill",
                    color: .orange
                )
            }
            
            HStack {
                DashboardTile(
                    title: "Weight",
                    value: latestWeightText,
                    subtitle: "latest",
                    icon: "scalemass.fill",
                    color: .green
                )
                
                DashboardTile(
                    title: "Change",
                    value: weightChangeText,
                    subtitle: "progress",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
            }
        }
        .dashboardCard()
    }
    
    private var mealOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Meal Progress")
                .font(.headline)
            
            HStack {
                DashboardTile(
                    title: "Meals Done",
                    value: "\(appState.confirmedMealCount())",
                    subtitle: "of 21",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                DashboardTile(
                    title: "Compliance",
                    value: "\(appState.mealCompliancePercent())%",
                    subtitle: "this week",
                    icon: "target",
                    color: .purple
                )
            }
            
            HStack {
                DashboardTile(
                    title: "Calories",
                    value: "\(appState.weeklyConfirmedCalories())",
                    subtitle: "confirmed",
                    icon: "fork.knife",
                    color: .orange
                )
                
                DashboardTile(
                    title: "Plan",
                    value: appState.currentMealPlan == nil ? "No" : "Yes",
                    subtitle: "active",
                    icon: "calendar",
                    color: .green
                )
            }
        }
        .dashboardCard()
    }
    
    private var budgetOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Budget & Pantry")
                .font(.headline)
            
            HStack {
                DashboardTile(
                    title: "Budget",
                    value: String(format: "$%.0f", appState.weeklyBudget),
                    subtitle: appState.preferredStore,
                    icon: "dollarsign.circle.fill",
                    color: .green
                )
                
                DashboardTile(
                    title: "Pantry",
                    value: "\(appState.pantryItems.count)",
                    subtitle: "items",
                    icon: "cabinet.fill",
                    color: .brown
                )
            }
            
            if let plan = appState.currentMealPlan {
                DashboardTile(
                    title: "Est. Grocery",
                    value: String(
                        format: "$%.2f",
                        appState.estimatedGroceryCost(groceryList: plan.groceryList)
                    ),
                    subtitle: "need-to-buy",
                    icon: "cart.fill",
                    color: .green
                )
            }
        }
        .dashboardCard()
    }
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            NavigationLink {
                WeightTrackerView()
            } label: {
                QuickActionRow(icon: "scalemass.fill", title: "Weight Tracker", subtitle: "Add and view weight history")
            }
            
            NavigationLink {
                CaloriesAnalyticsView()
            } label: {
                QuickActionRow(icon: "chart.bar.fill", title: "Calories Analytics", subtitle: "View weekly calorie progress")
            }
            
            NavigationLink {
                PantryView()
            } label: {
                QuickActionRow(icon: "cabinet.fill", title: "Pantry Tracking", subtitle: "Manage available grocery items")
            }
        }
        .dashboardCard()
    }
    
    private var bmiText: String {
        guard let profile = appState.userProfile else { return "--" }
        return String(format: "%.1f", profile.bmi)
    }
    
    private var bmiStatus: String {
        guard let profile = appState.userProfile else { return "not set" }
        
        if profile.bmi < 18.5 { return "underweight" }
        if profile.bmi < 25 { return "normal" }
        if profile.bmi < 30 { return "overweight" }
        return "high"
    }
    
    private var latestWeightText: String {
        let weight = appState.latestWeight()
        return weight == 0 ? "--" : String(format: "%.1f", weight)
    }
    
    private var weightChangeText: String {
        let change = appState.weightChange()
        if change == 0 { return "0" }
        return String(format: "%+.1f", change)
    }
}

struct DashboardTile: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .frame(width: 42, height: 42)
                .background(color.opacity(0.12))
                .clipShape(Circle())
            
            Text(value)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(Color(red: 0.03, green: 0.13, blue: 0.10))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.green)
                .frame(width: 42, height: 42)
                .background(Color.green.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
    }
}

extension View {
    func dashboardCard() -> some View {
        self
            .padding()
            .background(Color.white.opacity(0.75))
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 5)
    }
}
//
//  DashboardView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

