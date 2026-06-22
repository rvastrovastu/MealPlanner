import SwiftUI

struct CartView: View {
    @EnvironmentObject var appState: AppState
    let groceryList: GroceryList
    
    var body: some View {
        List {
            Section("Smart Cart Summary") {
                HStack {
                    Text("Estimated Need-to-Buy Cost")
                    Spacer()
                    Text("$\(appState.estimatedGroceryCost(groceryList: groceryList), specifier: "%.2f")")
                        .bold()
                        .foregroundColor(.green)
                }
                
                Text("Items already in pantry are marked green.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            CartSection(title: "Vegetables", items: groceryList.vegetables)
            CartSection(title: "Fruits", items: groceryList.fruits)
            CartSection(title: "Grains", items: groceryList.grains)
            CartSection(title: "Protein", items: groceryList.protein)
            CartSection(title: "Dairy", items: groceryList.dairy)
            CartSection(title: "Spices", items: groceryList.spices)
            CartSection(title: "Others", items: groceryList.others)
        }
        .navigationTitle("Smart Cart")
    }
}

struct CartSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        Section(title) {
            ForEach(items, id: \.self) { item in
                CartItemRow(item: item)
            }
        }
    }
}

struct CartItemRow: View {
    @EnvironmentObject var appState: AppState
    
    let item: String
    
    private var available: Bool {
        appState.pantryHasItem(item)
    }
    
    private var checked: Bool {
        appState.isCartItemChecked(item)
    }
    
    private var iconName: String {
        if available {
            return "checkmark.circle.fill"
        } else if checked {
            return "checkmark.square.fill"
        } else {
            return "square"
        }
    }
    
    private var iconColor: Color {
        if available {
            return .green
        } else if checked {
            return .blue
        } else {
            return .gray
        }
    }
    
    private var subtitleText: String {
        if available {
            return "Already in pantry"
        } else {
            return "Need to buy • $\(String(format: "%.2f", appState.estimatedItemPrice(item)))"
        }
    }
    
    private var subtitleColor: Color {
        available ? .green : .gray
    }
    
    var body: some View {
        Button {
            if !available {
                appState.toggleCartItem(item)
            }
        } label: {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                
                VStack(alignment: .leading) {
                    Text(item)
                        .foregroundColor(.primary)
                    
                    Text(subtitleText)
                        .font(.caption)
                        .foregroundColor(subtitleColor)
                }
                
                Spacer()
                
                if !available {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.green)
                }
            }
        }
    }
}
//
//  CartView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

