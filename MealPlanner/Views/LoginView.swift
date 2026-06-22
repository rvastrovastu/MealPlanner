import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("mplogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("MealPlanner")
                .font(.largeTitle)
                .bold()
            
            Text("Login to save your profile and meal plans")
                .foregroundStyle(.secondary)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button {
                appState.login(email: email, password: password)
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            
            Button {
                appState.login(email: "guest@mealplanner.com", password: "guest")
            } label: {
                Text("Continue as Guest")
                    .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding()
    }
}
//
//  LoginView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

