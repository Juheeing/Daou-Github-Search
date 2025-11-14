//
//  License.swift
//  Daou-Github-Search
//
//  Created by daou-mrlhs on 8/25/25.
//

import Foundation

struct License: Codable {
    let key: String?
    let name: String?
    let spdxId: String?

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxId = "spdx_id"
    }
}
