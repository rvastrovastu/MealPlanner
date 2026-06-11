import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var disease = ""
    @State private var savedMessage = ""
    
    var profile: UserProfile {
        UserProfile(
            firstName: firstName,
            lastName: lastName,
            age: age,
            height: height,
            weight: weight,
            disease: disease
        )
    }
    
    var body: some View {
        Form {
            Section("Account") {
                Text("Email: \(appState.userEmail)")
                
                Button("Logout") {
                    appState.logout()
                }
                .foregroundColor(.red)
            }
            
            Section("Customer Details") {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                TextField("Height in cm", text: $height)
                    .keyboardType(.decimalPad)
                TextField("Weight in kg", text: $weight)
                    .keyboardType(.decimalPad)
                TextField("Disease / Health condition", text: $disease)
            }
            
            Section("Health Result") {
                Text("BMI: \(profile.bmi, specifier: "%.1f")")
                Text("Suggested Daily Calories: \(profile.suggestedCalories)")
            }
            
            Section {
                Button("Save Profile") {
                    appState.saveProfile(profile)
                    savedMessage = "Profile saved successfully!"
                }
                
                if !savedMessage.isEmpty {
                    Text(savedMessage)
                        .foregroundColor(.green)
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            if let saved = appState.userProfile {
                firstName = saved.firstName
                lastName = saved.lastName
                age = saved.age
                height = saved.height
                weight = saved.weight
                disease = saved.disease
            }
        }
    }
}
//
//  ProfileView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

