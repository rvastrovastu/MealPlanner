import SwiftUI

struct CaloriesAnalyticsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                weeklyBarChart
                confirmedMealsList
            }
            .padding()
        }
        .background(Color(red: 0.97, green: 0.99, blue: 0.95))
        .navigationTitle("Calories Analytics")
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Calories")
                .font(.system(size: 30, weight: .black, design: .rounded))
            
            Text("Confirmed calories from meals marked as eaten.")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var weeklyBarChart: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Current Week")
                .font(.headline)
            
            ForEach(days, id: \.self) { day in
                let calories = appState.dailyCalories(day: day)
                CalorieBarRow(day: day, calories: calories, goal: appState.dashboardDailyGoal())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
    }
    
    private var confirmedMealsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Confirmed Meals")
                .font(.headline)
            
            if appState.confirmedMeals.isEmpty {
                Text("No confirmed meals yet.")
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(appState.confirmedMeals.values)) { meal in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(meal.day) • \(meal.mealType)")
                                .font(.headline)
                            Text(meal.selectedMealName)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("\(meal.calories) cal")
                            .bold()
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                }
            }
        }
    }
    
    private var days: [String] {
        ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    }
}

struct CalorieBarRow: View {
    let day: String
    let calories: Int
    let goal: Int
    
    var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(calories) / Double(goal), 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(day.prefix(3))
                    .font(.caption)
                    .bold()
                    .frame(width: 42, alignment: .leading)
                
                Text("\(calories) / \(goal)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.green.opacity(0.12))
                    
                    Capsule()
                        .fill(Color.green)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 12)
        }
    }
}
//
//  CaloriesAnalyticsView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

