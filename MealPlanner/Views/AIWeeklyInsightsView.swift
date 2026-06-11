import SwiftUI

struct AIWeeklyInsightsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.subscriptionPlan == .ultimateAI {
                insightsContent
            } else {
                UpgradeRequiredView(
                    featureName: "AI Weekly Insights",
                    requiredPlan: "Ultimate AI"
                )
            }
        }
        .navigationTitle("AI Insights")
    }
    
    private var insightsContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                InsightCard(
                    title: "Meal Completion",
                    value: "\(appState.mealCompliancePercent())%",
                    message: "You completed \(appState.confirmedMealCount()) out of 21 planned meals this week.",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                InsightCard(
                    title: "Calories Tracked",
                    value: "\(appState.weeklyConfirmedCalories())",
                    message: "These are confirmed calories from meals marked as eaten.",
                    icon: "flame.fill",
                    color: .orange
                )
                
                InsightCard(
                    title: "Meal Satisfaction",
                    value: String(format: "%.1f ⭐", appState.averageMealRating()),
                    message: "Average rating from meals you reviewed.",
                    icon: "star.fill",
                    color: .yellow
                )
                
                InsightCard(
                    title: "Pantry Savings",
                    value: "\(appState.pantryItems.count)",
                    message: "Pantry items helped reduce duplicate grocery purchases.",
                    icon: "cabinet.fill",
                    color: .brown
                )
                
                SectionCard(title: "Favorite Meals") {
                    if appState.favoriteMeals().isEmpty {
                        Text("No favorite meals yet. Rate meals 4 or 5 stars to see them here.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(appState.favoriteMeals().prefix(5)) { meal in
                            HStack {
                                Text(meal.mealName)
                                Spacer()
                                Text("\(meal.rating) ⭐")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(red: 0.97, green: 0.99, blue: 0.95))
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    let message: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 28))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 5)
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 5)
    }
}
//
//  AIWeeklyInsightsView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

