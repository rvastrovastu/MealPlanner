import Foundation

final class SmartGroceryAPI {
    static let shared = SmartGroceryAPI()

    private let baseURL = "https://mealplanner-4owd.onrender.com/api"

    private init() {}

    func fetchStoreLinks(items: [SmartGroceryItem]) async throws -> [GroceryStoreLink] {
        let url = URL(string: "\(baseURL)/grocery/store-links")!
        let body = ["items": items]

        let data = try await post(url: url, body: body)
        let decoded = try JSONDecoder().decode(StoreLinksResponse.self, from: data)
        return decoded.links
    }

    func fetchNeedToBuyChecklist(items: [SmartGroceryItem]) async throws -> [GroceryChecklistItem] {
        let url = URL(string: "\(baseURL)/grocery/need-to-buy")!
        let body = ["items": items]

        let data = try await post(url: url, body: body)
        let decoded = try JSONDecoder().decode(NeedToBuyResponse.self, from: data)
        return decoded.checklist
    }

    func fetchCostEstimate(items: [SmartGroceryItem]) async throws -> CostEstimateResponse {
        let url = URL(string: "\(baseURL)/grocery/cost-estimate")!
        let body = ["items": items]

        let data = try await post(url: url, body: body)
        return try JSONDecoder().decode(CostEstimateResponse.self, from: data)
    }

    private func post<T: Encodable>(url: URL, body: T) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
//
//  SmartGroceryAPI.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/13/26.
//

