//
//  RepositoryCellView.swift
//  Daou-Github-Search
//
//  Created by 김주희 on 11/14/25.
//

import SwiftUI

struct RepositoryCellView: View {
    let repository: Repository
    @Binding var isStarred: Bool
    let onToggleStar: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(repository.name)
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(repository.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 12) {
                        if let language = repository.language {
                            Text(language)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        if let license = repository.license?.name {
                            Text("· \(license)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        if let stars = repository.starCount {
                            Text("· \(formattedStars(stars))")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    onToggleStar()
                }) {
                    Image(systemName: isStarred ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            Divider()
        }
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private func formattedStars(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count)) ?? "0"
    }
}




