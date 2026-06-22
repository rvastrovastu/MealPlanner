import SwiftUI

struct MonthlyMealCalendarView: View {
    @EnvironmentObject var appState: AppState
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        Group {
            if appState.subscriptionPlan.allowsFutureWeeks {
                calendarContent
            } else {
                UpgradeRequiredView(featureName: "Monthly Meal Calendar", requiredPlan: "Premium")
            }
        }
        .navigationTitle("Monthly Calendar")
    }
    
    private var calendarContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                monthTitle
                calendarGrid
                activePlanCard
                savedPlansCard
            }
            .padding(.vertical)
        }
        .background(Color(red: 0.97, green: 0.99, blue: 0.95))
    }
    
    private var monthTitle: some View {
        Text(currentMonthTitle())
            .font(.largeTitle)
            .bold()
            .padding(.horizontal)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(weekDays.indices, id: \.self) { index in
                Text(weekDays[index])
                    .font(.caption)
                    .bold()
                    .foregroundColor(.gray)
            }
            
            ForEach(monthGridDays(), id: \.self) { day in
                if day == 0 {
                    Color.clear.frame(height: 58)
                } else {
                    CalendarDayCell(
                        day: day,
                        hasPlan: hasMealPlan(for: day),
                        isActivePlan: isActivePlanDay(day),
                        isToday: isToday(day)
                    )
                    .onTapGesture {
                        selectPlanForDay(day)
                    }
                }
            }
        }
        .padding()
    }
    
    private var activePlanCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Active Plan")
                .font(.headline)
            
            if let plan = appState.currentMealPlan {
                Text("Week Start: \(plan.weekStartDate)")
                Text("Dark green dates show the active plan. Light green dates show saved plans.")
                    .foregroundColor(.gray)
            } else {
                Text("No active meal plan yet.")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .padding(.horizontal)
    }
    
    private var savedPlansCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Saved Plans")
                .font(.headline)
            
            if appState.savedMealPlans.isEmpty {
                Text("No saved plans yet.")
                    .foregroundColor(.gray)
            } else {
                ForEach(appState.savedMealPlans) { plan in
                    Button {
                        appState.selectMealPlan(plan)
                    } label: {
                        HStack {
                            Text("Week \(plan.weekStartDate)")
                                .foregroundColor(.primary)
                            Spacer()
                            if appState.currentMealPlan?.weekStartDate == plan.weekStartDate {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .padding(.horizontal)
    }
    
    private func currentMonthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    private func monthGridDays() -> [Int] {
        let calendar = Calendar.current
        let today = Date()
        
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else {
            return []
        }
        
        let weekday = calendar.component(.weekday, from: firstDay)
        let leadingBlanks = weekday - 1
        
        return Array(repeating: 0, count: leadingBlanks) + Array(range)
    }
    
    private func hasMealPlan(for day: Int) -> Bool {
        appState.savedMealPlans.contains { plan in
            planContainsDay(plan, day: day)
        }
    }
    
    private func isActivePlanDay(_ day: Int) -> Bool {
        guard let plan = appState.currentMealPlan else { return false }
        return planContainsDay(plan, day: day)
    }
    
    private func selectPlanForDay(_ day: Int) {
        if let plan = appState.savedMealPlans.first(where: { planContainsDay($0, day: day) }) {
            appState.selectMealPlan(plan)
        }
    }
    
    private func planContainsDay(_ plan: MealPlan, day: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let start = formatter.date(from: plan.weekStartDate) else {
            return false
        }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        for offset in 0...6 {
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else {
                continue
            }
            
            let planDay = calendar.component(.day, from: date)
            let planMonth = calendar.component(.month, from: date)
            let planYear = calendar.component(.year, from: date)
            
            if planDay == day && planMonth == currentMonth && planYear == currentYear {
                return true
            }
        }
        
        return false
    }
    
    private func isToday(_ day: Int) -> Bool {
        Calendar.current.component(.day, from: Date()) == day
    }
}

struct CalendarDayCell: View {
    let day: Int
    let hasPlan: Bool
    let isActivePlan: Bool
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(day)")
                .font(.headline)
                .foregroundColor(isToday || isActivePlan ? .white : .primary)
            
            Circle()
                .fill(hasPlan ? Color.green : Color.clear)
                .frame(width: 8, height: 8)
        }
        .frame(height: 58)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(14)
    }
    
    private var backgroundColor: Color {
        if isActivePlan {
            return .green
        }
        
        if isToday {
            return .blue
        }
        
        if hasPlan {
            return Color.green.opacity(0.14)
        }
        
        return Color.green.opacity(0.05)
    }
}
