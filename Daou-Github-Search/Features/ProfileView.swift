//
//  ProfileView.swift
//  Daou-Github-Search
//
//  Created by 김주희 on 11/14/25.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @StateObject private var viewModel: RepositoryListViewModel

    init(loginService: GitHubLoginService) {
        _viewModel = StateObject(wrappedValue: RepositoryListViewModel(client: loginService.client))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ProfileHeaderView(client: viewModel.client)

                if viewModel.starredRepos.isEmpty {
                    Text("Starred 레포지토리가 없습니다.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach($viewModel.starredRepos, id: \.id) { $repo in
                        RepositoryCellView(repository: repo, isStarred: $repo.isStarred) { 
                            viewModel.toggleStar(repo)
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.fetchStarredRepos()
        }
        .onAppear {
            viewModel.fetchStarredRepos()
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
