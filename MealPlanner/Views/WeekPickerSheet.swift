import SwiftUI

struct WeekPickerSheet: View {
    @Binding var selectedWeekStartDate: Date
    @Binding var isPresented: Bool
    
    @State private var tempDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Select Week")
                    .font(.largeTitle)
                    .bold()
                
                Text("Choose any date. We will generate the plan for that full week.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                DatePicker(
                    "Choose Date",
                    selection: $tempDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                VStack(spacing: 8) {
                    Text("Selected Week")
                        .font(.headline)
                    
                    Text(weekRangeText(from: startOfWeek(tempDate)))
                        .font(.title3)
                        .bold()
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.10))
                .cornerRadius(16)
                
                Button {
                    selectedWeekStartDate = startOfWeek(tempDate)
                    isPresented = false
                } label: {
                    Text("Use This Week")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            tempDate = selectedWeekStartDate
        }
    }
    
    private func startOfWeek(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
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
}
//
//  WeekPickerSheet.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

