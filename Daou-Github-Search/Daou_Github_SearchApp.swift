//
//  Daou_Github_SearchApp.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/22/25.
//

import SwiftUI
import Alamofire

@main
struct Daou_Github_SearchApp: App {
    
    private let loginService: GitHubLoginService

    init() {
        let keychain = KeychainServiceImplement()
        let session = Session(interceptor: AuthInterceptor(keychain: keychain))
        let client: GitHubClientProtocol = GitHubClient(session: session)
        self.loginService = GitHubLoginServiceImplement(client: client, keychainService: keychain)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(loginService: loginService)
                .onOpenURL { url in
                    print("Received URL: \(url)")
                    _ = loginService.handle(url)
                }
        }
    }
}
