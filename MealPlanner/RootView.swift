import SwiftUI
import Combine

struct RootView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        NavigationStack {
            if appState.isLoggedIn {
                HomeDashboardView()
            } else {
                LoginView()
            }
        }
        .environmentObject(appState)
        .onAppear {
            appState.loadProfile()
            appState.loadFamilyProfile()
            appState.loadPantryItems()
            appState.loadWeightHistory()
            appState.loadMealFeedbacks()
            appState.loadMealPlansFromStorage()
            appState.loadLeftovers()

        }
    }
}

class AppState: ObservableObject {

    @Published var hasCompletedProfile: Bool = false
    @Published var currentMealPlan: MealPlan?
    @Published var confirmedMeals: [String: MealTracking] = [:]

    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @Published var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @Published var userProfile: UserProfile? = nil
    @Published var currentFamilyProfile: FamilyProfile?

    @Published var subscriptionPlan: SubscriptionPlan =
        SubscriptionPlan(rawValue: UserDefaults.standard.string(forKey: "subscriptionPlan") ?? "Free") ?? .free

    @Published var pantryItems: [PantryItem] = []
    @Published var checkedCartItems: Set<String> = []
    @Published var weeklyBudget: Double = UserDefaults.standard.double(forKey: "weeklyBudget")
    @Published var preferredStore: String = UserDefaults.standard.string(forKey: "preferredStore") ?? "Walmart"
    @Published var weightHistory: [WeightEntry] = []

    @Published var mealFeedbacks: [MealFeedback] = []
    @Published var savedMealPlans: [MealPlan] = []
    
    @Published var leftoverItems: [LeftoverItem] = []

    func saveLeftovers() {
        if let data = try? JSONEncoder().encode(leftoverItems) {
            UserDefaults.standard.set(data, forKey: "leftoverItems")
        }
    }

    func loadLeftovers() {
        if let data = UserDefaults.standard.data(forKey: "leftoverItems"),
           let items = try? JSONDecoder().decode([LeftoverItem].self, from: data) {
            leftoverItems = items
        }
    }

    func addLeftover(_ item: LeftoverItem) {
        leftoverItems.append(item)
        saveLeftovers()
    }

    func deleteLeftover(at offsets: IndexSet) {
        leftoverItems.remove(atOffsets: offsets)
        saveLeftovers()
    }

    func leftoverIdeas(for name: String) -> [String] {
        let lower = name.lowercased()
        
        if lower.contains("dal") {
            return ["Dal Paratha", "Dal Soup", "Dal Khichdi"]
        }
        if lower.contains("rice") {
            return ["Fried Rice", "Curd Rice", "Rice Cutlet"]
        }
        if lower.contains("paneer") {
            return ["Paneer Wrap", "Paneer Sandwich", "Paneer Bhurji"]
        }
        if lower.contains("roti") {
            return ["Roti Roll", "Roti Poha", "Roti Chips"]
        }
        
        return ["Healthy Bowl", "Wrap", "Soup"]
    }
    
    func topFavoriteMealNames() -> [String] {
        favoriteMeals()
            .map { $0.mealName }
            .removingDuplicates()
    }

    func isFavoriteMeal(_ mealName: String) -> Bool {
        mealFeedbacks.contains {
            $0.mealName == mealName && $0.rating >= 4
        }
    }
    
    func saveMealPlansToStorage() {
        if let data = try? JSONEncoder().encode(savedMealPlans) {
            UserDefaults.standard.set(data, forKey: "savedMealPlans")
        }
    }

    func loadMealPlansFromStorage() {
        if let data = UserDefaults.standard.data(forKey: "savedMealPlans"),
           let plans = try? JSONDecoder().decode([MealPlan].self, from: data) {
            savedMealPlans = plans.sorted { $0.weekStartDate < $1.weekStartDate }
            currentMealPlan = savedMealPlans.last
        }
    }
    func allTrackedMeals() -> [MealTracking] {
        confirmedMeals.values.sorted {
            $0.day < $1.day
        }
    }

    func deleteTrackedMeal(day: String, mealType: String) {
        let key = trackingKey(day: day, mealType: mealType)
        confirmedMeals.removeValue(forKey: key)
    }

    func adhocCravings() -> [MealTracking] {
        confirmedMeals.values
            .filter { $0.mealType == "Adhoc Craving" }
            .sorted { $0.day < $1.day }
    }
    
