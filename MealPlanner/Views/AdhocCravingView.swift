import SwiftUI

struct AdhocCravingView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let dayName: String
    
    @State private var cravingName = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    @State private var fiber = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("What did you crave/eat?") {
                    TextField("Example: Samosa, Pizza slice, Ice cream", text: $cravingName)
                    
                    TextField("Calories", text: $calories)
                        .keyboardType(.numberPad)
                    
                    TextField("Protein grams", text: $protein)
                        .keyboardType(.decimalPad)
                    
                    TextField("Carbs grams", text: $carbs)
                        .keyboardType(.decimalPad)
                    
                    TextField("Fat grams", text: $fat)
                        .keyboardType(.decimalPad)
                    
                    TextField("Fiber grams", text: $fiber)
                        .keyboardType(.decimalPad)
                }
                
                Button("Save Craving") {
                    saveCraving()
                }
                .disabled(cravingName.isEmpty)
            }
            .navigationTitle("Adhoc Craving")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveCraving() {
        appState.confirmAlternateMeal(
            day: dayName,
            mealType: "Adhoc Craving",
            name: cravingName,
            calories: Int(calories) ?? 0,
            protein: Double(protein) ?? 0,
            carbs: Double(carbs) ?? 0,
            fat: Double(fat) ?? 0,
            fiber: Double(fiber) ?? 0
        )
        
        dismiss()
    }
}
//
//  AdhocCravingView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

