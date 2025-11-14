//
//  ProfileRootView.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import SwiftUI

struct ProfileRootView: View {
    private let loginService: GitHubLoginService
    
    init(loginService: GitHubLoginService) {
        self.loginService = loginService
    }

    var body: some View {
        VStack() {
            Text("Profile TODO")
                .font(.title2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
