import Foundation

struct UserProfile: Codable {
    var firstName: String
    var lastName: String
    var age: String
    var height: String
    var weight: String
    var disease: String
    
    var bmi: Double {
        guard let h = Double(height), let w = Double(weight), h > 0 else { return 0 }
        let meters = h / 100
        return w / (meters * meters)
    }
    
    var suggestedCalories: Int {
        guard let w = Double(weight) else { return 0 }
        return Int(w * 30)
    }
}
//
//  UserProfile.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

