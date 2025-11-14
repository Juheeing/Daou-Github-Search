//
//  CurrentUser.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation

struct CurrentUser: Codable {
    let username: String
    let userBio: String?
    let userProfileImageURL: URL?

    enum CodingKeys: String, CodingKey{
        case username = "login"
        case userBio = "bio"
        case userProfileImageURL = "avatar_url"
    }
}
