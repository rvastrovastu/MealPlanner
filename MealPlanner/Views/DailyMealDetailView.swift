import SwiftUI

struct DailyMealDetailView: View {
    @EnvironmentObject var appState: AppState
    let day: MealDay
    
    @State private var selectedMealType = "Breakfast"
    @State private var showCraving = false
    
    var selectedMeal: Meal {
        switch selectedMealType {
        case "Breakfast": return day.breakfast
        case "Lunch": return day.lunch
        case "Evening Snack": return day.eveningSnack
        default: return day.dinner
        }
    }
    
    var plannedCalories: Int {
        day.totalCalories
    }
    
    var body: some View {
        List {
            Section("Daily Summary") {
                Text("Confirmed Calories: \(appState.dailyCalories(day: day.day))")
                    .font(.headline)
                
                Text("Planned Calories Per Person: \(plannedCalories)")
                
                Text("Estimated Family Calories: \(plannedCalories * max(appState.currentFamilyProfile?.householdSize ?? 1, 1))")
                    .foregroundStyle(.secondary)
            }
            
            Section("Select Meal") {
                Picker("Meal", selection: $selectedMealType) {
                    Text("Breakfast").tag("Breakfast")
                    Text("Lunch").tag("Lunch")
                    Text("Evening Snack").tag("Evening Snack")
                    Text("Dinner").tag("Dinner")
                }
                .pickerStyle(.segmented)
            }
            
            Section("Selected Meal Details") {
                MealDetailCard(
                    dayName: day.day,
                    mealType: selectedMealType,
                    meal: selectedMeal
                )
            }
            
            Section("Adhoc Craving") {
                Button {
                    showCraving = true
                } label: {
                    Label("Add Adhoc Craving", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle(day.day)
        .sheet(isPresented: $showCraving) {
            AdhocCravingView(dayName: day.day)
                .environmentObject(appState)
        }
    }
}

struct MealDetailCard: View {
    @EnvironmentObject var appState: AppState
    @State private var showRating = false
    
    let dayName: String
    let mealType: String
    let meal: Meal
    
    var isConfirmed: Bool {
        appState.isMealConfirmed(day: dayName, mealType: mealType)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(mealType)
                    .font(.headline)
                
                Spacer()
                
                if isConfirmed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(meal.name)
                .font(.title3)
                .bold()
            
            HStack {
                NutritionMini(title: "Calories", value: "\(meal.calories)")
                NutritionMini(title: "Protein", value: "\(Int(meal.protein))g")
                NutritionMini(title: "Fiber", value: "\(Int(meal.fiber))g")
            }
            
            if appState.isFavoriteMeal(meal.name) {
                Label("Favorite Meal", systemImage: "star.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Ingredients")
                    .font(.caption)
                    .bold()
                
                Text(meal.ingredients.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if let recipe = meal.recipe {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe")
                        .font(.headline)
                    
                    Text("Prep: \(recipe.prepTime) • Cook: \(recipe.cookTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        Text("\(index + 1). \(step)")
                            .font(.caption)
                    }
                    
                    Text("Tip: \(recipe.tips)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.08))
                .cornerRadius(14)
            }
            
            HStack {
                Button {
                    appState.confirmMeal(day: dayName, mealType: mealType, meal: meal)
                    showRating = true
                } label: {
                    Label("I Ate This", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink {
                    AIMealSwapView(meal: meal)
                } label: {
                    Label("AI Swap", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showRating) {
            MealRatingView(
                dayName: dayName,
                mealType: mealType,
                mealName: meal.name
            )
            .environmentObject(appState)
        }
    }
}

struct NutritionMini: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
                .foregroundColor(.green)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.green.opacity(0.08))
        .cornerRadius(12)
    }
}
