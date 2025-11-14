//
//  GitHubEndpoints.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation
import Alamofire

enum GitHubAPI {
    // Auth
    case accessToken(clientID: String, clientSecret: String, code: String)
    // Search
    case repositories(query: String, perPage: Int, page: Int)
    // My
    case myProfile
    case myStarredRepositories
    // Star & Unstar
    case star(owner: String, repository: String)
    case unstar(owner: String, repository: String)
}

extension GitHubAPI: URLRequestConvertible {
    
    var baseURL: URL {
        switch self {
        case .accessToken: return URL(string: "https://github.com")!
        default: return URL(string: "https://api.github.com")!
        }
    }

    var method: HTTPMethod {
        switch self {
        case .accessToken: return .post
        case .repositories, .myProfile, .myStarredRepositories: return .get
        case .star: return .put
        case .unstar: return .delete
        }
    }

    var path: String {
        switch self {
        case .accessToken: return "/login/oauth/access_token"
        case .repositories: return "/search/repositories"
        case .myProfile: return "/user"
        case .myStarredRepositories: return "/user/starred"
        case let .star(owner, repo), let .unstar(owner, repo):
            return "/user/starred/\(owner)/\(repo)"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")


        switch self {
        case let .accessToken(clientID, clientSecret, code):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let params = ["client_id": clientID, "client_secret": clientSecret, "code": code]
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case let .repositories(query, perPage, page):
            let items: [URLQueryItem] = [
                .init(name: "q", value: query),
                .init(name: "per_page", value: String(perPage)),
                .init(name: "page", value: String(page))
            ]
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            comps.queryItems = items
            request.url = comps.url
        case .myProfile, .myStarredRepositories, .star, .unstar:
            break
        }
        return request
    }
}
