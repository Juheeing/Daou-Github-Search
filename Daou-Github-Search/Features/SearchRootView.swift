//
//  SearchRootView.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import SwiftUI
import Combine

struct SearchRootView: View {
    private let loginService: GitHubLoginService
    @Binding var isLoggedIn: Bool
    @State private var query: String = ""
    @State private var repositories: [Repository] = []
    @State private var starredRepos: [Repository] = []
    @State private var cancellables = Set<AnyCancellable>()

    init(loginService: GitHubLoginService,
         isLoggedIn: Binding<Bool>) {
        self.loginService = loginService
        self._isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search repositories", text: $query)
                        .onChange(of: query) { _ in
                            searchRepositories()
                        }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                ForEach($repositories) { $repo in
                    RepositoryCellView(repository: repo, isStarred: $repo.isStarred) {
                        toggleStar(repo)
                    }
                }
            }
            .onAppear {
                if isLoggedIn {
                    fetchMyStarredRepos()
                }
            }
        }
    }
    
    private func fetchMyStarredRepos() {
        loginService.client.myStarredRepositories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { repos in
                self.starredRepos = repos
                // 검색 결과와 Starred 비교 후 isStarred 업데이트
                self.repositories = self.repositories.map { repo in
                    var r = repo
                    r.isStarred = self.starredRepos.contains(where: { $0.id == repo.id })
                    return r
                }
            })
            .store(in: &cancellables)
    }
    
    private func searchRepositories() {
        guard !query.isEmpty else {
            repositories.removeAll()
            return
        }

        loginService.client.searchRepositories(query: query, perPage: 30, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                // 검색 결과에 로그인 유저의 Starred 여부 반영
                self.repositories = response.items.map { repo in
                    var r = repo
                    if isLoggedIn {
                        r.isStarred = starredRepos.contains(where: { $0.id == repo.id })
                    }
                    return r
                }
            })
            .store(in: &cancellables)
    }
    
    private func toggleStar(_ repo: Repository) {
        if repo.isStarred {
            loginService.client.unstar(owner: repo.owner.name, repo: repo.name)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    if let index = repositories.firstIndex(where: { $0.id == repo.id }) {
                        repositories[index].isStarred = false
                    }
                    if let index = starredRepos.firstIndex(where: { $0.id == repo.id }) {
                        starredRepos.remove(at: index)
                    }
                })
                .store(in: &cancellables)
        } else {
            loginService.client.star(owner: repo.owner.name, repo: repo.name)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    if let index = repositories.firstIndex(where: { $0.id == repo.id }) {
                        repositories[index].isStarred = true
                    }
                    starredRepos.append(repo)
                })
                .store(in: &cancellables)
        }
    }
}

