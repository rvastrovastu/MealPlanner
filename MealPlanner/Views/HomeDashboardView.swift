import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var showMenu = false
    
    private let darkText = Color(red: 0.03, green: 0.11, blue: 0.12)
    private let brandGreen = Color(red: 0.08, green: 0.48, blue: 0.08)
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    heroSection
                    healthBanner
                    mealPlanCard
                    featureStrip
                }
                .padding(.bottom, 35)
            }
            .background(Color(red: 0.98, green: 0.995, blue: 0.96))
            
            menuButton
        }
        .navigationBarHidden(true)
    }
    
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .center) {
                HStack(spacing: 10) {
                    Image("mplogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 0) {
                            Text("Meal")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(brandGreen)
                            
                            Text("Planner")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(darkText)
                        }
                        
                        Text("— PLAN • EAT • THRIVE —")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(darkText)
                            .tracking(1.6)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Never Ask")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundColor(darkText)
                
                Text("“What to Cook ?”")
                    .font(.system(size: 39, weight: .black, design: .rounded))
                    .foregroundColor(brandGreen)
                
                Text("Again")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundColor(darkText)
            }
            .minimumScaleFactor(0.72)
            
            HStack(spacing: 10) {
                Rectangle()
                    .frame(width: 62, height: 3)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 18))
                
                Rectangle()
                    .frame(width: 62, height: 3)
            }
            .foregroundColor(brandGreen)
            
            foodHeroCard
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 12)
        .background(
            LinearGradient(
                colors: [
                    Color.white,
                    Color(red: 0.92, green: 0.98, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var foodHeroCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 7)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Fresh Balanced Bowl")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(darkText)
                    
                    Text("Healthy meals planned for your family’s taste, calories and budget.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .lineLimit(3)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(brandGreen.opacity(0.12))
                        .frame(width: 125, height: 125)
                    
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 82))
                        .foregroundColor(brandGreen)
                }
            }
            .padding(20)
        }
        .frame(height: 170)
    }
    
    private var healthBanner: some View {
        HStack(spacing: 5) {
            Text("Time to")
                .foregroundColor(darkText)
            
            Text("Invest")
                .italic()
                .fontWeight(.black)
                .foregroundColor(brandGreen)
            
            Text("in")
                .foregroundColor(darkText)
            
            Text("Health")
                .italic()
                .fontWeight(.black)
                .foregroundColor(brandGreen)
            
            Text("to grow")
                .foregroundColor(darkText)
            
            Text("Wealth")
                .italic()
                .fontWeight(.black)
                .foregroundColor(brandGreen)
        }
        .font(.system(size: 18, weight: .bold, design: .rounded))
        .minimumScaleFactor(0.55)
        .lineLimit(1)
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color.yellow.opacity(0.96),
                    Color.green.opacity(0.20)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(brandGreen.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(14)
        .padding(.horizontal, 16)
    }
    
    private var mealPlanCard: some View {
        NavigationLink {
            FamilySetupView()
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Generate\nWeekly\nMeal Plan")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(darkText)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.8)
                    
                    Rectangle()
                        .frame(width: 48, height: 4)
                        .foregroundColor(brandGreen)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Which fit your")
                        HStack(spacing: 4) {
                            Text("Calorie")
                                .fontWeight(.bold)
                                .foregroundColor(brandGreen)
                            Text("need")
                        }
                        HStack(spacing: 4) {
                            Text("and")
                            Text("Budget")
                                .fontWeight(.bold)
                                .foregroundColor(brandGreen)
                        }
                    }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(darkText)
                    
                    Text("✨ Create My Plan")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 13)
                        .background(brandGreen)
                        .cornerRadius(14)
                        .shadow(color: brandGreen.opacity(0.35), radius: 8, x: 0, y: 4)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "checklist")
                        .font(.system(size: 70))
                        .foregroundColor(brandGreen.opacity(0.9))
                    
                    Image(systemName: "target")
                        .font(.system(size: 52))
                        .foregroundColor(Color(red: 0.10, green: 0.38, blue: 0.16))
                    
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.12))
                            .frame(width: 90, height: 90)
                        
                        VStack(spacing: 0) {
                            Image(systemName: "bowl.fill")
                                .font(.system(size: 34))
                                .foregroundColor(.brown)
                            
                            HStack(spacing: 2) {
                                Text("🍎")
                                Text("🥦")
                                Text("🥕")
                            }
                            .font(.system(size: 20))
                            .offset(y: -8)
                        }
                    }
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 310)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 0.92, green: 0.98, blue: 0.88))
            )
            .shadow(color: .black.opacity(0.10), radius: 12, x: 0, y: 7)
            .padding(.horizontal, 18)
        }
        .buttonStyle(.plain)
    }
    
    private var featureStrip: some View {
        HStack(spacing: 0) {
            FeatureItem(icon: "leaf.fill", title: "Healthy\nMeals", color: brandGreen)
            Divider()
            FeatureItem(icon: "wallet.pass.fill", title: "Budget\nFriendly", color: brandGreen)
            Divider()
            FeatureItem(icon: "target", title: "Personalized\nfor You", color: brandGreen)
            Divider()
            FeatureItem(icon: "heart.fill", title: "Better Health\nBetter Life", color: brandGreen)
        }
        .padding(.vertical, 18)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
        .padding(.horizontal, 18)
    }
    
    private var menuButton: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                    showMenu.toggle()
                }
            } label: {
                Image("mplogo")
                    .resizable()
                    .scaledToFit()
                    .padding(6)
                    .frame(width: 58, height: 58)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
            }
            
            if showMenu {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 0) {
                        MenuNavigationRow(icon: "person.fill", title: "Profile", destination: AnyView(ProfileView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        MenuNavigationRow(icon: "chart.bar.fill", title: "Dashboard", destination: AnyView(DashboardView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        if let plan = appState.currentMealPlan {
                            MenuNavigationRow(icon: "cart.fill", title: "Cart", destination: AnyView(CartView(groceryList: plan.groceryList)), showMenu: $showMenu)
                        } else {
                            MenuNavigationRow(icon: "cart.fill", title: "Cart", destination: AnyView(GroceryListPlaceholderView()), showMenu: $showMenu)
                        }
                        
                        Divider().padding(.leading, 58)
                        MenuNavigationRow(icon: "calendar", title: "Weekly Plan", destination: AnyView(MealPlanView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        MenuNavigationRow(icon: "crown.fill", title: "Subscription", destination: AnyView(SubscriptionView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        MenuNavigationRow(icon: "cabinet.fill", title: "Pantry", destination: AnyView(PantryView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "sparkles",
                            title: "AI Coach",
                            destination: AnyView(AINutritionCoachView()),
                            showMenu: $showMenu
                        )
                        
                        MenuNavigationRow(icon: "dollarsign.circle.fill", title: "Budget Planner", destination: AnyView(BudgetPlannerView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        MenuNavigationRow(icon: "calendar.badge.clock", title: "Monthly Calendar", destination: AnyView(MonthlyMealCalendarView()), showMenu: $showMenu)
                        Divider().padding(.leading, 58)
                        
                        MenuNavigationRow(icon: "flame.fill", title: "Calories Tracker", destination: AnyView(CaloriesTrackerView()), showMenu: $showMenu)
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "scalemass.fill",
                            title: "Weight Tracker",
                            destination: AnyView(WeightTrackerView()),
                            showMenu: $showMenu
                        )
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "brain.head.profile",
                            title: "AI Insights",
                            destination: AnyView(AIWeeklyInsightsView()),
                            showMenu: $showMenu
                        )
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "doc.text.fill",
                            title: "Reports",
                            destination: AnyView(ReportsView()),
                            showMenu: $showMenu
                        )
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "clock.arrow.circlepath",
                            title: "Meal History",
                            destination: AnyView(MealHistoryView()),
                            showMenu: $showMenu
                        )
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "star.fill",
                            title: "Favorite Meals",
                            destination: AnyView(FavoriteMealsView()),
                            showMenu: $showMenu
                        )
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "chart.bar.fill",
                            title: "Calories Analytics",
                            destination: AnyView(CaloriesAnalyticsView()),
                            showMenu: $showMenu
                        )
                        
                        Divider().padding(.leading, 58)

                        MenuNavigationRow(
                            icon: "refrigerator.fill",
                            title: "Leftovers",
                            destination: AnyView(LeftoverView()),
                            showMenu: $showMenu
                        )
                    }
                }
                .frame(width: 255)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(22)
                .shadow(color: .black.opacity(0.20), radius: 14, x: 0, y: 8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.top, 48)
        .padding(.trailing, 20)
    }
}

struct MenuNavigationRow: View {
    let icon: String
    let title: String
    let destination: AnyView
    @Binding var showMenu: Bool
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.green)
                    .frame(width: 36, height: 36)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.04, green: 0.23, blue: 0.18))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                showMenu = false
            }
        )
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .frame(width: 46, height: 46)
                .background(color.opacity(0.11))
                .clipShape(Circle())
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.04, green: 0.23, blue: 0.18))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