    func addMealPlan(_ plan: MealPlan) {
        if let index = savedMealPlans.firstIndex(where: { $0.weekStartDate == plan.weekStartDate }) {
            savedMealPlans[index] = plan
        } else {
            savedMealPlans.append(plan)
        }
        
        savedMealPlans.sort { $0.weekStartDate < $1.weekStartDate }
        currentMealPlan = plan
        saveMealPlansToStorage()
    }

    func selectMealPlan(_ plan: MealPlan) {
        currentMealPlan = plan
    }

    func deleteMealPlan(at offsets: IndexSet) {
        savedMealPlans.remove(atOffsets: offsets)
        currentMealPlan = savedMealPlans.last
        saveMealPlansToStorage()
    }

    func saveMealFeedbacks() {
        if let data = try? JSONEncoder().encode(mealFeedbacks) {
            UserDefaults.standard.set(data, forKey: "mealFeedbacks")
        }
    }

    func loadMealFeedbacks() {
        if let data = UserDefaults.standard.data(forKey: "mealFeedbacks"),
           let feedbacks = try? JSONDecoder().decode([MealFeedback].self, from: data) {
            mealFeedbacks = feedbacks
        }
    }

    func saveMealFeedback(_ feedback: MealFeedback) {
        if let index = mealFeedbacks.firstIndex(where: {
            $0.day == feedback.day &&
            $0.mealType == feedback.mealType &&
            $0.mealName == feedback.mealName
        }) {
            mealFeedbacks[index] = feedback
        } else {
            mealFeedbacks.append(feedback)
        }
        
        saveMealFeedbacks()
    }

    func averageMealRating() -> Double {
        guard !mealFeedbacks.isEmpty else { return 0 }
        let total = mealFeedbacks.map { $0.rating }.reduce(0, +)
        return Double(total) / Double(mealFeedbacks.count)
    }

    func favoriteMeals() -> [MealFeedback] {
        mealFeedbacks
            .filter { $0.rating >= 4 }
            .sorted { $0.rating > $1.rating }
    }
    
    func saveWeightHistory() {
        if let data = try? JSONEncoder().encode(weightHistory) {
            UserDefaults.standard.set(data, forKey: "weightHistory")
        }
    }

    func loadWeightHistory() {
        if let data = UserDefaults.standard.data(forKey: "weightHistory"),
           let history = try? JSONDecoder().decode([WeightEntry].self, from: data) {
            weightHistory = history
        }
    }

    func addWeightEntry(weight: Double) {
        let entry = WeightEntry(weight: weight)
        weightHistory.append(entry)
        saveWeightHistory()
    }

    func deleteWeightEntry(at offsets: IndexSet) {
        weightHistory.remove(atOffsets: offsets)
        saveWeightHistory()
    }

    func latestWeight() -> Double {
        weightHistory.last?.weight ?? Double(userProfile?.weight ?? "") ?? 0
    }

    func startingWeight() -> Double {
        weightHistory.first?.weight ?? Double(userProfile?.weight ?? "") ?? 0
    }

    func weightChange() -> Double {
        latestWeight() - startingWeight()
    }

    func weeklyConfirmedCalories() -> Int {
        confirmedMeals.values
            .map { $0.calories }
            .reduce(0, +)
    }

    func confirmedMealCount() -> Int {
        confirmedMeals.count
    }

    func mealCompliancePercent() -> Int {
        let totalMeals = 21
        guard totalMeals > 0 else { return 0 }
        return Int((Double(confirmedMealCount()) / Double(totalMeals)) * 100)
    }

    func dashboardDailyGoal() -> Int {
        userProfile?.suggestedCalories ?? currentFamilyProfile?.estimatedDailyFamilyCalories ?? 2000
    }

    func login(email: String, password: String) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(trimmedEmail, forKey: "userEmail")

        isLoggedIn = true
        userEmail = trimmedEmail

