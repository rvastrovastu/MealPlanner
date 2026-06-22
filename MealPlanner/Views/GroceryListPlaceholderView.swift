import SwiftUI

struct GroceryListPlaceholderView: View {
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            Image(systemName: "cart.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Suggested Grocery Cart")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Generate a weekly meal plan first. Your recommended grocery items will automatically appear here.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Cart")
    }
}

#Preview {
    GroceryListPlaceholderView()
}
//
//  GroceryListPlaceholderView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

