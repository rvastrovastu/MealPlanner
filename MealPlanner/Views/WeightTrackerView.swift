import SwiftUI

struct WeightTrackerView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var weightText = ""
    
    var body: some View {
        List {
            Section("Add Weight") {
                TextField("Enter weight", text: $weightText)
                    .keyboardType(.decimalPad)
                
                Button("Save Weight") {
                    saveWeight()
                }
                .disabled(Double(weightText) == nil)
            }
            
            Section("Summary") {
                HStack {
                    Text("Starting Weight")
                    Spacer()
                    Text("\(appState.startingWeight(), specifier: "%.1f")")
                        .bold()
                }
                
                HStack {
                    Text("Latest Weight")
                    Spacer()
                    Text("\(appState.latestWeight(), specifier: "%.1f")")
                        .bold()
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("Change")
                    Spacer()
                    Text("\(appState.weightChange(), specifier: "%+.1f")")
                        .bold()
                }
            }
            
            Section("History") {
                if appState.weightHistory.isEmpty {
                    Text("No weight entries yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(appState.weightHistory) { entry in
                        HStack {
                            Text(formatDate(entry.date))
                            Spacer()
                            Text("\(entry.weight, specifier: "%.1f")")
                                .bold()
                        }
                    }
                    .onDelete(perform: appState.deleteWeightEntry)
                }
            }
        }
        .navigationTitle("Weight Tracker")
    }
    
    private func saveWeight() {
        guard let weight = Double(weightText) else { return }
        appState.addWeightEntry(weight: weight)
        weightText = ""
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
//
//  WeightTrackerView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

