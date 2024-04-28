//
//  WriteCommentResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import Foundation

struct WriteCommentResponse: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: [Creator]
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String
}
