import SwiftUI

struct CaloriesTrackerView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List {
            Section("Daily Intake Calories") {
                ForEach(Array(appState.confirmedMeals.values)) { item in
                    VStack(alignment: .leading) {
                        Text("\(item.day) - \(item.mealType)")
                            .bold()
                        Text(item.selectedMealName)
                        Text("Calories: \(item.calories)")
                            .foregroundColor(.green)
                    }
                }
            }
            
            Section("Alternate Diet Suggestions") {
                Text("Choose Alternate option from daily meal details to enter what you actually ate.")
            }
        }
        .navigationTitle("Calories Tracker")
    }
}
//
//  CaloriesTrackerView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

