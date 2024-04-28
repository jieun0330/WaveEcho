//
//  PostsResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/16/24.
//

import Foundation

struct WritePostsResponse: Decodable {
    let post_id: String
    let product_id: String
    let content: String
    let createdAt: String
    let creator: CreatorInfo
    let files: [String]
}

struct CreatorInfo: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
