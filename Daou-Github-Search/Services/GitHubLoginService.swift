//
//  GitHubLoginService.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation
import Combine
import Alamofire
import UIKit

protocol GitHubLoginService: AnyObject {
    var loginCompletedPublisher: AnyPublisher<Void, Never> { get }
    func handle(_ url: URL) -> Bool
}

final class GitHubLoginServiceImplement: GitHubLoginService {
    
    enum Constants {
        static let clientID = "YOUR_CLIENT_ID"
        static let clientSecret = "YOUR_CLIENT_SECRET"
        static let callbackScheme = "daougithubsearch"
        static let callbackHost = "login"
    }

    private let client: GitHubClientProtocol
    private let keychainService: KeychainService
    private var cancellables = Set<AnyCancellable>()
    
    private let loginCompletedSubject = PassthroughSubject<Void, Never>()
    var loginCompletedPublisher: AnyPublisher<Void, Never> {
        loginCompletedSubject.eraseToAnyPublisher()
    }
    
    init(client: GitHubClientProtocol, keychainService: KeychainService) {
        self.client = client
        self.keychainService = keychainService
    }
    
    func handle(_ url: URL) -> Bool {
        guard url.scheme == Constants.callbackScheme,
              url.host == Constants.callbackHost,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            return false
        }

        client.accessToken(clientID: Constants.clientID, clientSecret: Constants.clientSecret, code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("OAuth error: \(error)")
                }
            }, receiveValue: { [weak self] token in
                self?.keychainService.set(token.value)
                self?.loginCompletedSubject.send()
            })
            .store(in: &cancellables)

        return true
    }
}
