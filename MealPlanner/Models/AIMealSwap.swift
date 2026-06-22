import Foundation

struct AIMealSwapResponse: Codable {
    let originalMeal: String
    let swaps: [AIMealSwap]
}

struct AIMealSwap: Codable, Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case name, calories, protein, carbs, fat, fiber, reason
    }
}

struct AINutritionCoachResponse: Codable {
    let answer: String
    let suggestions: [String]
}
//
//  AIMealSwap.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

