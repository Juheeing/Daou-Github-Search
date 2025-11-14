//
//  Repository.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation

struct RepositoryResponse: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
}

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String?
    let description: String?
    let starCount: Int?
    let language: String?
    let owner: Owner
    let license: License?
    var isStarred: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name, description, owner, language, license
        case fullName = "full_name"
        case starCount = "stargazers_count"
    }
}
