import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Choose Your Plan")
                    .font(.largeTitle)
                    .bold()
                
                ForEach(SubscriptionPlan.allCases, id: \.self) { plan in
                    SubscriptionCard(plan: plan)
                }
            }
            .padding()
        }
        .navigationTitle("Subscription")
    }
}

struct SubscriptionCard: View {
    @EnvironmentObject var appState: AppState
    let plan: SubscriptionPlan
    
    var isCurrent: Bool {
        appState.subscriptionPlan == plan
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(plan.rawValue)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text(plan.monthlyPrice)
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                feature("Weekly meal plans: \(plan.allowedWeeklyPlans == 999 ? "Unlimited" : "\(plan.allowedWeeklyPlans)")")
                feature(plan.allowsFutureWeeks ? "Future week/month planning" : "Current week only")
                feature(plan.allowsMealSwaps ? "AI meal swaps" : "No meal swaps")
                feature(plan.allowsFamilyMemberPortions ? "Family member portions" : "Basic portions")
                feature(plan.allowsPantryTracking ? "Pantry tracking" : "No pantry tracking")
                feature(plan.allowsAIChatCoach ? "AI nutrition coach" : "No AI coach")
                feature(plan.allowsPhotoCalories ? "Photo calorie detection" : "No photo calorie scan")
                feature(plan.allowsReports ? "Monthly family reports" : "Basic summary only")
            }
            
            Button {
                appState.updateSubscription(plan)
            } label: {
                Text(isCurrent ? "Current Plan" : "Select Plan")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isCurrent ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .disabled(isCurrent)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 5)
    }
    
    private func feature(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
        }
    }
}
//
//  SubscriptionView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

