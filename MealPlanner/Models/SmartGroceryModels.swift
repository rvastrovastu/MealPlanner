import Foundation

struct GroceryStoreLink: Codable, Identifiable {
    var id: String { name }
    let name: String
    let quantity: String
    let walmart: String
    let instacart: String
    let amazonFresh: String
}

struct StoreLinksResponse: Codable {
    let links: [GroceryStoreLink]
}

struct GroceryChecklistItem: Codable, Identifiable {
    var id: String { name }
    let name: String
    let quantity: String
    var checked: Bool
}

struct NeedToBuyResponse: Codable {
    let checklist: [GroceryChecklistItem]
}

struct CostEstimateResponse: Codable {
    let walmart: Double
    let instacart: Double
    let amazonFresh: Double
}

struct SmartGroceryItem: Codable, Identifiable {
    var id: String { name }
    let name: String
    let quantity: String
    let category: String
    let estimatedPrice: Double
    var pantryAvailable: Bool
}
//
//  SmartGroceryModels.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/13/26.
//

