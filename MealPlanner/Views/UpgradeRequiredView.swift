import SwiftUI

struct UpgradeRequiredView: View {
    let featureName: String
    let requiredPlan: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 70))
                .foregroundColor(.orange)
            
            Text("\(featureName) is Premium")
                .font(.title)
                .bold()
            
            Text("Upgrade to \(requiredPlan) to unlock this feature.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            NavigationLink {
                SubscriptionView()
            } label: {
                Text("View Plans")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Upgrade")
    }
}
//
//  UpgradeRequiredView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

