//
//  ProfileViewModel.swift
//  Daou-Github-Search
//
//  Created by 김주희 on 11/14/25.
//

import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var user: CurrentUser?
    @Published var starredRepos: [Repository] = []
    
    private let loginService: GitHubLoginService
    private var cancellables = Set<AnyCancellable>()
    
    init(loginService: GitHubLoginService) {
        self.loginService = loginService
        fetchProfile()
        fetchStarred()
    }
    
    func fetchProfile() {
        loginService.client.myProfile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Profile fetch error:", error)
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
    }
    
    func fetchStarred() {
        loginService.client.myStarredRepositories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Starred fetch error:", error)
                }
            }, receiveValue: { [weak self] repos in
                self?.starredRepos = repos
            })
            .store(in: &cancellables)
    }
}

