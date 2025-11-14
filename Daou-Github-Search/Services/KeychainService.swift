//
//  KeychainService.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation
import KeychainAccess

protocol KeychainService {
    func accessToken() -> String?
    func set(_ accessToken: String)
    func removeAccessToken()
}

final class KeychainServiceImplement: KeychainService {
    private enum Constants { static let accessTokenKey = "access_token" }
    private let keychain = Keychain(service: "com.daou.Daou-Github-Search")

    func accessToken() -> String? { keychain[Constants.accessTokenKey] }
    func set(_ accessToken: String) { try? keychain.set(accessToken, key: Constants.accessTokenKey) }
    func removeAccessToken() { try? keychain.remove(Constants.accessTokenKey) }
}
