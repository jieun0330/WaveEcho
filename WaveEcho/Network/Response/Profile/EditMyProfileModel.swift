//
//  EditMyProfileResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import Foundation

struct EditMyProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let followers: [Followers?]
    let following: [Following?]
    let posts: [String?]
}

struct Followers: Decodable {
    let user_id: String?
    let nick: String?
    let profileImage: String?
}

struct Following: Decodable {
    let user_id: String?
    let nick: String?
    let profileImage: String?
}
