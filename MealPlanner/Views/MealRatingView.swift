import SwiftUI

struct MealRatingView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let dayName: String
    let mealType: String
    let mealName: String
    
    @State private var rating = 5
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Rate Meal") {
                    Text(mealName)
                        .font(.headline)
                    
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .font(.system(size: 32))
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                    .padding(.vertical)
                }
                
                Section("Notes") {
                    TextField("Example: Kids liked it, too spicy, make again...", text: $notes)
                }
                
                Button("Save Rating") {
                    let feedback = MealFeedback(
                        day: dayName,
                        mealType: mealType,
                        mealName: mealName,
                        rating: rating,
                        notes: notes
                    )
                    
                    appState.saveMealFeedback(feedback)
                    dismiss()
                }
            }
            .navigationTitle("Meal Rating")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
//
//  MealRatingView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

