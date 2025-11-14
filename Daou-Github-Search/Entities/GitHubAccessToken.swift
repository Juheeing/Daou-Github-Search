//
//  GitHubAccessToken.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/22/25.
//

import Foundation

struct GitHubAccessToken: Codable {
    let value: String
    
    enum CodingKeys: String, CodingKey { case value = "access_token" }
}
