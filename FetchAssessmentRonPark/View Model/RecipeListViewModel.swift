//
//  RecipeListViewModel.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/3/24.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var sortOrder: SortOrder = .name
    @Published var selectedURL: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    private let service: RecipeService

    init(service: RecipeService = RecipeService()) {
        self.service = service
    }

    var sortedRecipes: [Recipe] {
        switch sortOrder {
        case .name:
            return recipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cuisine:
            return recipes.sorted {
                $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending
                || ($0.cuisine == $1.cuisine && $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending)
            }
        }
    }

    func loadRecipes() async {
        isLoading = true
        errorMessage = nil

        do {
            recipes = try await service.fetchRecipes()
        } catch {
            errorMessage = "Failed to load recipes. Please try again."
        }

        isLoading = false
    }

    func changeURL(to urlString: String) {
        guard let url = URL(string: urlString) else { return }
        selectedURL = urlString
        service.endpointURL = url
        Task {
            await loadRecipes()
        }
    }
}


enum SortOrder: String, CaseIterable, Identifiable {
    case name = "Name"
    case cuisine = "Cuisine"

    var id: String { rawValue }
}
