//
//  RecipeListViewModelTests.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/4/24.
//

import XCTest
@testable import FetchAssessmentRonPark

let populatedRecipes =  [
    Recipe(id: "1", name: "Banana Bread", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil),
    Recipe(id: "2", name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil),
    Recipe(id: "3", name: "Curry", cuisine: "Indian", photoURLSmall: nil, photoURLLarge: nil),
    Recipe(id: "4", name: "Biryani", cuisine: "Indian", photoURLSmall: nil, photoURLLarge: nil),
    Recipe(id: "5", name: "Miso Soup", cuisine: "Japanese", photoURLSmall: nil, photoURLLarge: nil)
]
let emptyRecipes = [Recipe]()

final class RecipeListViewModelTests: XCTestCase {
    @MainActor
    func testLoadRecipesSuccess() async {
        let mockService = MockRecipeService(recipes: populatedRecipes)
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.loadRecipes()
        XCTAssertFalse(viewModel.recipes.isEmpty, "Recipes should be loaded successfully")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil on success")
    }

    @MainActor
    func testLoadRecipesFailure() async {
        let mockService = MockRecipeService(recipes: populatedRecipes, shouldFail: true)
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.loadRecipes()
        XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty on failure")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on failure")
    }

    @MainActor
    func testChangeURLUpdatesRecipes() async {
        let mockService = MockRecipeService(recipes: populatedRecipes)
        let viewModel = RecipeListViewModel(service: mockService)

        viewModel.changeURL(to: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        try! await Task.sleep(nanoseconds: 500_000_000) 
        XCTAssertEqual(viewModel.selectedURL, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json", "Selected URL should be updated")
    }

    @MainActor
    func testSortingByName() async {
        let mockService = MockRecipeService(recipes: populatedRecipes)
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.loadRecipes()
        viewModel.sortOrder = .name

        XCTAssertEqual(
            viewModel.sortedRecipes.map { $0.name },
            ["Apple Pie", "Banana Bread", "Biryani", "Curry", "Miso Soup"],
            "Sorting should be case-insensitive by name"
        )
    }

    @MainActor
    func testSortingByCuisine() async {
        let mockService = MockRecipeService(recipes: populatedRecipes)
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.loadRecipes()
        viewModel.sortOrder = .cuisine

        XCTAssertEqual(
            viewModel.sortedRecipes.map { "\($0.cuisine): \($0.name)" },
            [
                "American: Apple Pie",
                "American: Banana Bread",
                "Indian: Biryani",
                "Indian: Curry",
                "Japanese: Miso Soup"
            ],
            "Sorting should be case-insensitive by cuisine and name"
        )
    }

    @MainActor
    func testEmptyRecipeList() async {
        let mockService = MockRecipeService(recipes: emptyRecipes)
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.loadRecipes()
        XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty when the service returns no data")
        XCTAssertTrue(viewModel.sortedRecipes.isEmpty, "Sorted recipes should also be empty when no data is present")
    }

    @MainActor
    func testDuplicateRecipes() async {
        let duplicateRecipes = [
            Recipe(id: "1", name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil),
            Recipe(id: "1", name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil),
            Recipe(id: "2", name: "Banana Bread", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil)
        ]
        let mockService = MockRecipeService(recipes: duplicateRecipes)
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.loadRecipes()
        XCTAssertEqual(viewModel.recipes.count, 3, "Duplicates should not be filtered out by default")
        XCTAssertEqual(viewModel.sortedRecipes.map { $0.name }, ["Apple Pie", "Apple Pie", "Banana Bread"], "Sorting should handle duplicates correctly")
    }
}
