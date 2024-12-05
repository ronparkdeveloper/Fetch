//
//  Recipe.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/3/24.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: String
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name, cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
