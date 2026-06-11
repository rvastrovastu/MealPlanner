import Foundation

struct FamilyProfile: Codable {
    var householdSize: Int
    var maleAdults: Int
    var femaleAdults: Int
    var childrenAges: [Int]
    var dietType: String
    var cuisinePreference: String
    var restrictions: [String]
    var goal: String
    var cookingTime: String
    var weekStartDate: String?
    var numberOfWeeks: Int?
    
    var estimatedDailyFamilyCalories: Int {
        var total = 0
        total += maleAdults * 2400
        total += femaleAdults * 1900
        
        for age in childrenAges {
            if age <= 3 {
                total += 1000
            } else if age <= 8 {
                total += 1400
            } else if age <= 13 {
                total += 1800
            } else {
                total += 2100
            }
        }
        
        let countedPeople = maleAdults + femaleAdults + childrenAges.count
        let missingPeople = max(0, householdSize - countedPeople)
        total += missingPeople * 1800
        
        return total
    }
}
//
//  FamilyProfile.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//