        loadProfile()
        loadFamilyProfile()
        loadPantryItems()
    }

    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn = false
        userEmail = ""
    }

    func saveProfile(_ profile: UserProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
            userProfile = profile
        }
    }

    func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        }
    }

    func saveFamilyProfile(_ profile: FamilyProfile) {
        currentFamilyProfile = profile

        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "familyProfile")
        }
    }

    func loadFamilyProfile() {
        if let data = UserDefaults.standard.data(forKey: "familyProfile"),
           let profile = try? JSONDecoder().decode(FamilyProfile.self, from: data) {
            currentFamilyProfile = profile
        }
    }

    func updateSubscription(_ plan: SubscriptionPlan) {
        subscriptionPlan = plan
        UserDefaults.standard.set(plan.rawValue, forKey: "subscriptionPlan")
    }

    func canUseMealSwap() -> Bool {
        subscriptionPlan.allowsMealSwaps
    }

    func canUseFamilyPortions() -> Bool {
        subscriptionPlan.allowsFamilyMemberPortions
    }

    func canUseAIChatCoach() -> Bool {
        subscriptionPlan.allowsAIChatCoach
    }

    func savePantryItems() {
        if let data = try? JSONEncoder().encode(pantryItems) {
            UserDefaults.standard.set(data, forKey: "pantryItems")
        }
    }

    func loadPantryItems() {
        if let data = UserDefaults.standard.data(forKey: "pantryItems"),
           let items = try? JSONDecoder().decode([PantryItem].self, from: data) {
            pantryItems = items
        }
    }

    func addPantryItem(_ item: PantryItem) {
        pantryItems.append(item)
        savePantryItems()
    }

    func updatePantryItem(_ item: PantryItem) {
        if let index = pantryItems.firstIndex(where: { $0.id == item.id }) {
            pantryItems[index] = item
            savePantryItems()
        }
    }

    func deletePantryItem(at offsets: IndexSet) {
        pantryItems.remove(atOffsets: offsets)
        savePantryItems()
    }

    func pantryHasItem(_ name: String) -> Bool {
        pantryItems.contains { pantryItem in
            let pantryName = pantryItem.name.lowercased()
            let groceryName = name.lowercased()

            return pantryName.contains(groceryName) || groceryName.contains(pantryName)
        }
    }

    func toggleCartItem(_ item: String) {
        if checkedCartItems.contains(item) {
            checkedCartItems.remove(item)
        } else {
            checkedCartItems.insert(item)
        }
    }

    func isCartItemChecked(_ item: String) -> Bool {
        checkedCartItems.contains(item)
    }

    func saveBudget(amount: Double, store: String) {
        weeklyBudget = amount
        preferredStore = store

        UserDefaults.standard.set(amount, forKey: "weeklyBudget")
        UserDefaults.standard.set(store, forKey: "preferredStore")
    }

    func estimatedItemPrice(_ item: String) -> Double {
        let lower = item.lowercased()

        if lower.contains("paneer") || lower.contains("tofu") || lower.contains("greek yogurt") {
            return 6.99
        }

        if lower.contains("rice") || lower.contains("flour") || lower.contains("quinoa") || lower.contains("oats") {
            return 4.99
        }

        if lower.contains("dal") || lower.contains("rajma") || lower.contains("chickpeas") || lower.contains("lentils") {
            return 3.99
        }

        if lower.contains("milk") || lower.contains("curd") {
            return 3.49
        }

        if lower.contains("spice") || lower.contains("turmeric") || lower.contains("cumin") || lower.contains("masala") {
            return 2.99
        }

        if lower.contains("banana") || lower.contains("apple") || lower.contains("berries") {
            return 4.49
        }

        return 2.99
    }

    func allGroceryItems(from groceryList: GroceryList) -> [String] {
        groceryList.vegetables +
        groceryList.fruits +
        groceryList.grains +
        groceryList.protein +
        groceryList.dairy +
        groceryList.spices +
        groceryList.others
    }

    func estimatedGroceryCost(groceryList: GroceryList) -> Double {
        allGroceryItems(from: groceryList)
            .filter { !pantryHasItem($0) }
            .map { estimatedItemPrice($0) }
            .reduce(0, +)
    }

    func trackingKey(day: String, mealType: String) -> String {
        "\(day)-\(mealType)"
    }

    func confirmMeal(day: String, mealType: String, meal: Meal) {
        let key = trackingKey(day: day, mealType: mealType)

        confirmedMeals[key] = MealTracking(
            day: day,
            mealType: mealType,
            isConfirmed: true,
            selectedMealName: meal.name,
            calories: meal.calories,
            protein: meal.protein,
            carbs: meal.carbs,
            fat: meal.fat,
            fiber: meal.fiber
        )
    }

    func confirmAlternateMeal(
        day: String,
        mealType: String,
        name: String,
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        fiber: Double
    ) {
        let key = trackingKey(day: day, mealType: mealType)

        confirmedMeals[key] = MealTracking(
            day: day,
            mealType: mealType,
            isConfirmed: true,
            selectedMealName: name,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            fiber: fiber
        )
    }

    func dailyCalories(day: String) -> Int {
        confirmedMeals.values
            .filter { $0.day == day }
            .map { $0.calories }
            .reduce(0, +)
    }

    func isMealConfirmed(day: String, mealType: String) -> Bool {
        let key = trackingKey(day: day, mealType: mealType)
        return confirmedMeals[key]?.isConfirmed ?? false
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
