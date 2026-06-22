import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {
    case free = "Free"
    case premium = "Premium"
    case familyPro = "Family Pro"
    case ultimateAI = "Ultimate AI"
    
    var monthlyPrice: String {
        switch self {
        case .free: return "$0"
        case .premium: return "$7.99/month"
        case .familyPro: return "$14.99/month"
        case .ultimateAI: return "$24.99/month"
        }
    }
    
    var allowedWeeklyPlans: Int {
        switch self {
        case .free: return 1
        case .premium, .familyPro, .ultimateAI: return 999
        }
    }
    
    var allowsFutureWeeks: Bool {
        self != .free
    }
    
    var allowsMealSwaps: Bool {
        self != .free
    }
    
    var allowsFamilyMemberPortions: Bool {
        self == .familyPro || self == .ultimateAI
    }
    
    var allowsPantryTracking: Bool {
        self == .familyPro || self == .ultimateAI
    }
    
    var allowsAIChatCoach: Bool {
        self == .ultimateAI
    }
    
    var allowsPhotoCalories: Bool {
        self == .ultimateAI
    }
    
    var allowsReports: Bool {
        self == .familyPro || self == .ultimateAI
    }
}
//
//  SubscriptionPlan.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/7/26.
//

