import SwiftUI

struct AIMealSwapView: View {
    @EnvironmentObject var appState: AppState
    
    let meal: Meal
    
    @State private var swaps: [AIMealSwap] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        Group {
            if appState.canUseMealSwap() {
                content
            } else {
                UpgradeRequiredView(featureName: "AI Meal Swaps", requiredPlan: "Premium")
            }
        }
        .navigationTitle("AI Meal Swaps")
        .task {
            await loadSwaps()
        }
    }
    
    private var content: some View {
        List {
            Section("Original Meal") {
                Text(meal.name)
                    .font(.headline)
                Text("\(meal.calories) calories")
                    .foregroundColor(.gray)
            }
            
            if isLoading {
                ProgressView("Finding better alternatives...")
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Section("Recommended Swaps") {
                ForEach(swaps) { swap in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(swap.name)
                            .font(.headline)
                        
                        Text(swap.reason)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text("\(swap.calories) cal")
                            Text("\(Int(swap.protein))g protein")
                            Text("\(Int(swap.fiber))g fiber")
                        }
                        .font(.caption)
                        .foregroundColor(.green)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }
    
    private func loadSwaps() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let familyProfile = appState.currentFamilyProfile
            
            let response = try await MealPlanAPI.shared.getMealSwaps(
                mealName: meal.name,
                dietType: familyProfile?.dietType ?? "Balanced",
                restrictions: familyProfile?.restrictions ?? [],
                goal: familyProfile?.goal ?? "Healthy"
            )
            
            await MainActor.run {
                swaps = response.swaps
            }
        } catch {
            await MainActor.run {
                errorMessage = "Unable to load AI swaps."
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
}
//
//  AIMealSwapView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

