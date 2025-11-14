//
//  Daou_Github_SearchTests.swift
//  Daou-Github-SearchTests
//
//  Created by 김주희 on 11/14/25.
//

import XCTest
import Combine
@testable import Daou_Github_Search
import Alamofire

final class GitHubLoginServiceTests: XCTestCase {
    
    private var client: MockGitHubClient!
    private var keychain: MockKeychainService!
    private var service: GitHubLoginServiceImplement!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        client = MockGitHubClient()
        keychain = MockKeychainService()
        service = GitHubLoginServiceImplement(client: client, keychainService: keychain)
        cancellables = []
    }
    
    override func tearDown() {
        client = nil
        keychain = nil
        service = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testHandleURL_savesTokenAndPublishes() {
        let expectation = XCTestExpectation(description: "loginCompletedPublisher emits")
        
        let testURL = URL(string: "daougithubsearch://login?code=1234")!
        
        service.loginCompletedPublisher
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        let result = service.handle(testURL)
        
        XCTAssertTrue(result, "handle(_:) should return true for valid callback URL")
        XCTAssertTrue(client.accessTokenCalled, "GitHubClient.accessToken should be called")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(keychain.accessToken(), "mock_token", "Token should be saved in Keychain")
    }
    
    func testHandleURL_invalidURL_returnsFalse() {
        let invalidURL = URL(string: "daougithubsearch://wrong?code=1234")!
        let result = service.handle(invalidURL)
        XCTAssertFalse(result, "handle(_:) should return false for invalid URL")
    }
    
    func testLogout_removesToken() {
        keychain.set("some_token")
        XCTAssertEqual(keychain.accessToken(), "some_token")
        
        service.logout()
        
        XCTAssertNil(keychain.accessToken(), "Token should be removed after logout")
    }
}

// MARK: - Mock Implementations

final class MockKeychainService: KeychainService {
    var storedToken: String?
    
    func accessToken() -> String? { storedToken }
    func set(_ accessToken: String) { storedToken = accessToken }
    func removeAccessToken() { storedToken = nil }
}

final class MockGitHubClient: GitHubClientProtocol {
    
    var accessTokenCalled = false
    
    func accessToken(clientID: String, clientSecret: String, code: String) -> AnyPublisher<GitHubAccessToken, AFError> {
        accessTokenCalled = true
        let token = GitHubAccessToken(value: "mock_token")
        return Just(token).setFailureType(to: AFError.self).eraseToAnyPublisher()
    }
    
    func searchRepositories(query: String, perPage: Int, page: Int) -> AnyPublisher<RepositoryResponse, AFError> { fatalError() }
    func myProfile() -> AnyPublisher<CurrentUser, AFError> { fatalError() }
    func myStarredRepositories() -> AnyPublisher<[Repository], AFError> { fatalError() }
    func star(owner: String, repo: String) -> AnyPublisher<Void, AFError> { fatalError() }
    func unstar(owner: String, repo: String) -> AnyPublisher<Void, AFError> { fatalError() }
}
