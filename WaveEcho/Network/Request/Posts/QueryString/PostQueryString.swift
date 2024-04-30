//
//  FetchPostQuery.swift
//  WaveEcho
//
//  Created by 박지은 on 4/21/24.
//

import Foundation

struct PostQueryString: Codable {
    let next: String
    let limit: String
    let product_id: String
}
