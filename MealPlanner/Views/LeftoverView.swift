import SwiftUI

struct LeftoverView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var name = ""
    @State private var quantity = ""
    @State private var notes = ""
    @State private var useByDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    
    var body: some View {
        Group {
            if appState.subscriptionPlan == .familyPro || appState.subscriptionPlan == .ultimateAI {
                content
            } else {
                UpgradeRequiredView(featureName: "Leftover Management", requiredPlan: "Family Pro")
            }
        }
        .navigationTitle("Leftovers")
    }
    
    private var content: some View {
        List {
            Section("Add Leftover") {
                TextField("Food name, e.g. Dal, Rice", text: $name)
                TextField("Quantity, e.g. 2 cups", text: $quantity)
                DatePicker("Use By", selection: $useByDate, displayedComponents: .date)
                TextField("Notes", text: $notes)
                
                Button("Save Leftover") {
                    save()
                }
                .disabled(name.isEmpty)
            }
            
            Section("Saved Leftovers") {
                if appState.leftoverItems.isEmpty {
                    Text("No leftovers saved.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(appState.leftoverItems) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.headline)
                            
                            Text("\(item.quantity) • Use by \(formatDate(item.useByDate))")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if !item.notes.isEmpty {
                                Text(item.notes)
                                    .font(.caption)
                            }
                            
                            Text("Reuse Ideas")
                                .font(.caption)
                                .bold()
                            
                            ForEach(appState.leftoverIdeas(for: item.name), id: \.self) { idea in
                                Label(idea, systemImage: "lightbulb.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: appState.deleteLeftover)
                }
            }
        }
    }
    
    private func save() {
        let item = LeftoverItem(
            name: name,
            quantity: quantity.isEmpty ? "Available" : quantity,
            useByDate: useByDate,
            notes: notes
        )
        
        appState.addLeftover(item)
        name = ""
        quantity = ""
        notes = ""
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
//
//  LeftoverView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

