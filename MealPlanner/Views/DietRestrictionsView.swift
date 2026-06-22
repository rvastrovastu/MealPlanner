import SwiftUI

struct DietRestrictionsView: View {
    @State var profile: FamilyProfile
    @State private var selectedRestrictions: Set<String> = []
    
    let restrictions = [
        "Low Sugar",
        "Low Sodium",
        "Gluten Free",
        "Dairy Free",
        "Nut Allergy",
        "No Onion Garlic",
        "Jain Food",
        "High Protein",
        "Low Carb",
        "Kids Friendly"
    ]
    
    var body: some View {
        List {
            Section("Select Restrictions") {
                ForEach(restrictions, id: \.self) { item in
                    Button {
                        toggle(item)
                    } label: {
                        HStack {
                            Text(item)
                            Spacer()
                            if selectedRestrictions.contains(item) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            
            NavigationLink {
                GenerateMealPlanView(profile: finalProfile())
            } label: {
                Text("Generate Weekly Meal Plan")
                    .bold()
            }
        }
        .navigationTitle("Diet Restrictions")
    }
    
    private func toggle(_ item: String) {
        if selectedRestrictions.contains(item) {
            selectedRestrictions.remove(item)
        } else {
            selectedRestrictions.insert(item)
        }
    }
    
    private func finalProfile() -> FamilyProfile {
        var updated = profile
        updated.restrictions = Array(selectedRestrictions)
        return updated
    }
}
//
//  DietRestrictionsView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//

