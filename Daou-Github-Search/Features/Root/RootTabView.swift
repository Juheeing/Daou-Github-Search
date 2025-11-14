//
//  RootTabView.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import SwiftUI

struct RootTabView: View {
    private let loginService: GitHubLoginService
    @State private var showLogin = false
    @State private var isLoggedIn = false
    @State private var toastMessage: String = ""
    @State private var showToast = false

    init(loginService: GitHubLoginService) {
        self.loginService = loginService
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                SearchRootView(loginService: loginService, isLoggedIn: $isLoggedIn)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("GitHub").font(.headline)
                        }
                    }
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }

            NavigationStack {
                ProfileRootView(
                    loginService: loginService,
                    isLoggedIn: $isLoggedIn,
                    showLogin: $showLogin
                )
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("GitHub").font(.headline)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(isLoggedIn ? "로그아웃" : "로그인") {
                            if isLoggedIn {
                                loginService.logout()
                                isLoggedIn = false
                                showToastMessage("로그아웃 되었습니다")
                            } else {
                                showLogin = true
                            }
                        }
                    }
                }
            }
            .tabItem { Label("Profile", systemImage: "person") }
        }
        .sheet(isPresented: $showLogin) {
            GitHubLoginSheet(loginService: loginService)
        }
        .onReceive(loginService.loginCompletedPublisher) {
            showLogin = false
            isLoggedIn = true
            showToastMessage("로그인에 성공하였습니다")
        }
        .onAppear {
            isLoggedIn = loginService.isLoggedIn
            if isLoggedIn {
                showToastMessage("자동 로그인에 성공하였습니다")
            }
        }
        .toast(isPresented: $showToast, message: toastMessage)
    }
    
    private func showToastMessage(_ message: String, duration: Double = 2) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                showToast = false
            }
        }
    }
}



