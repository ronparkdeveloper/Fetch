//
//  RecipeListView.swift
//  FetchAssessmentRonPark
//
//  Created by Ron Park on 12/3/24.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var showURLMenu = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    Picker("Sort By", selection: $viewModel.sortOrder) {
                        ForEach(SortOrder.allCases) { sortOrder in
                            Text(sortOrder.rawValue).tag(sortOrder)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color(.systemBackground))
                    .zIndex(1)
                    .disabled(viewModel.errorMessage != nil || viewModel.recipes.isEmpty)

                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if let errorMessage = viewModel.errorMessage {
                        Spacer()
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else if viewModel.sortedRecipes.isEmpty {
                        Spacer()
                        Text("No recipes available.")
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        List(viewModel.sortedRecipes) { recipe in
                            RecipeRowView(recipe: recipe)
                        }
                        .refreshable {
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                            await viewModel.loadRecipes()
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Menu {
                            Button(action: {
                                viewModel.changeURL(to: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
                            }) {
                                Label("Default URL", systemImage: viewModel.selectedURL == "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json" ? "checkmark" : "")
                            }
                            Button(action: {
                                viewModel.changeURL(to: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
                            }) {
                                Label("Malformed Data URL", systemImage: viewModel.selectedURL == "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json" ? "checkmark" : "")
                            }
                            Button(action: {
                                viewModel.changeURL(to: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
                            }) {
                                Label("Empty Data URL", systemImage: viewModel.selectedURL == "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json" ? "checkmark" : "")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadRecipes()
                }
            }
        }
    }
}

#Preview {
    RecipeListView()
}
