import SwiftUI

struct WelcomeView: View {

    var body: some View {

        VStack(spacing: 24) {

            Spacer()

            Text("Never Ask “What to Cook?” Again")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text("Invest in Health, Grow Your Wealth")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.green)

            Text("Healthy weekly meal planning for your whole family.")
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            NavigationLink {
                FamilySetupView()
            } label: {
                Text("Create Family Meal Plan")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
//  WelcomeView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//
