import SwiftUI

struct GenerateMealPlanView: View {
    @EnvironmentObject var appState: AppState
    
    let profile: FamilyProfile
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var navigateToPlan = false
    @State private var showWeekPicker = false
    @State private var selectedWeekStartDate = Date()
    @State private var numberOfWeeks = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Generate Your Meal Plan")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("Choose the start week and generate one or multiple weekly plans.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                selectedWeekCard
                
                Button {
                    showWeekPicker = true
                } label: {
                    Label("Choose Start Week", systemImage: "calendar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                
                if appState.subscriptionPlan.allowsFutureWeeks {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How many weeks?")
                            .font(.headline)
                        
                        Picker("Number of Weeks", selection: $numberOfWeeks) {
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                        }
                        .pickerStyle(.segmented)
                    }
                } else {
                    Text("Free plan supports 1 current week only. Upgrade for multiple future weeks.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if isLoading {
                    ProgressView("Generating meal plan...")
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    Task {
                        await generateMultipleWeeks()
                    }
                } label: {
                    Text(isLoading ? "Generating..." : "Generate My Plan")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .disabled(isLoading)
                
                savedPlansPreview
                
                NavigationLink(destination: MealPlanView(), isActive: $navigateToPlan) {
                    EmptyView()
                }
            }
            .padding()
        }
        .navigationTitle("Generate")
        .sheet(isPresented: $showWeekPicker) {
            WeekPickerSheet(
                selectedWeekStartDate: $selectedWeekStartDate,
                isPresented: $showWeekPicker
            )
        }
        .onAppear {
            selectedWeekStartDate = startOfCurrentWeek()
            if !appState.subscriptionPlan.allowsFutureWeeks {
                numberOfWeeks = 1
            }
        }
    }
    
    private var selectedWeekCard: some View {
        VStack(spacing: 10) {
            Text("Selected Start Week")
                .font(.headline)
            
            Text(weekRangeText(from: selectedWeekStartDate))
                .font(.title3)
                .bold()
                .foregroundColor(.green)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.10))
        .cornerRadius(16)
    }
    
    private var savedPlansPreview: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Saved Plans")
                .font(.headline)
            
            if appState.savedMealPlans.isEmpty {
                Text("No saved plans yet.")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                ForEach(appState.savedMealPlans) { plan in
                    HStack {
                        Text("Week: \(plan.weekStartDate)")
                        Spacer()
                        if appState.currentMealPlan?.weekStartDate == plan.weekStartDate {
                            Text("Active")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .onTapGesture {
                        appState.selectMealPlan(plan)
                    }
                }
            }
        }
    }
    
    private func generateMultipleWeeks() async {
        isLoading = true
        errorMessage = nil
        
        let weeksToGenerate = appState.subscriptionPlan.allowsFutureWeeks ? numberOfWeeks : 1
        
        do {
            for offset in 0..<weeksToGenerate {
                guard let weekDate = Calendar.current.date(byAdding: .day, value: offset * 7, to: selectedWeekStartDate) else {
                    continue
                }
                
                var updatedProfile = profile
                updatedProfile.weekStartDate = apiDate(weekDate)
                updatedProfile.numberOfWeeks = 1
                
                let plan = try await MealPlanAPI.shared.generateMealPlan(profile: updatedProfile)
                
                await MainActor.run {
                    appState.saveFamilyProfile(updatedProfile)
                    appState.addMealPlan(plan)
                    appState.hasCompletedProfile = true
                }
            }
            
            await MainActor.run {
                navigateToPlan = true
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error: \(error.localizedDescription)"
                print("Meal plan error:", error)
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    private func startOfCurrentWeek() -> Date {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        return calendar.date(from: components) ?? today
    }
    
    private func weekRangeText(from date: Date) -> String {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: 6, to: date) ?? date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        return "\(formatter.string(from: date)) - \(formatter.string(from: endDate)), \(yearFormatter.string(from: date))"
    }
    
    private func apiDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
//
//  GenerateMealPlanView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//
