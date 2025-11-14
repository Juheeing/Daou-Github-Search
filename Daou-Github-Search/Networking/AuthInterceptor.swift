//
//  AuthInterceptor.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    
    private let keychain: KeychainService
    
    init(keychain: KeychainService) {
        self.keychain = keychain
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let token = keychain.accessToken() else { return completion(.success(urlRequest)) }
        var req = urlRequest
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(req))
    }
}
