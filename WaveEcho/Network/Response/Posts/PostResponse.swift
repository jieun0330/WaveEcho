//
//  FetchPostsResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/21/24.
//

import Foundation

struct PostResponse: Decodable {
    let data: [PostData]
}

struct PostData: Decodable {
    let post_id: String
    let product_id: String?
    let content: String?
    let createdAt: String
    let creator: CreatorInfo
    let files: [String]?
    var likes: [String]?
    var comments: [CommentData]
}

struct CreatorInfo: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct CommentData: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: CreatorInfo
}
