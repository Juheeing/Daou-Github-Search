# Daou-Github-Search

GitHub OAuth 로그인, 레포지토리 검색, Star/Unstar, 내 Starred 목록 조회 기능을 포함한 iOS 앱입니다.  
SwiftUI + Combine + MVVM 구조로 구현되었습니다.

---

## 📱 주요 기능

### 🔐 GitHub OAuth 로그인
- GitHub OAuth 인증을 통해 사용자 정보를 가져옵니다.
- 로그인 후 유저 프로필, Starred Repository 목록 등을 사용할 수 있습니다.

### 🔍 레포지토리 검색
- GitHub 검색 API 기반으로 레포지토리를 검색합니다.
- 검색된 레포지토리의 Star 여부가 실시간으로 표시됩니다.

### ⭐ Star / Unstar
- 검색 결과에서 바로 Star/Unstar 가능합니다.
- 프로필 화면에서 Starred Repository 목록 확인 가능
- 리스트에서 스와이프하거나 버튼을 눌러 Star 상태 토글 가능

### 🔄 Pull to Refresh
- 프로필 화면에서 아래로 당겨 새로고침(Pull To Refresh)를 통해 최신 Star 상태를 갱신합니다.

### ⚠️ 주의: 새로고침 시 목록이 즉시 반영되지 않을 수 있습니다. 
- 이는 GitHub API 특성으로, 잠시 후 새로고침하면 최신 상태가 표시됩니다.

---

## 🔧 빌드 전 필수 설정

### 1. GitHub OAuth App 생성
아래 URL에서 GitHub OAuth App을 생성하세요.

[GitHub Developer Settings](https://github.com/settings/developers)

### 2. 발급된 Client ID & Client Secret 입력

이 프로젝트는 OAuth 로그인 시 **반드시 GitHub에서 직접 발급받은 client_id, client_secret** 값을 넣어야 합니다.  
코드를 빌드하기 위해 아래 부분에 본인의 값을 입력하세요.

```swift
let clientID = "YOUR_CLIENT_ID"
let clientSecret = "YOUR_CLIENT_SECRET"

