//
//  FetchPostsResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/21/24.
//

import Foundation

struct FetchPostsResponse: Decodable {
    let data: [Contents]
}

struct Contents: Decodable {
    let post_id: String
    let product_id: String
    let content: String?
    let createdAt: String
    let creator: PostsCreatorInfo
    let files: [String]?
}

struct PostsCreatorInfo: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
