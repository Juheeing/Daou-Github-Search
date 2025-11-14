//
//  ProfileView.swift
//  Daou-Github-Search
//
//  Created by 김주희 on 11/14/25.
//

import SwiftUI
import Combine

struct ProfileView: View {
    let loginService: GitHubLoginService
    @State private var starredRepos: [Repository] = []
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ProfileHeaderView(client: loginService.client)

                if starredRepos.isEmpty {
                    Text("Starred 레포지토리가 없습니다.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach($starredRepos, id: \.id) { $repo in
                        RepositoryCellView(repository: repo, isStarred: $repo.isStarred) { 
                            toggleStar(repo)
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await refreshStarredRepos()
        }
        .onAppear {
            fetchStarredRepos()
        }
    }

    private func fetchStarredRepos() {
        loginService.client.myStarredRepositories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Starred repo fetch error: \(error)")
                }
            }, receiveValue: { repos in
                self.starredRepos = repos.map { repo in
                    var r = repo
                    r.isStarred = true
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
                    if let index = starredRepos.firstIndex(where: { $0.id == repo.id }) {
                        starredRepos[index].isStarred = false
                    }
                })
                .store(in: &cancellables)
        } else {
            loginService.client.star(owner: repo.owner.name, repo: repo.name)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    if let index = starredRepos.firstIndex(where: { $0.id == repo.id }) {
                        starredRepos[index].isStarred = true
                    }
                })
                .store(in: &cancellables)
        }
    }

    private func refreshStarredRepos() async {
        let reposPublisher = loginService.client.myStarredRepositories()
        let repos = await withCheckedContinuation { continuation in
            reposPublisher
                .sink(receiveCompletion: { _ in },
                      receiveValue: { repos in
                    continuation.resume(returning: repos)
                })
                .store(in: &cancellables)
        }
        self.starredRepos = repos.map { repo in
            var r = repo
            r.isStarred = true
            return r
        }
    }
}

struct ProfileHeaderView: View {
    let client: GitHubClientProtocol
    @State private var profile: CurrentUser?
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack(spacing: 8) {
            if let imageUrl = profile?.userProfileImageURL {
                AsyncImage(url: imageUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 90, height: 90)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 90, height: 90)
            }

            Text(profile?.username ?? "")
                .font(.title3)
                .bold()

            Text(profile?.userBio ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .onAppear {
            fetchProfile()
        }
    }

    private func fetchProfile() {
        client.myProfile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Profile fetch error: \(error)")
                }
            }, receiveValue: { user in
                self.profile = user
            })
            .store(in: &cancellables)
    }
}
