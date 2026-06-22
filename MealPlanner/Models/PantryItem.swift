import Foundation

struct PantryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var quantity: String
    var expiryDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        quantity: String,
        expiryDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.quantity = quantity
        self.expiryDate = expiryDate
    }
}
//
//  PantryItem.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

