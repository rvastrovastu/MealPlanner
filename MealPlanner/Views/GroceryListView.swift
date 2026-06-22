import SwiftUI

struct GroceryListView: View {
    let groceryList: GroceryList
    
    var body: some View {
        List {
            GrocerySection(title: "Vegetables", items: groceryList.vegetables)
            GrocerySection(title: "Fruits", items: groceryList.fruits)
            GrocerySection(title: "Grains", items: groceryList.grains)
            GrocerySection(title: "Protein", items: groceryList.protein)
            GrocerySection(title: "Dairy", items: groceryList.dairy)
            GrocerySection(title: "Spices", items: groceryList.spices)
            GrocerySection(title: "Others", items: groceryList.others)
        }
        .navigationTitle("Grocery List")
    }
}

struct GrocerySection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        Section(title) {
            ForEach(items, id: \.self) { item in
                HStack {
                    Image(systemName: "cart")
                    Text(item)
                }
            }
        }
    }
}
//
//  GroceryListView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//

