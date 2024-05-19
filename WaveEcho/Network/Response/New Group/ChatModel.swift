//
//  ChatModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import Foundation

struct ChatModel: Decodable {
    let data: [ChatData]
}

struct ChatData: Decodable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [Participants]
    let lastChat: LastChat?
}

struct Participants: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct LastChat: Decodable {
    let chat_id: String
    let room_id: String
    let content: String
    let createdAt: String
    let sender: Participants
    let files: [String]
}
