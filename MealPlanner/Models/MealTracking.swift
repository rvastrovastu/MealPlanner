import Foundation

struct MealTracking: Identifiable {
    let id = UUID()
    let day: String
    let mealType: String
    var isConfirmed: Bool
    var selectedMealName: String
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double
}
//
//  MealTracking.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

