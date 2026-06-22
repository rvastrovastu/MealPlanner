//
//  FamilySetupView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//
import SwiftUI

struct FamilySetupView: View {
    @State private var householdSize = 4
    @State private var maleAdults = 1
    @State private var femaleAdults = 1
    @State private var childrenAgesText = "6,9"
    @State private var dietType = "Vegetarian"
    @State private var cuisine = "Indian"
    @State private var goal = "Balanced Health"
    @State private var cookingTime = "30 minutes"
    
    let dietTypes = ["Vegetarian", "Vegan", "Non-Vegetarian", "Eggetarian"]
    let cuisines = ["Indian", "American", "Mexican", "Mediterranean", "Mixed"]
    let goals = ["Balanced Health", "Weight Loss", "High Protein", "Diabetes Friendly", "Kids Friendly"]
    
    var body: some View {
        Form {
            Section("Family Details") {
                Stepper("Household Size: \(householdSize)", value: $householdSize, in: 1...12)
                Stepper("Male Adults: \(maleAdults)", value: $maleAdults, in: 0...6)
                Stepper("Female Adults: \(femaleAdults)", value: $femaleAdults, in: 0...6)
                
                TextField("Children Ages, e.g. 6,9", text: $childrenAgesText)
                    .keyboardType(.numbersAndPunctuation)
            }
            
            Section("Food Preferences") {
                Picker("Diet Type", selection: $dietType) {
                    ForEach(dietTypes, id: \.self) { Text($0) }
                }
                
                Picker("Cuisine", selection: $cuisine) {
                    ForEach(cuisines, id: \.self) { Text($0) }
                }
                
                Picker("Goal", selection: $goal) {
                    ForEach(goals, id: \.self) { Text($0) }
                }
                
                Picker("Cooking Time", selection: $cookingTime) {
                    Text("20 minutes").tag("20 minutes")
                    Text("30 minutes").tag("30 minutes")
                    Text("45 minutes").tag("45 minutes")
                    Text("1 hour").tag("1 hour")
                }
            }
            
            NavigationLink {
                DietRestrictionsView(profile: buildProfile())
            } label: {
                Text("Next: Diet Restrictions")
            }
        }
        .navigationTitle("Family Setup")
    }
    
    private func buildProfile() -> FamilyProfile {
        let ages = childrenAgesText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        return FamilyProfile(
            householdSize: householdSize,
            maleAdults: maleAdults,
            femaleAdults: femaleAdults,
            childrenAges: ages,
            dietType: dietType,
            cuisinePreference: cuisine,
            restrictions: [],
            goal: goal,
            cookingTime: cookingTime
        )
    }
}
