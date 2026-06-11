import SwiftUI

struct PantryView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var name = ""
    @State private var category = "Grains"
    @State private var quantity = ""
    @State private var editingItem: PantryItem?
    
    let categories = ["Vegetables", "Fruits", "Grains", "Protein", "Dairy", "Spices", "Others"]
    
    var body: some View {
        Group {
            if appState.subscriptionPlan.allowsPantryTracking {
                pantryContent
            } else {
                UpgradeRequiredView(featureName: "Pantry Tracking", requiredPlan: "Family Pro")
            }
        }
        .navigationTitle("Pantry")
    }
    
    private var pantryContent: some View {
        List {
            Section("Add Pantry Item") {
                TextField("Item name", text: $name)
                
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                
                TextField("Quantity, e.g. 2 lb / 1 packet", text: $quantity)
                
                Button(editingItem == nil ? "Add Item" : "Update Item") {
                    saveItem()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                
                if editingItem != nil {
                    Button("Cancel Edit") {
                        clearForm()
                    }
                    .foregroundColor(.red)
                }
            }
            
            Section("Available Pantry") {
                if appState.pantryItems.isEmpty {
                    Text("No pantry items yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(appState.pantryItems) { item in
                        Button {
                            editingItem = item
                            name = item.name
                            category = item.category
                            quantity = item.quantity
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("\(item.category) • \(item.quantity)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "pencil")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .onDelete(perform: appState.deletePantryItem)
                }
            }
        }
    }
    
    private func saveItem() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        if var editing = editingItem {
            editing.name = cleanName
            editing.category = category
            editing.quantity = quantity
            appState.updatePantryItem(editing)
        } else {
            let item = PantryItem(
                name: cleanName,
                category: category,
                quantity: quantity.isEmpty ? "Available" : quantity
            )
            appState.addPantryItem(item)
        }
        
        clearForm()
    }
    
    private func clearForm() {
        name = ""
        category = "Grains"
        quantity = ""
        editingItem = nil
    }
}
//
//  PantryView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

