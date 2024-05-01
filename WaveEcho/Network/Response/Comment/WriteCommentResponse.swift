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
    let creator: Creator
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
    
//    init(user_id: String, nick: String, profileImage: String) {
//        self.user_id = user_id
//        self.nick = nick
//        self.profileImage = profileImage
//    }
//    
//    enum CodingKeys: CodingKey {
//        case user_id
//        case nick
//        case profileImage
//    }
//    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.user_id = try container.decode(String.self, forKey: .user_id)
//        self.nick = try container.decode(String.self, forKey: .nick)
//        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
//    }

}
