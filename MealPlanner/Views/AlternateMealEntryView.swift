import SwiftUI

struct AlternateMealEntryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let dayName: String
    let mealType: String
    
    @State private var mealName = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    @State private var fiber = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Alternate Meal") {
                    TextField("Meal Name", text: $mealName)
                    
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
                
                Button {
                    saveAlternateMeal()
                } label: {
                    Text("Save Alternate Meal")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("\(mealType) Alternate")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveAlternateMeal() {
        appState.confirmAlternateMeal(
            day: dayName,
            mealType: mealType,
            name: mealName.isEmpty ? "Alternate Meal" : mealName,
            calories: Int(calories) ?? 0,
            protein: Double(protein) ?? 0,
            carbs: Double(carbs) ?? 0,
            fat: Double(fat) ?? 0,
            fiber: Double(fiber) ?? 0
        )
        
        dismiss()
    }
}
