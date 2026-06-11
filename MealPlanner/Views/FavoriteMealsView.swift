import SwiftUI

struct FavoriteMealsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List {
            Section("Favorite Meals") {
                let favorites = appState.favoriteMeals()
                
                if favorites.isEmpty {
                    Text("No favorite meals yet. Rate meals 4 or 5 stars to see them here.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(favorites) { meal in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(meal.mealName)
                                .font(.headline)
                            
                            Text("\(meal.day) • \(meal.mealType)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(meal.rating) ⭐")
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorite Meals")
    }
}
//
//  FavoriteMealsView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

