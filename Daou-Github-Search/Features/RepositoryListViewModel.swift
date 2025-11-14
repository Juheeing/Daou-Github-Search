//
//  RepositoryListViewModel.swift
//  Daou-Github-Search
//
//  Created by 김주희 on 11/14/25.
//

import Foundation
import Combine

class RepositoryListViewModel: ObservableObject {
    let client: GitHubClientProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var repositories: [Repository] = []
    @Published var starredRepos: [Repository] = []

    init(client: GitHubClientProtocol) {
        self.client = client
    }

    func fetchStarredRepos() {
        client.myStarredRepositories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] repos in
                guard let self = self else { return }
                self.starredRepos = repos.map { repo in
                    var r = repo
                    r.isStarred = true
                    return r
                }
                self.repositories = self.repositories.map { repo in
                    var r = repo
                    r.isStarred = self.starredRepos.contains(where: { $0.id == repo.id })
                    return r
                }
            })
            .store(in: &cancellables)
    }

    func searchRepositories(query: String) {
        guard !query.isEmpty else {
            self.repositories.removeAll()
            return
        }
        client.searchRepositories(query: query, perPage: 30, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.repositories = response.items.map { repo in
                    var r = repo
                    r.isStarred = self.starredRepos.contains(where: { $0.id == repo.id })
                    return r
                }
            })
            .store(in: &cancellables)
    }

    func toggleStar(_ repo: Repository) {
        if repo.isStarred {
            client.unstar(owner: repo.owner.name, repo: repo.name)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                    guard let self = self else { return }
                    if let index = self.repositories.firstIndex(where: { $0.id == repo.id }) {
                        self.repositories[index].isStarred = false
                    } else if let index = self.starredRepos.firstIndex(where: { $0.id == repo.id }) {
                        self.starredRepos[index].isStarred = false
                    }
                })
                .store(in: &cancellables)
        } else {
            client.star(owner: repo.owner.name, repo: repo.name)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                    guard let self = self else { return }
                    if let index = self.repositories.firstIndex(where: { $0.id == repo.id }) {
                        self.repositories[index].isStarred = true
                    } else if let index = self.starredRepos.firstIndex(where: { $0.id == repo.id }) {
                        self.starredRepos[index].isStarred = false
                    }
                })
                .store(in: &cancellables)
        }
    }
}
