//
//  FetchAssessmentRonParkApp.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/3/24.
//

import SwiftUI
import Kingfisher

@main
struct FetchAssessmentRonParkApp: App {
    init() {
        configureKingfisherCache()
    }
    
    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }
    }
    
    private func configureKingfisherCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 100
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 500
    }
}
