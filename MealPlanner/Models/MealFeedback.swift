import Foundation

struct MealFeedback: Identifiable, Codable {
    let id: UUID
    var day: String
    var mealType: String
    var mealName: String
    var rating: Int
    var notes: String
    var date: Date
    
    init(
        id: UUID = UUID(),
        day: String,
        mealType: String,
        mealName: String,
        rating: Int,
        notes: String = "",
        date: Date = Date()
    ) {
        self.id = id
        self.day = day
        self.mealType = mealType
        self.mealName = mealName
        self.rating = rating
        self.notes = notes
        self.date = date
    }
}
//
//  MealFeedback.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

