//
//  GitHubLoginSheet.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import SwiftUI

struct GitHubLoginSheet: UIViewControllerRepresentable {

    private let loginService: GitHubLoginService
    
    init(loginService: GitHubLoginService) {
        self.loginService = loginService
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> GitHubLoginViewController {
        let vc = GitHubLoginViewController(gitHubLoginService: loginService)
        return vc
    }

    func updateUIViewController(_ uiViewController: GitHubLoginViewController, context: Context) {}

    final class Coordinator: NSObject {
        private let parent: GitHubLoginSheet
        init(_ parent: GitHubLoginSheet) {
            self.parent = parent
        }
    }
}
