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
    var currentLocation = 0 // 서버에는 없는 응답

    enum CodingKeys: CodingKey {
        case post_id
        case product_id
        case content
        case createdAt
        case creator
        case files
        case likes
        case comments
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post_id = try container.decode(String.self, forKey: .post_id)
        self.product_id = try container.decodeIfPresent(String.self, forKey: .product_id)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.creator = try container.decode(CreatorInfo.self, forKey: .creator)
        self.files = try container.decodeIfPresent([String].self, forKey: .files)
        self.likes = try container.decodeIfPresent([String].self, forKey: .likes)
        self.comments = try container.decode([CommentData].self, forKey: .comments)
    }

    init(post_id: String, product_id: String?, content: String?, createdAt: String, creator: CreatorInfo, files: [String]?, likes: [String]? = nil, comments: [CommentData]) {
        self.post_id = post_id
        self.product_id = product_id
        self.content = content
        self.createdAt = createdAt
        self.creator = creator
        self.files = files
        self.likes = likes
        self.comments = comments
    }
}

struct CreatorInfo: Decodable {
    let user_id: String?
    let nick: String?
    let profileImage: String?
}

struct CommentData: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: CreatorInfo
}
