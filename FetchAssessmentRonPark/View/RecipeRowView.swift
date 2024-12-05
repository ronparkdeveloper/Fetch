//
//  RecipeRowView.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/3/24.
//

import SwiftUI
import Kingfisher

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack(alignment: .top) {
            KFImage(recipe.photoURLSmall)
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
