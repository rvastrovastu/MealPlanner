import SwiftUI

struct AINutritionCoachView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var question = ""
    @State private var answer = ""
    @State private var suggestions: [String] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        Group {
            if appState.canUseAIChatCoach() {
                coachContent
            } else {
                UpgradeRequiredView(featureName: "AI Nutrition Coach", requiredPlan: "Ultimate AI")
            }
        }
        .navigationTitle("AI Coach")
    }
    
    private var coachContent: some View {
        VStack(spacing: 16) {
            Text("Ask your AI nutrition coach")
                .font(.title2)
                .bold()
            
            TextField("Example: What should I eat tonight?", text: $question)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button {
                Task {
                    await askCoach()
                }
            } label: {
                Text("Ask Coach")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .disabled(question.isEmpty || isLoading)
            
            if isLoading {
                ProgressView("Thinking...")
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    if !answer.isEmpty {
                        Text(answer)
                            .padding()
                            .background(Color.green.opacity(0.10))
                            .cornerRadius(14)
                    }
                    
                    ForEach(suggestions, id: \.self) { item in
                        Label(item, systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .padding(.top)
    }
    
    private func askCoach() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let response = try await MealPlanAPI.shared.askNutritionCoach(
                question: question,
                profile: appState.userProfile
            )
            
            await MainActor.run {
                answer = response.answer
                suggestions = response.suggestions
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "AI Coach Error: \(error.localizedDescription)"
                print("AI Coach Error:", error)
            }
        }

        
        await MainActor.run {
            isLoading = false
        }
    }
}
//
//  AINutritionCoachView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

