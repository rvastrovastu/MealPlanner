import SwiftUI

struct MealHistoryView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List {
            Section("Summary") {
                Text("Tracked Meals: \(appState.confirmedMealCount())")
                Text("Total Calories: \(appState.weeklyConfirmedCalories())")
                Text("Adhoc Cravings: \(appState.adhocCravings().count)")
            }
            
            Section("Adhoc Cravings") {
                if appState.adhocCravings().isEmpty {
                    Text("No adhoc cravings tracked.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(appState.adhocCravings()) { item in
                        MealHistoryRow(item: item)
                    }
                }
            }
            
            Section("All Tracked Meals") {
                if appState.allTrackedMeals().isEmpty {
                    Text("No meals tracked yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(appState.allTrackedMeals()) { item in
                        MealHistoryRow(item: item)
                    }
                    .onDelete { offsets in
                        let items = appState.allTrackedMeals()
                        for index in offsets {
                            let item = items[index]
                            appState.deleteTrackedMeal(day: item.day, mealType: item.mealType)
                        }
                    }
                }
            }
        }
        .navigationTitle("Meal History")
    }
}

struct MealHistoryRow: View {
    let item: MealTracking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(item.day) • \(item.mealType)")
                .font(.headline)
            
            Text(item.selectedMealName)
                .foregroundColor(.gray)
            
            HStack {
                Text("\(item.calories) cal")
                Text("\(Int(item.protein))g protein")
                Text("\(Int(item.carbs))g carbs")
            }
            .font(.caption)
            .foregroundColor(.green)
        }
        .padding(.vertical, 4)
    }
}//
//  MealHistoryView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

