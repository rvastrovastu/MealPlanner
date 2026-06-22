import Foundation

struct LeftoverItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantity: String
    var dateAdded: Date
    var useByDate: Date
    var notes: String
    
    init(
        id: UUID = UUID(),
        name: String,
        quantity: String,
        dateAdded: Date = Date(),
        useByDate: Date,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.dateAdded = dateAdded
        self.useByDate = useByDate
        self.notes = notes
    }
}
//
//  LeftoverItem.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

