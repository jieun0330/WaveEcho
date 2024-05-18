//
//  ChatModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import Foundation

struct ChatModel: Decodable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [Participants]
}

struct Participants: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
