import Foundation

struct MealPlan: Codable, Identifiable {
    var id: String {
        weekStartDate
    }
    
    let weekStartDate: String
    let days: [MealDay]
    let groceryList: GroceryList
}

struct MealDay: Codable, Identifiable {
    let id = UUID()
    let day: String
    let breakfast: Meal
    let lunch: Meal
    let eveningSnack: Meal
    let dinner: Meal
    
    enum CodingKeys: String, CodingKey {
        case day, breakfast, lunch, eveningSnack, dinner
    }
    
    var totalCalories: Int {
        breakfast.calories + lunch.calories + eveningSnack.calories + dinner.calories
    }
}

struct Meal: Codable, Identifiable {
    let id = UUID()
    var name: String
    var ingredients: [String]
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double
    var recipe: Recipe?
    var portion: MealPortion?
    
    enum CodingKeys: String, CodingKey {
        case name, ingredients, calories, protein, carbs, fat, fiber, recipe, portion
    }
}

struct Recipe: Codable {
    var prepTime: String
    var cookTime: String
    var steps: [String]
    var tips: String
}

struct MealPortion: Codable {
    var totalFamilyQuantity: String
    var perPersonServing: String
    var maleAdultServing: String
    var femaleAdultServing: String
    var childServing: String
    var maleAdultCalories: Int
    var femaleAdultCalories: Int
    var childCalories: Int
}

struct GroceryList: Codable {
    let vegetables: [String]
    let fruits: [String]
    let grains: [String]
    let protein: [String]
    let dairy: [String]
    let spices: [String]
    let others: [String]
}
