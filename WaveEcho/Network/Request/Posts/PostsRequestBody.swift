//
//  PostsRequestBody.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import Foundation

struct PostsRequestBody: Encodable {
    let content: String?
    let product_id: String?
    let files: [String]?
}
