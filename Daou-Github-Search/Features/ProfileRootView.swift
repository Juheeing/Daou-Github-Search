//
//  ProfileRootView.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import SwiftUI

struct ProfileRootView: View {
    private let loginService: GitHubLoginService
    @Binding var isLoggedIn: Bool
    @Binding var showLogin: Bool   // 로그인 버튼 클릭 시 모달 띄우기용

    init(loginService: GitHubLoginService,
         isLoggedIn: Binding<Bool>,
         showLogin: Binding<Bool>) {
        self.loginService = loginService
        self._isLoggedIn = isLoggedIn
        self._showLogin = showLogin
    }

    var body: some View {
        VStack {
            if isLoggedIn {
                ProfileView(loginService: loginService)
            } else {
                VStack(spacing: 16) {
                    Button(action: {
                        showLogin = true
                    }) {
                        Text("로그인")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    Text("로그인 해주세요.")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

