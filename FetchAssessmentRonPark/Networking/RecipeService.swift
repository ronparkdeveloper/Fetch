//
//  RecipeService.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/3/24.
//

import Foundation

class RecipeService {
    var endpointURL: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

    func fetchRecipes() async throws -> [Recipe] {
        let (data, _) = try await URLSession.shared.data(from: endpointURL)
        let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return decodedResponse.recipes.filter { !$0.id.isEmpty && !$0.name.isEmpty && !$0.cuisine.isEmpty }
    }
}


