//
//  GitHubLoginViewController.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import UIKit
import SafariServices

final class GitHubLoginViewController: SFSafariViewController {
    
    private let gitHubLoginService: GitHubLoginService
    
    init(gitHubLoginService: GitHubLoginService) {
        self.gitHubLoginService = gitHubLoginService
        let url = Self.gitHubLoginURL()
        let configuration = SFSafariViewController.Configuration()
        super.init(url: url, configuration: configuration)
        self.modalPresentationStyle = .pageSheet
    }

    private static func gitHubLoginURL() -> URL {
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(GitHubLoginServiceImplement.Constants.clientID)&scope=public_repo&redirect_uri=\(GitHubLoginServiceImplement.Constants.callbackScheme)://\(GitHubLoginServiceImplement.Constants.callbackHost)"
        return URL(string: urlString)!
    }
}
