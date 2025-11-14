//
//  SearchRootView.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import SwiftUI
import Combine

struct SearchRootView: View {
    @StateObject private var viewModel: RepositoryListViewModel
    @Binding var isLoggedIn: Bool
    @State private var query: String = ""

    init(loginService: GitHubLoginService, isLoggedIn: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: RepositoryListViewModel(client: loginService.client))
        self._isLoggedIn = isLoggedIn
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search repositories", text: $query)
                        .onChange(of: query) { newValue in
                            viewModel.searchRepositories(query: newValue)
                        }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                ForEach($viewModel.repositories) { $repo in
                    RepositoryCellView(repository: repo, isStarred: $repo.isStarred) {
                        if isLoggedIn {
                            viewModel.toggleStar(repo)
                        }
                    }
                }
            }
            .refreshable {
                if isLoggedIn {
                    viewModel.fetchStarredRepos()
                }
            }
            .onAppear {
                if isLoggedIn {
                    viewModel.fetchStarredRepos()
                }
            }
        }
    }
}


