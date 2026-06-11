import Foundation
import UIKit

class PDFReportGenerator {
    
    static let shared = PDFReportGenerator()
    
    private init() {}
    
    func generateMealPlanPDF(plan: MealPlan, appState: AppState) -> URL? {
        let fileName = "MealPlan-\(plan.weekStartDate).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                
                var y: CGFloat = 40
                
                drawTitle("MealPlanner Weekly Report", y: &y)
                drawText("Week Start: \(plan.weekStartDate)", y: &y, size: 14)
                drawText("User: \(appState.userEmail)", y: &y, size: 12)
                y += 15
                
                drawSection("Weekly Meal Plan", y: &y)
                
                for day in plan.days {
                    drawText("\(day.day)", y: &y, size: 16, bold: true)
                    drawText("Breakfast: \(day.breakfast.name) - \(day.breakfast.calories) cal", y: &y)
                    drawText("Lunch: \(day.lunch.name) - \(day.lunch.calories) cal", y: &y)
                    drawText("Dinner: \(day.dinner.name) - \(day.dinner.calories) cal", y: &y)
                    drawText("Total Calories/person: \(day.totalCalories)", y: &y, size: 11)
                    y += 10
                    
                    if y > 720 {
                        context.beginPage()
                        y = 40
                    }
                }
            }
            
            return url
        } catch {
            print("PDF generation error:", error)
            return nil
        }
    }
    
    func generateGroceryPDF(groceryList: GroceryList, appState: AppState) -> URL? {
        let fileName = "GroceryList.pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                
                var y: CGFloat = 40
                
                drawTitle("MealPlanner Grocery List", y: &y)
                drawText("Estimated Cost: $\(String(format: "%.2f", appState.estimatedGroceryCost(groceryList: groceryList)))", y: &y, size: 14)
                y += 15
                
                drawGrocerySection("Vegetables", groceryList.vegetables, appState: appState, y: &y)
                drawGrocerySection("Fruits", groceryList.fruits, appState: appState, y: &y)
                drawGrocerySection("Grains", groceryList.grains, appState: appState, y: &y)
                drawGrocerySection("Protein", groceryList.protein, appState: appState, y: &y)
                drawGrocerySection("Dairy", groceryList.dairy, appState: appState, y: &y)
                drawGrocerySection("Spices", groceryList.spices, appState: appState, y: &y)
                drawGrocerySection("Others", groceryList.others, appState: appState, y: &y)
            }
            
            return url
        } catch {
            print("PDF generation error:", error)
            return nil
        }
    }
    
    func generateNutritionPDF(appState: AppState) -> URL? {
        let fileName = "NutritionReport.pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                
                var y: CGFloat = 40
                
                drawTitle("Weekly Nutrition Report", y: &y)
                drawText("Email: \(appState.userEmail)", y: &y)
                drawText("Weekly Confirmed Calories: \(appState.weeklyConfirmedCalories())", y: &y)
                drawText("Meals Completed: \(appState.confirmedMealCount()) / 21", y: &y)
                drawText("Compliance: \(appState.mealCompliancePercent())%", y: &y)
                drawText("Average Meal Rating: \(String(format: "%.1f", appState.averageMealRating()))", y: &y)
                y += 15
                
                drawSection("Confirmed Meals", y: &y)
                
                for meal in appState.confirmedMeals.values {
                    drawText("\(meal.day) - \(meal.mealType): \(meal.selectedMealName)", y: &y)
                    drawText("Calories: \(meal.calories)", y: &y, size: 11)
                    y += 6
                    
                    if y > 720 {
                        context.beginPage()
                        y = 40
                    }
                }
            }
            
            return url
        } catch {
            print("PDF generation error:", error)
            return nil
        }
    }
    
    private func drawTitle(_ text: String, y: inout CGFloat) {
        drawText(text, y: &y, size: 24, bold: true)
        y += 10
    }
    
    private func drawSection(_ text: String, y: inout CGFloat) {
        drawText(text, y: &y, size: 18, bold: true)
        y += 6
    }
    
    private func drawText(_ text: String, y: inout CGFloat, size: CGFloat = 12, bold: Bool = false) {
        let font = bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let rect = CGRect(x: 40, y: y, width: 532, height: 24)
        text.draw(in: rect, withAttributes: attributes)
        y += 20
    }
    
    private func drawGrocerySection(_ title: String, _ items: [String], appState: AppState, y: inout CGFloat) {
        drawSection(title, y: &y)
        
        for item in items {
            let status = appState.pantryHasItem(item) ? "Already in pantry" : "Need to buy"
            drawText("• \(item) - \(status)", y: &y)
        }
        
        y += 8
    }
}
//
//  PDFReportGenerator.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/8/26.
//

