//
//  RecipeServiceTests.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/4/24.
//

import XCTest
@testable import FetchAssessmentRonPark

final class RecipeServiceTests: XCTestCase {
    func testFetchRecipesValidURL() async throws {
        let service = RecipeService()
        service.endpointURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

        let recipes = try await service.fetchRecipes()
        XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty for a valid URL")
    }

    func testFetchRecipesInvalidURL() async throws {
        let service = RecipeService()
        service.endpointURL = URL(string: "https://invalid-url.com")!

        do {
            _ = try await service.fetchRecipes()
            XCTFail("Fetching should fail for an invalid URL")
        } catch {
            XCTAssertTrue(error is URLError, "Error should be of type URLError")
        }
    }
}
