import SwiftUI

struct SmartGroceryIntegrationView: View {
    @State private var items: [SmartGroceryItem] = [
        SmartGroceryItem(name: "Rice", quantity: "5 lb", category: "Grains", estimatedPrice: 6.99, pantryAvailable: false),
        SmartGroceryItem(name: "Milk", quantity: "1 gallon", category: "Dairy", estimatedPrice: 3.99, pantryAvailable: false),
        SmartGroceryItem(name: "Tomatoes", quantity: "6", category: "Vegetables", estimatedPrice: 2.99, pantryAvailable: false),
        SmartGroceryItem(name: "Paneer", quantity: "1 pack", category: "Protein", estimatedPrice: 5.99, pantryAvailable: false)
    ]

    @State private var links: [GroceryStoreLink] = []
    @State private var checklist: [GroceryChecklistItem] = []
    @State private var costEstimate: CostEstimateResponse?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    groceryItemsSection

                    Button("Generate Smart Grocery Tools") {
                        Task {
                            await loadSmartGroceryData()
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    if let costEstimate {
                        costSection(costEstimate)
                    }

                    checklistSection

                    storeLinksSection
                }
                .padding()
            }
            .navigationTitle("Smart Grocery")
        }
    }

    private var groceryItemsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Grocery Items")
                .font(.headline)

            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.subheadline)
                            .bold()
                        Text(item.quantity)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("$\(item.estimatedPrice, specifier: "%.2f")")
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)
            }
        }
    }

    private func costSection(_ cost: CostEstimateResponse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Estimated Cost by Store")
                .font(.headline)

            Text("Walmart: $\(cost.walmart, specifier: "%.2f")")
            Text("Instacart: $\(cost.instacart, specifier: "%.2f")")
            Text("Amazon Fresh: $\(cost.amazonFresh, specifier: "%.2f")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }

    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Need to Buy Checklist")
                .font(.headline)

            ForEach($checklist) { $item in
                Toggle("\(item.quantity) \(item.name)", isOn: $item.checked)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var storeLinksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Store Links")
                .font(.headline)

            ForEach(links) { link in
                VStack(alignment: .leading, spacing: 8) {
                    Text(link.name)
                        .bold()

                    Link("Open in Walmart", destination: URL(string: link.walmart)!)
                    Link("Open in Instacart", destination: URL(string: link.instacart)!)
                    Link("Open in Amazon Fresh", destination: URL(string: link.amazonFresh)!)
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)
            }
        }
    }

    private func loadSmartGroceryData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let storeLinks = SmartGroceryAPI.shared.fetchStoreLinks(items: items)
            async let needToBuy = SmartGroceryAPI.shared.fetchNeedToBuyChecklist(items: items)
            async let cost = SmartGroceryAPI.shared.fetchCostEstimate(items: items)

            links = try await storeLinks
            checklist = try await needToBuy
            costEstimate = try await cost
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
//
//  SmartGroceryIntegrationView.swift
//  MealPlanner
//
//  Created by Ritesh Vyas on 6/13/26.
//

