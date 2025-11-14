//
//  GitHubClient.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation
import Alamofire
import Combine

protocol GitHubClientProtocol {
    func accessToken(clientID: String, clientSecret: String, code: String) -> AnyPublisher<GitHubAccessToken, AFError>
    func searchRepositories(query: String, perPage: Int, page: Int) -> AnyPublisher<RepositoryResponse, AFError>
    func myProfile() -> AnyPublisher<CurrentUser, AFError>
    func myStarredRepositories() -> AnyPublisher<[Repository], AFError>
    func star(owner: String, repo: String) -> AnyPublisher<Void, AFError>
    func unstar(owner: String, repo: String) -> AnyPublisher<Void, AFError>
}

final class GitHubClient: GitHubClientProtocol {
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }

    func accessToken(clientID: String, clientSecret: String, code: String) -> AnyPublisher<GitHubAccessToken, AFError> {
        request(.accessToken(clientID: clientID, clientSecret: clientSecret, code: code))
    }

    func searchRepositories(query: String, perPage: Int, page: Int) -> AnyPublisher<RepositoryResponse, AFError> {
        request(.repositories(query: query, perPage: perPage, page: page))
    }

    func myProfile() -> AnyPublisher<CurrentUser, AFError> { request(.myProfile) }
    
    func myStarredRepositories() -> AnyPublisher<[Repository], AFError> { request(.myStarredRepositories) }

    func star(owner: String, repo: String) -> AnyPublisher<Void, AFError> {
        requestVoid(.star(owner: owner, repository: repo))
    }

    func unstar(owner: String, repo: String) -> AnyPublisher<Void, AFError> {
        requestVoid(.unstar(owner: owner, repository: repo))
    }

    private func request<T: Decodable>(_ endpoint: GitHubAPI) -> AnyPublisher<T, AFError> {
        Future { promise in
            self.session.request(endpoint)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value): promise(.success(value))
                    case .failure(let error): promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }

    private func requestVoid(_ endpoint: GitHubAPI) -> AnyPublisher<Void, AFError> {
        Future { promise in
            self.session.request(endpoint)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success: promise(.success(()))
                    case .failure(let error): promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
