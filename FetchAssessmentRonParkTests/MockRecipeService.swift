//
//  MockRecipeService.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/4/24.
//

import XCTest
@testable import FetchAssessmentRonPark

class MockRecipeService: RecipeService {
    private let mockRecipes: [Recipe]
    private let shouldFail: Bool

    init(recipes: [Recipe], shouldFail: Bool = false) {
        self.mockRecipes = recipes
        self.shouldFail = shouldFail
        super.init()
    }

    override func fetchRecipes() async throws -> [Recipe] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return mockRecipes
    }
}
