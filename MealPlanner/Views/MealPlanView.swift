import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.99, blue: 0.95)
                .ignoresSafeArea()
            
            if let plan = appState.currentMealPlan {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 18) {
                        savedPlansSelector
                        headerSection(plan: plan)
                        weeklySummary(plan: plan)
                        weekCalendar(plan: plan)
                        dailyMealCards(plan: plan)
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            } else {
                emptyState
            }
        }
        .navigationTitle("Weekly Meal Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var savedPlansSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved Meal Plans")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            if appState.savedMealPlans.isEmpty {
                Text("No saved plans yet.")
                    .foregroundColor(.gray)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(appState.savedMealPlans) { plan in
                            Button {
                                appState.selectMealPlan(plan)
                            } label: {
                                VStack(spacing: 6) {
                                    Text("Week")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    
                                    Text(shortDate(plan.weekStartDate))
                                        .font(.system(size: 15, weight: .bold))
                                    
                                    if appState.currentMealPlan?.weekStartDate == plan.weekStartDate {
                                        Text("Active")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding()
                                .frame(width: 112)
                                .background(
                                    appState.currentMealPlan?.weekStartDate == plan.weekStartDate
                                    ? Color.green.opacity(0.14)
                                    : Color.white
                                )
                                .cornerRadius(18)
                                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                NavigationLink {
                    SavedPlansManagementView()
                } label: {
                    Label("Manage Saved Plans", systemImage: "folder.fill")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.75))
        .cornerRadius(24)
    }
    
    private func headerSection(plan: MealPlan) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week’s Meal Plan")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(Color(red: 0.03, green: 0.13, blue: 0.10))
            
            Text("Week Start: \(plan.weekStartDate)")
                .font(.headline)
                .foregroundColor(.green)
            
            Text("Smart weekly calendar with calories, nutrition and family-based portion planning.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func weeklySummary(plan: MealPlan) -> some View {
        let plannedWeeklyCalories = plan.days.map { $0.totalCalories }.reduce(0, +)
        let plannedDailyAverage = plannedWeeklyCalories / max(plan.days.count, 1)
        let familyNeed = familyDailyNeed()
        let perPersonNeed = perPersonDailyNeed()
        
        return VStack(spacing: 14) {
            HStack {
                SummaryTile(title: "Family Need", value: "\(familyNeed)", subtitle: "cal/day", icon: "person.3.fill", color: .green)
                SummaryTile(title: "Plan Avg", value: "\(plannedDailyAverage)", subtitle: "cal/day", icon: "fork.knife", color: .orange)
            }
            
            HStack {
                SummaryTile(title: "Per Person", value: "\(perPersonNeed)", subtitle: "cal/day", icon: "person.fill", color: .blue)
                SummaryTile(title: "BMI Goal", value: "\(profileCalorieGoal())", subtitle: "cal/day", icon: "heart.fill", color: .red)
            }
        }
    }
    
    private func weekCalendar(plan: MealPlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selected Week")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(plan.days.enumerated()), id: \.element.id) { index, day in
                        NavigationLink {
                            DailyMealDetailView(day: day)
                        } label: {
                            WeekDayCard(
                                day: day,
                                dateText: dateTextForPlan(plan.weekStartDate, offset: index),
                                familyCalories: familyMealAdjustedCalories(day.totalCalories),
                                perPersonCalories: perPersonMealAdjustedCalories(day.totalCalories),
                                confirmedCalories: appState.dailyCalories(day: day.day)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 6)
    }
    
    private func dailyMealCards(plan: MealPlan) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Daily Meal Details")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            
            ForEach(plan.days) { day in
                NavigationLink {
                    DailyMealDetailView(day: day)
                } label: {
                    DayMealSummaryCard(
                        day: day,
                        familyCalories: familyMealAdjustedCalories(day.totalCalories),
                        perPersonCalories: perPersonMealAdjustedCalories(day.totalCalories)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 18) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 68))
                .foregroundColor(.green)
            
            Text("No meal plan found")
                .font(.title2)
                .bold()
            
            Text("Create a weekly meal plan to see calories, nutrition and grocery list.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            NavigationLink {
                FamilySetupView()
            } label: {
                Text("Create Meal Plan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(14)
            }
        }
        .padding()
    }
    
    private func householdSize() -> Int {
        appState.currentFamilyProfile?.householdSize ?? 1
    }
    
    private func familyDailyNeed() -> Int {
        appState.currentFamilyProfile?.estimatedDailyFamilyCalories ?? appState.userProfile?.suggestedCalories ?? 2000
    }
    
    private func perPersonDailyNeed() -> Int {
        familyDailyNeed() / max(householdSize(), 1)
    }
    
    private func profileCalorieGoal() -> Int {
        appState.userProfile?.suggestedCalories ?? perPersonDailyNeed()
    }
    
    private func familyMealAdjustedCalories(_ baseCalories: Int) -> Int {
        baseCalories * max(householdSize(), 1)
    }
    
    private func perPersonMealAdjustedCalories(_ baseCalories: Int) -> Int {
        baseCalories
    }
    
    private func dateTextForPlan(_ weekStartDate: String, offset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let start = formatter.date(from: weekStartDate),
              let date = Calendar.current.date(byAdding: .day, value: offset, to: start) else {
            return ""
        }
        
        let display = DateFormatter()
        display.dateFormat = "MMM d"
        return display.string(from: date)
    }
    
    private func shortDate(_ dateText: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"
        
        guard let date = input.date(from: dateText) else {
            return dateText
        }
        
        let output = DateFormatter()
        output.dateFormat = "MMM d"
        return output.string(from: date)
    }
}

struct SavedPlansManagementView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List {
            Section("Saved Plans") {
                if appState.savedMealPlans.isEmpty {
                    Text("No saved plans.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(appState.savedMealPlans) { plan in
                        Button {
                            appState.selectMealPlan(plan)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Week Start: \(plan.weekStartDate)")
                                        .font(.headline)
                                    
                                    Text("\(plan.days.count) days • \(weeklyCalories(plan)) cal/person weekly")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if appState.currentMealPlan?.weekStartDate == plan.weekStartDate {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    .onDelete(perform: appState.deleteMealPlan)
                }
            }
        }
        .navigationTitle("Manage Plans")
    }
    
    private func weeklyCalories(_ plan: MealPlan) -> Int {
        plan.days.map { $0.totalCalories }.reduce(0, +)
    }
}

struct SummaryTile: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(Color(red: 0.03, green: 0.13, blue: 0.10))
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct WeekDayCard: View {
    let day: MealDay
    let dateText: String
    let familyCalories: Int
    let perPersonCalories: Int
    let confirmedCalories: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text(day.day.prefix(3).uppercased())
                .font(.system(size: 14, weight: .black))
                .foregroundColor(.green)
            Text(dateText)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(familyCalories)")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(Color(red: 0.03, green: 0.13, blue: 0.10))
            Text("family cal")
                .font(.caption2)
                .foregroundColor(.gray)
            Divider()
            Text("\(perPersonCalories)/person")
                .font(.caption)
                .foregroundColor(.green)
            
            if confirmedCalories > 0 {
                Label("\(confirmedCalories)", systemImage: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(width: 118, height: 185)
        .background(Color(red: 0.94, green: 0.99, blue: 0.92))
        .cornerRadius(22)
    }
}

struct DayMealSummaryCard: View {
    let day: MealDay
    let familyCalories: Int
    let perPersonCalories: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.day)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(Color(red: 0.03, green: 0.13, blue: 0.10))
                    
                    Text("Family: \(familyCalories) cal • Per person: \(perPersonCalories) cal")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 10) {
                MealMiniChip(title: "B", meal: day.breakfast)
                MealMiniChip(title: "L", meal: day.lunch)
                MealMiniChip(title: "S", meal: day.eveningSnack)
                MealMiniChip(title: "D", meal: day.dinner)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 5)
    }
}

struct MealMiniChip: View {
    let title: String
    let meal: Meal
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.green)
            Text("\(meal.calories)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text("cal")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.green.opacity(0.08))
        .cornerRadius(14)
    }
}
//
//  MealPlanView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/5/26.
//

