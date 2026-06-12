import Foundation

class MealPlanAPI {
    static let shared = MealPlanAPI()
    
    private let baseURL = "https://mealplanner-4owd.onrender.com/api"
    
    private init() {}
    
    func generateMealPlan(profile: FamilyProfile) async throws -> MealPlan {
        guard let url = URL(string: "\(baseURL)/meal-plan/generate") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(profile)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try validateResponse(response, data: data)
        
        return try decode(MealPlan.self, from: data)
    }
    
    func getMealSwaps(
        mealName: String,
        dietType: String,
        restrictions: [String],
        goal: String
    ) async throws -> AIMealSwapResponse {
        
        let payload: [String: Any] = [
            "mealName": mealName,
            "dietType": dietType,
            "restrictions": restrictions,
            "goal": goal
        ]
        
        let data = try await postJSON(
            endpoint: "/ai/meal-swap",
            payload: payload
        )
        
        return try decode(AIMealSwapResponse.self, from: data)
    }
    
    func askNutritionCoach(
        question: String,
        profile: UserProfile?
    ) async throws -> AINutritionCoachResponse {
        
        let profilePayload: [String: Any] = [
            "firstName": profile?.firstName ?? "",
            "lastName": profile?.lastName ?? "",
            "age": profile?.age ?? "",
            "height": profile?.height ?? "",
            "weight": profile?.weight ?? "",
            "disease": profile?.disease ?? ""
        ]
        
        let payload: [String: Any] = [
            "question": question,
            "profile": profilePayload
        ]
        
        let data = try await postJSON(
            endpoint: "/ai/nutrition-coach",
            payload: payload
        )
        
        return try decode(AINutritionCoachResponse.self, from: data)
    }
    
    private func postJSON(
        endpoint: String,
        payload: [String: Any]
    ) async throws -> Data {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw URLError(.badURL)
        }
        
        print("Calling API:", url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try validateResponse(response, data: data)
        
        return data
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code:", httpResponse.statusCode)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Backend response:")
            print(jsonString)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("JSON Decode Error:", error)
            throw error
        }
    }
}
